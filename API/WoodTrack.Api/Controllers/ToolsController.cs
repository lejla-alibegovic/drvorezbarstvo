namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ToolsController : BaseCrudController<ToolModel, ToolUpsertModel, ToolSearchObject, IToolsService>
{
    private readonly IFileManager _fileManager;
    public ToolsController(
        IFileManager fileManager,
        IToolsService service,
        ILogger<ToolsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        _fileManager = fileManager;
    }
}
