namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ProductsController : BaseCrudController<ProductModel, ProductUpsertModel, ProductSearchObject, IProductsService>
{
    private readonly IFileManager _fileManager;
    public ProductsController(
        IFileManager fileManager,
        IProductsService service,
        ILogger<ProductsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        _fileManager = fileManager;
    }

    [HttpPost]
    public override async Task<IActionResult> Post([FromForm] ProductUpsertModel model, CancellationToken cancellationToken = default)
    {
        try
        {
            model.ImageFile = GetFormFile();

            if (model.ImageFile != null)
            {
                model.ImageUrl = await _fileManager.UploadFileAsync(model.ImageFile);
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
    public override async Task<IActionResult> Put([FromForm] ProductUpsertModel upsertModel, CancellationToken cancellationToken = default)
    {
        try
        {
            upsertModel.ImageFile = GetFormFile();

            if (upsertModel.ImageFile != null)
            {
                upsertModel.ImageUrl = await _fileManager.UploadFileAsync(upsertModel.ImageFile);
            }

            if(upsertModel.ImageUrl == null)
            {
                upsertModel.ImageUrl = string.Empty;
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
