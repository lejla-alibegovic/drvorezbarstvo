namespace WoodTrack.BLL;

public class ToolsService : BaseService<Tool, int, ToolModel, ToolUpsertModel, ToolSearchObject>, IToolsService
{
    public ToolsService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public override async Task<ToolModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        var query = DbSet
            .Include(x => x.ToolCategory)
            .Include(x => x.ChargedByUser)
            .Include(x => x.Services)
            .Where(x => x.Id == id);

        var entity = await query
            .Select(x => new ToolModel
            {
                Id = x.Id,
                DateCreated = x.DateCreated,
                Name = x.Name,
                Code = x.Code,
                Description = x.Description,
                Dimension = x.Dimension,
                ChargedDate = x.ChargedDate,
                LastServiceDate = x.LastServiceDate,
                ChargedByUserId = x.ChargedByUserId,
                ChargedByUser = x.ChargedByUser == null ? null : Mapper.Map<UserModel>(x.ChargedByUser),
                ToolCategoryId = x.ToolCategoryId,
                ToolCategory = new ToolCategoryModel
                {
                    Id = x.ToolCategory.Id,
                    Name = x.ToolCategory.Name
                },
                IsNeedNewService = x.IsNeedNewService,
                Services = x.Services.Select(s => new ToolServiceModel
                {
                    Id = s.Id,
                    Description = s.Description,
                    NewDimension = s.NewDimension,
                    DeadlineFinishedAt = s.DeadlineFinishedAt,
                    UserId = s.UserId
                }).ToList()
            }).FirstOrDefaultAsync(cancellationToken);

        return Mapper.Map<ToolModel>(entity);
    }

    public override async Task<PagedList<ToolModel>> GetPagedAsync(ToolSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var query = DbSet
            .Include(x => x.ToolCategory)
            .Include(x => x.ChargedByUser)
            .Include(x => x.Services)
            .Where(c =>
                (string.IsNullOrEmpty(searchObject.SearchFilter)
                    || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (!string.IsNullOrEmpty(c.Description) && c.Description.ToLower().Contains(searchObject.SearchFilter.ToLower())))
                && (searchObject.CategoryId == null || searchObject.CategoryId == c.ToolCategoryId)
                && (searchObject.LastServiceDate == null || searchObject.LastServiceDate == c.LastServiceDate)
                && !c.IsDeleted
            );

        var pagedList = await query
            .Select(x => new ToolModel
            {
                Id = x.Id,
                DateCreated = x.DateCreated,
                Name = x.Name,
                Code = x.Code,
                Description = x.Description,
                Dimension = x.Dimension,
                ChargedDate = x.ChargedDate,
                LastServiceDate = x.LastServiceDate,
                ChargedByUserId = x.ChargedByUserId,
                ChargedByUser = x.ChargedByUser == null ? null : Mapper.Map<UserModel>(x.ChargedByUser),
                ToolCategoryId = x.ToolCategoryId,
                ToolCategory = new ToolCategoryModel
                {
                    Id = x.ToolCategory.Id,
                    Name = x.ToolCategory.Name
                },
                IsNeedNewService = x.IsNeedNewService,
                Services = x.Services.Select(s => new ToolServiceModel
                {
                    Id = s.Id,
                    Description = s.Description,
                    NewDimension = s.NewDimension,
                    DeadlineFinishedAt = s.DeadlineFinishedAt,
                    UserId = s.UserId
                }).ToList()
            })
            .ToPagedListAsync(searchObject, cancellationToken);

        return pagedList;
    }

    public override async Task<ToolModel> UpdateAsync(ToolUpsertModel model, CancellationToken cancellationToken = default)
    {
        var entity = await DbSet
            .AsNoTracking()
            .Where(x => x.Id == model.Id)
            .FirstOrDefaultAsync(cancellationToken);

        if (entity == null)
        {
            throw new Exception($"Tool with identifier {model.Id} was not found");
        }

        var services = await DatabaseContext.ToolServices.Where(x => x.ToolId == entity.Id).ToListAsync(cancellationToken);

        var serviceIdsForDelete = model.Services
            .Where(s => s.Id != 0)
            .Select(s => s.Id!.Value);

        var servicesToDelete = services.Where(s => !serviceIdsForDelete.Contains(s.Id));
        var servicesForInsert = Mapper.Map<List<ToolService>>(model.Services.Where(s => s.Id == 0));

        if (servicesToDelete.Any())
        {
            DatabaseContext.ToolServices.RemoveRange(servicesToDelete);
        }

        if (servicesForInsert.Any())
        {
            DatabaseContext.ToolServices.AddRange(servicesForInsert);
        }

        model.Services = default!;

        var updatedEntity = Mapper.Map(model, entity);
        updatedEntity.Services = default!;

        DbSet.Update(updatedEntity);
        await DatabaseContext.SaveChangesAsync(cancellationToken);

        updatedEntity.Services = default!;

        return Mapper.Map<ToolModel>(updatedEntity);
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted).CountAsync(cancellationToken);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}
