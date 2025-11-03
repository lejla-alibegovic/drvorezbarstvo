namespace WoodTrack.BLL;

public interface ICitiesService : IBaseService<int, CityModel, CityUpsertModel, CitiesSearchObject>
{
    Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default);
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? countryId);
}
