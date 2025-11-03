namespace WoodTrack.BLL;

public class ProductCategoriesService : BaseService<ProductCategory, int, ProductCategoryModel, ProductCategoryUpsertModel, BaseSearchObject>, IProductCategoriesService
{
    public ProductCategoriesService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public override async Task<PagedList<ProductCategoryModel>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Where(o =>
                (
                    string.IsNullOrEmpty(searchObject.SearchFilter) || o.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())
                )
                && !o.IsDeleted
            )
            .ToPagedListAsync(searchObject, cancellationToken);
        return Mapper.Map<PagedList<ProductCategoryModel>>(pagedList);
    }

    public async Task<IEnumerable<KeyValuePair<int, string>>> GetDropdownItems()
    {
        return await DbSet
            .Where(x => !x.IsDeleted)
            .Select(c => new KeyValuePair<int, string>(c.Id, c.Name)).ToListAsync();
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted).CountAsync(cancellationToken);
    }
}
