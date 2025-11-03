namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ReviewsController : BaseCrudController<ReviewModel, ReviewUpsertModel, ReviewsSearchObject, IReviewsService>
{
    public ReviewsController(
        IReviewsService service,
        ILogger<ReviewsController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)

    { }

}
