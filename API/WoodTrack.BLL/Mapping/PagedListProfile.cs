namespace WoodTrack.BLL.Mapping;

public class PagedListProfile : BaseProfile
{
    public PagedListProfile()
    {
        CreateMap(typeof(PagedList<>), typeof(PagedList<>));
    }
}
