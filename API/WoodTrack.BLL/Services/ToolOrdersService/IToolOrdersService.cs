namespace WoodTrack.BLL;

public interface IToolOrdersService : IBaseService<int, ToolOrderModel, ToolOrderUpsertModel, BaseSearchObject>
{
    Task<int> Count(CancellationToken cancellationToken = default);
}
