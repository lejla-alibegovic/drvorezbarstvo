namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class CitiesController : BaseCrudController<CityModel, CityUpsertModel, CitiesSearchObject, ICitiesService>
{
    public CitiesController(
        ICitiesService service,
        ILogger<CitiesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
