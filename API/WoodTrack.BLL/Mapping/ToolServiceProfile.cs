namespace WoodTrack.BLL.Mapping;

public class ToolServiceProfile : BaseProfile
{
    public ToolServiceProfile()
    {
        CreateMap<ToolService, ToolServiceModel>();
        CreateMap<ToolServiceUpsertModel, ToolService>();
    }
}
