namespace WoodTrack.BLL.Mapping;

public class ProductOrderProfile : BaseProfile
{
    public ProductOrderProfile()
    {
        CreateMap<ProductOrder, ProductOrderModel>();
        CreateMap<ProductOrderUpsertModel, ProductOrder>();
    }
}
