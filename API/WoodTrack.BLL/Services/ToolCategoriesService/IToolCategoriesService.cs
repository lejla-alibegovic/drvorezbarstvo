namespace WoodTrack.BLL;

public interface IToolCategoriesService : IBaseService<int, ToolCategoryModel, ToolCategoryUpsertModel, BaseSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
    Task<int> Count(CancellationToken cancellationToken = default);
}
