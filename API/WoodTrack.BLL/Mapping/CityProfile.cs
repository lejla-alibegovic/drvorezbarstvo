namespace WoodTrack.BLL.Mapping;

public class CityProfile : BaseProfile
{
    public CityProfile()
    {
        CreateMap<City, CityModel>();
        CreateMap<CityUpsertModel, City>();
    }
}
