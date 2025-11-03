namespace WoodTrack.BLL.Mapping
{
    public class ToolProfile : BaseProfile
    {
        public ToolProfile()
        {
            CreateMap<Tool, ToolModel>();

            CreateMap<ToolUpsertModel, Tool>();
        }
    }
}
