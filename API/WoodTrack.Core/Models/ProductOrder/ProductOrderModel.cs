namespace WoodTrack.Core.Models;

public class ProductOrderModel : BaseModel
{
    public int CustomerId { get; set; }
    public UserModel Customer { get; set; } = default!;
    public string? TransactionId { get; set; }
    public string? FullName { get; set; }
    public string? Address { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Note { get; set; }
    public decimal TotalAmount { get; set; }
    public OrderStatus Status { get; set; }
    public DateTime? Date { get; set; }
    public ICollection<ProductOrderItemModel> Items { get; set; } = [];
}
