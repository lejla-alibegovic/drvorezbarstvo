namespace WoodTrack.BLL.Mapping;

public class ToolCategoryProfile : BaseProfile
{
    public ToolCategoryProfile()
    {
        CreateMap<ToolCategory, ToolCategoryModel>();
        CreateMap<ToolCategoryUpsertModel, ToolCategory>();
    }
}
