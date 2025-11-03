namespace WoodTrack.Common;

public class OrderReportModel
{
    public string? TransactionId { get; set; }
    public string? FullName { get; set; }
    public string? Address { get; set; }
    public string? PhoneNumber { get; set; }
    public string? PaymentMethod { get; set; }
    public string? DeliveryMethod { get; set; }
    public string? Note { get; set; }
    public decimal TotalAmount { get; set; }
    public string Status { get; set; } = default!;
    public DateTime? Date { get; set; }
}
