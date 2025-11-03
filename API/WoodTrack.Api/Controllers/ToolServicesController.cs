namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ToolServicesController : BaseCrudController<ToolServiceModel, ToolServiceUpsertModel, BaseSearchObject, IToolServicesService>
{
    public ToolServicesController(
        IToolServicesService service,
        IMapper mapper,
        ILogger<ToolServicesController> logger,
        IActivityLogsService activityLogs) : base(service, logger, activityLogs)
    {
        //
    }
}
