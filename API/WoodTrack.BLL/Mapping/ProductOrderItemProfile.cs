namespace WoodTrack.BLL.Mapping;

public class ProductOrderItemProfile : BaseProfile
{
    public ProductOrderItemProfile()
    {
        CreateMap<ProductOrderItem, ProductOrderItemModel>();
        CreateMap<ProductOrderItemUpsertModel, ProductOrderItem>();
    }
}
