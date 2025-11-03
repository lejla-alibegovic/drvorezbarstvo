namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class CountriesController : BaseCrudController<CountryModel, CountryUpsertModel, BaseSearchObject, ICountriesService>
{
    public CountriesController(
        ICountriesService service,
        IMapper mapper,
        ILogger<CitiesController> logger,
        IActivityLogsService activityLogs) : base(service, logger, activityLogs)
    {
    }

}
