namespace WoodTrack.BLL.Mapping;

public class ToolOrderProfile : BaseProfile
{
    public ToolOrderProfile()
    {
        CreateMap<ToolOrder, ToolOrderModel>();
        CreateMap<ToolOrderUpsertModel, ToolOrder>();
    }
}
