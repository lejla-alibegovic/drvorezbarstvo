namespace WoodTrack.BLL;

public interface IProductCategoriesService : IBaseService<int, ProductCategoryModel, ProductCategoryUpsertModel, BaseSearchObject>
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems();
    Task<int> Count(CancellationToken cancellationToken = default);
}
