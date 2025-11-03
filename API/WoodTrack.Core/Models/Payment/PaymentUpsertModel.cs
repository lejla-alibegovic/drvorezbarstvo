namespace WoodTrack.Core.Models;

public class PaymentUpsertModel : BaseUpsertModel
{
    public bool IsPaid { get; set; }
    public DateTime DateFrom { get; set; }
    public DateTime DateTo { get; set; }
    public int CustomerId { get; set; }
    public int OrderId { get; set; }
    public decimal Price { get; set; }
    public decimal? Discount { get; set; }
    public string? Note { get; set; }
    public PaymentType Type { get; set; }
    public PaymentStatus Status { get; set; }
    public string TransactionId { get; set; } = default!;
}
