namespace WoodTrack.BLL.Mapping;

public class CountryProfile : BaseProfile
{
    public CountryProfile()
    {
        CreateMap<Country, CountryModel>();
        CreateMap<CountryUpsertModel, Country>();
    }
}
