namespace WoodTrack.BLL;

public class ProductsService : BaseService<Product, int, ProductModel, ProductUpsertModel, ProductSearchObject>, IProductsService
{
    public ProductsService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public override async Task<ProductModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
    {
        var entity = await DbSet
            .Include(x => x.ProductCategory)
            .Include(x => x.Reviews)
                .ThenInclude(r => r.Client)
            .Where(x => x.Id == id)
            .FirstOrDefaultAsync(cancellationToken);

        if (entity != null)
        {
            entity.Reviews = entity.Reviews.Select(r =>
            {
                r.Product = null;
                return r;
            }).ToList();
        }
        return Mapper.Map<ProductModel>(entity);
    }

    public override async Task<PagedList<ProductModel>> GetPagedAsync(ProductSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(p => p.ProductCategory)
            .Where(c =>
                (
                    string.IsNullOrEmpty(searchObject.SearchFilter)
                    || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (!string.IsNullOrEmpty(c.Description) && c.Description.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                )
                && (searchObject.CategoryId == 0 || searchObject.CategoryId == c.ProductCategoryId)
                && !c.IsDeleted
            )
            .ToPagedListAsync(searchObject);
        return Mapper.Map<PagedList<ProductModel>>(pagedList);
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted && x.IsEnable).CountAsync(cancellationToken);
    }
}
