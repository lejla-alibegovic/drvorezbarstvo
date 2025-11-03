namespace WoodTrack.BLL;

public class UsersService : BaseService<User, int, UserModel, UserUpsertModel, UsersSearchObject>, IUsersService
{
    private readonly IPasswordHasher<User> _passwordHasher;
    private readonly ICrypto _crypto;
    private readonly IEmail _email;
    private readonly IConfiguration _configuration;
    private readonly IRabbitMQProducer _rabbitMQProducer;
    public UsersService(
        IMapper mapper,
        DatabaseContext databaseContext,
        IPasswordHasher<User> passwordHasher,
        ICrypto crypto,
        IEmail email,
        IRabbitMQProducer rabbitMQProducer,
        IConfiguration configuration)
        : base(mapper, databaseContext)
    {
        _passwordHasher = passwordHasher;
        _crypto = crypto;
        _email = email;
        _configuration = configuration;
        _rabbitMQProducer = rabbitMQProducer;
    }

    public override async Task<UserModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        var entity = await DbSet
            .Where(x => x.Id == id)
            .FirstOrDefaultAsync(cancellationToken);

        return Mapper.Map<UserModel>(entity);
    }

    public override async Task<PagedList<UserModel>> GetPagedAsync(UsersSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.Country)
            .Where(x => (searchObject.SearchFilter == null ||
                EF.Functions.ILike(x.UserName!, $"%{searchObject.SearchFilter}%", "\\") ||
                EF.Functions.ILike(x.Email!, $"%{searchObject.SearchFilter}%", "\\")
                || (x.FirstName + " " + x.LastName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                || (x.LastName + " " + x.FirstName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                ) &&
                (searchObject.IsClient == null || searchObject.IsClient.Value && x.UserRoles.Any(x => (x.RoleId == (int)RoleLevel.Client))) &&
                (searchObject.IsEmployee == null || searchObject.IsEmployee.Value && x.UserRoles.Any(x => (x.RoleId == (int)RoleLevel.Employee))))
            .ToPagedListAsync(searchObject, cancellationToken);

        return Mapper.Map<PagedList<UserModel>>(pagedList);
    }

    public async Task<UserLoginDataModel?> FindByUserNameOrEmailAsync(string userName, CancellationToken cancellationToken = default)
    {
        var user = await DbSet
            .AsNoTracking()
            .Include(u => u.UserRoles)
            .ThenInclude(u => u.Role)
            .FirstOrDefaultAsync(u => u.UserName == userName || u.Email == userName);
        return Mapper.Map<UserLoginDataModel>(user);
    }

    public override async Task<UserModel> AddAsync(UserUpsertModel model, CancellationToken cancellationToken = default)
    {
        await CheckUserExist(model.Email);

        User? entity = null;

        var roles = await DatabaseContext.Roles.ToListAsync();

        entity = Mapper.Map<User>(model);

        if (entity.UserRoles == null)
        {
            entity.UserRoles = new List<UserRole>();
        }

        if (model.IsClient)
        {
            entity.UserRoles.Add(new UserRole
            {
                RoleId = roles.Single(x => x.RoleLevel == RoleLevel.Client).Id
            });
        }

        if (model.IsEmployee)
        {
            entity.UserRoles.Add(new UserRole
            {
                RoleId = roles.Single(x => x.RoleLevel == RoleLevel.Employee).Id
            });
        }

        entity.IsActive = true;
        entity.IsFirstLogin = true;
        entity.VerificationSent = true;
        entity.NormalizedEmail = entity.Email?.ToUpper();
        entity.UserName = entity.Email;
        entity.NormalizedUserName = entity.NormalizedEmail;
        entity.PhoneNumberConfirmed = true;
        entity.SecurityStamp = Guid.NewGuid().ToString();
        entity.EmailConfirmed = true;

        var token = _crypto.GenerateSalt();
        token = _crypto.CleanSalt(token);

        var password = _crypto.GeneratePassword();
        entity.PasswordHash = _passwordHasher.HashPassword(new User(), password);

        await DbSet.AddAsync(entity, cancellationToken);
        await DatabaseContext.SaveChangesAsync(cancellationToken);

        var message = EmailMessages.GeneratePasswordEmail($"{entity.FirstName} {entity.LastName}", password);
        await _email.Send(EmailMessages.ConfirmationEmailSubject, message, entity.Email!);

        var email = new EmailModel
        {
            Title = EmailMessages.ConfirmationEmailSubject,
            Body = message,
            Email = entity.Email!,
        };
        //_rabbitMQProducer.SendMessage(email);

        return Mapper.Map<UserModel>(entity);
    }

    public override async Task<UserModel> UpdateAsync(UserUpsertModel model, CancellationToken cancellationToken = default)
    {
        var entity = await DatabaseContext.Users
            .Where(x => x.Id == model.Id)
            .FirstOrDefaultAsync(cancellationToken);

        if (entity == null)
        {
            throw new Exception($"User with identifier {model.Id} was not found");
        }

        entity.FirstName = model.FirstName;
        entity.LastName = model.LastName;
        entity.UserName = model.UserName;
        entity.Email = model.Email;
        entity.PhoneNumber = model.PhoneNumber;
        entity.BirthDate = model.BirthDate;
        entity.Gender = model.Gender;

        if (model.ProfilePhoto != null)
        {
            entity.ProfilePhoto = model.ProfilePhoto;
            entity.ProfilePhotoThumbnail = model.ProfilePhoto;
        }

        if (!string.IsNullOrEmpty(model.OldPassword) && !string.IsNullOrEmpty(model.NewPassword))
        {
            entity.PasswordHash = _passwordHasher.HashPassword(new User(), model.NewPassword);
        }

        entity.Address = model.Address;
        entity.Description = model.Description;
        entity.CountryId = model.CountryId;
        entity.LicenseNumber = model.LicenseNumber;
        entity.WorkingHours = model.WorkingHours;
        entity.YearsOfExperience = model.YearsOfExperience;
        entity.Position = model.Position;

        DbSet.Update(entity);
        await DatabaseContext.SaveChangesAsync(cancellationToken);

        return Mapper.Map<UserModel>(entity);
    }

    private async Task CheckUserExist(string email, User? user = null)
    {
        if ((user == null || user?.Email != email) && (await DbSet.FirstOrDefaultAsync(u => u.Email == email)) != null)
        {
            throw new Exception("UserEmailExist");
        }
    }

    public Task<int> ClientCount(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => x.UserRoles.Any(x => x.RoleId == (int)RoleLevel.Client)
        && x.IsDeleted == false).CountAsync(cancellationToken);
    }

    public Task<int> EmployeeCount(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x =>
            x.UserRoles.Any(x =>
                x.RoleId == (int)RoleLevel.Employee) &&
                x.IsDeleted == false)
            .CountAsync(cancellationToken);
    }

    public async Task<Dictionary<DateTime, int>> GetDailyClientRegistrationsAsync(CancellationToken cancellationToken = default)
    {
        var sevenDaysAgo = DateTime.UtcNow.Date.AddDays(-6);

        var result = await DbSet
            .Where(x => x.UserRoles.Any(r => r.RoleId == (int)RoleLevel.Client)
                        && x.DateCreated >= sevenDaysAgo
                        && x.IsDeleted == false)
            .GroupBy(x => x.DateCreated.Date)
            .Select(g => new { Date = g.Key, Count = g.Count() })
            .ToListAsync(cancellationToken);

        var dailyCounts = Enumerable.Range(0, 7)
            .Select(i => sevenDaysAgo.AddDays(i))
            .ToDictionary(date => date, date => result.FirstOrDefault(r => r.Date == date)?.Count ?? 0);

        return dailyCounts;
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesDropdownItems()
    {
        return await DbSet
            .Where(x => x.UserRoles.Any(role => role.RoleId == (int)RoleLevel.Employee))
            .Select(user => new KeyValuePair<int, string>(user.Id, $"{user.FirstName} {user.LastName}"))
            .ToListAsync();
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetClientsDropdownItems()
    {
        return await DbSet
            .Where(x => x.UserRoles.Any(role => role.RoleId == (int)RoleLevel.Client))
            .Select(user => new KeyValuePair<int, string>(user.Id, $"{user.FirstName} {user.LastName}"))
            .ToListAsync();
    }
}
