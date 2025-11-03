namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class NotificationsController : BaseCrudController<NotificationModel, NotificationUpsertModel, NotificationsSearchObject, INotificationsService>
{
    public NotificationsController(
        INotificationsService service,
        IMapper mapper,
        ILogger<NotificationsController> logger,
        IActivityLogsService activityLogs) : base(service, logger, activityLogs)
    {

    }
}