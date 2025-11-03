namespace WoodTrack.BLL;

public interface IToolsService : IBaseService<int, ToolModel, ToolUpsertModel, ToolSearchObject>
{
    Task<int> Count(CancellationToken cancellationToken = default);
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
}
