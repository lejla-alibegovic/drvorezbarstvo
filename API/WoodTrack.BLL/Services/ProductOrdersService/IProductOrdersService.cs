namespace WoodTrack.BLL;

public interface IProductOrdersService : IBaseService<int, ProductOrderModel, ProductOrderUpsertModel, ProductOrderSearchObject>
{
    Task<int> Count(CancellationToken cancellationToken = default);
    Task<bool> ChangeStatusAsync(int orderId, int requestByUserId, OrderStatus status, bool sendNotification,CancellationToken cancellationToken = default);
}
