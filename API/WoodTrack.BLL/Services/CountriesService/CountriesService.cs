namespace WoodTrack.BLL;

public class CountriesService : BaseService<Country, int, CountryModel, CountryUpsertModel, BaseSearchObject>, ICountriesService
{
    public CountriesService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet.Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}
