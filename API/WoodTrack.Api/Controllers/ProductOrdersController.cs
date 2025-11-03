namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ProductOrdersController : BaseCrudController<ProductOrderModel, ProductOrderUpsertModel, ProductOrderSearchObject, IProductOrdersService>
{
    private readonly IProductOrdersService _service;

    public ProductOrdersController(
        IProductOrdersService service,
        ILogger<ProductOrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        _service = service;
    }

    [HttpGet]
    [Route("cancel-order/{orderId}")]
    public async Task<bool> CancelOrder(int orderId)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(orderId, userId, OrderStatus.Cancelled, false);
    }

    [HttpGet]
    [Route("change-status/{orderId}/{status}")]
    public async Task<bool> ChangeStatus(int orderId, OrderStatus status)
    {
        var userId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");

        if (userId == 0)
        {
            throw new Exception("UserIsNotAuthenticated");
        }

        return await _service.ChangeStatusAsync(orderId, userId, status, true);
    }
}
