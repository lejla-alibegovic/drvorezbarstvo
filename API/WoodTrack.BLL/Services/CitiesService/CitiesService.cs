namespace WoodTrack.BLL;

public class CitiesService : BaseService<City, int, CityModel, CityUpsertModel, CitiesSearchObject>, ICitiesService
{
    public CitiesService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public override async Task<PagedList<CityModel>> GetPagedAsync(CitiesSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.Country)
            .Where(x => (searchObject.SearchFilter == null ||
                EF.Functions.ILike(x.Name!, $"%{searchObject.SearchFilter}%", "\\")))
            .ToPagedListAsync(searchObject, cancellationToken);

        return Mapper.Map<PagedList<CityModel>>(pagedList);
    }

    public async Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
    {
        var cities = await DbSet.AsNoTracking().Where(c => c.CountryId == countryId).ToListAsync(cancellationToken);

        return Mapper.Map<IEnumerable<CityModel>>(cities);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems(int? countryId)
    {
        return await DbSet.Where(c => countryId == null || c.CountryId == countryId).Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }
}
