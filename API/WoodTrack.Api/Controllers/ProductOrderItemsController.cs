namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ProductOrderItemsController : BaseCrudController<ProductOrderItemModel, ProductOrderItemUpsertModel, BaseSearchObject, IProductOrderItemsService>
{
    public ProductOrderItemsController(
        IProductOrderItemsService service,
        ILogger<ProductOrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
