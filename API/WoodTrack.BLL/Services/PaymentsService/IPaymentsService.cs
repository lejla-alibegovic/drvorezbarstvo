namespace WoodTrack.BLL;

public interface IPaymentsService : IBaseService<int, PaymentModel, PaymentUpsertModel, BaseSearchObject>
{
    public Task<decimal> TotalPayments(DateTime date, CancellationToken cancellationToken = default);
}
