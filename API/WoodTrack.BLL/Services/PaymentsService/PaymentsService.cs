namespace WoodTrack.BLL;

public class PaymentsService : BaseService<Payment, int, PaymentModel, PaymentUpsertModel, BaseSearchObject>, IPaymentsService
{
    public PaymentsService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
        //
    }

    public async Task<decimal> TotalPayments(DateTime date, CancellationToken cancellationToken = default)
    {
        return await DbSet
            .Where(x => !x.IsDeleted && x.IsPaid)
            .SumAsync(x => x.Price - x.Price * x.Discount / 100, cancellationToken) ?? Decimal.Zero;
    }
}
