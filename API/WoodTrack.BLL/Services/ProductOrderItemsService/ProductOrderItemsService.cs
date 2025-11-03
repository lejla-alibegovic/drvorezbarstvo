namespace WoodTrack.BLL;

public class ProductOrderItemsService : BaseService<ProductOrderItem, int, ProductOrderItemModel, ProductOrderItemUpsertModel, BaseSearchObject>, IProductOrderItemsService
{
    public ProductOrderItemsService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {

    }
}
