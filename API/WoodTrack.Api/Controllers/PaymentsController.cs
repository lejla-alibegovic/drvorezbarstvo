namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class PaymentsController : BaseCrudController<PaymentModel, PaymentUpsertModel, BaseSearchObject, IPaymentsService>
{
    public PaymentsController(
        IPaymentsService service,
        ILogger<PaymentsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
