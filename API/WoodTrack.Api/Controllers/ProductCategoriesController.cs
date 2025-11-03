namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ProductCategoriesController : BaseCrudController<ProductCategoryModel, ProductCategoryUpsertModel, BaseSearchObject, IProductCategoriesService>
{
    public ProductCategoriesController(
        IProductCategoriesService service,
        ILogger<ProductCategoriesController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    { }

}
