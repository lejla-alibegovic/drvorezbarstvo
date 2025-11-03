namespace WoodTrack.BLL;

public interface ICountriesService : IBaseService<int, CountryModel, CountryUpsertModel, BaseSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}
