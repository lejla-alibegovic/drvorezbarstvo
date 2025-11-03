using Microsoft.AspNetCore.Identity;
using WoodTrack.Core;

namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class UsersController : BaseCrudController<UserModel, UserUpsertModel, UsersSearchObject, IUsersService>
{
    private readonly IFileManager _fileManager;
    private readonly UserManager<User> _userManager;
    private readonly IUsersService _usersService;

    public UsersController(
        IUsersService service,
        ILogger<UsersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper,
        IFileManager fileManager,
        IAccessManager accessManager,
        UserManager<User> userManager,
        IUsersService usersService) : base(service, logger, activityLogs)
    {
        _fileManager = fileManager;
        _userManager = userManager;
        _usersService = usersService;
    }

    [HttpPost]
    public override async Task<IActionResult> Post([FromForm] UserUpsertModel model, CancellationToken cancellationToken = default)
    {
        try
        {
            model.ProfilePhotoFile = GetFormFile();

            if (model.ProfilePhotoFile != null)
            {
                model.ProfilePhoto = await _fileManager.UploadFileAsync(model.ProfilePhotoFile);
            }

            var result = await Service.AddAsync(model, cancellationToken);
            return Ok(result);

        }
        catch (ValidationException e)
        {
            Logger.LogError(e, "Problem when posting resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { model.Id });
            return ValidationResult(e.Errors);
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Problem when posting resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { model.Id });
            return BadRequest();
        }
    }

    [HttpPut]
    public override async Task<IActionResult> Put([FromForm] UserUpsertModel upsertModel, CancellationToken cancellationToken = default)
    {
        try
        {
            upsertModel.ProfilePhotoFile = GetFormFile();

            if (upsertModel.ProfilePhotoFile != null)
            {
                upsertModel.ProfilePhoto = await _fileManager.UploadFileAsync(upsertModel.ProfilePhotoFile);
            }
            if (!string.IsNullOrEmpty(upsertModel.NewPassword))
            {
                var user = await _usersService.FindByUserNameOrEmailAsync(upsertModel.Email);

                if (user == null)
                {
                    throw new Exception("UserNotFound");
                }
                if (!await _userManager.CheckPasswordAsync(new User() { PasswordHash = user.PasswordHash }, upsertModel.OldPassword))
                {
                    throw new Exception("WrongCredentials");
                }
            }

            var dto = await Service.UpdateAsync(upsertModel, cancellationToken);
            return Ok(dto);
        }
        catch (ValidationException e)
        {
            Logger.LogError(e, "Problem when updating resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
            return ValidationResult(e.Errors);
        }
        catch (Exception e)
        {
            Logger.LogError(e, "Problem when updating resource");
            await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e, new List<int?>() { upsertModel.Id });
            return BadRequest();
        }
    }
}
