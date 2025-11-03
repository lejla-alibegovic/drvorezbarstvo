namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ToolCategoriesController : BaseCrudController<ToolCategoryModel, ToolCategoryUpsertModel, BaseSearchObject, IToolCategoriesService>
{
    public ToolCategoriesController(
        IToolCategoriesService service,
        ILogger<ToolCategoriesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
