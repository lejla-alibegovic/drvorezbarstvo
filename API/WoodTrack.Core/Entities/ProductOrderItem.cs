namespace WoodTrack.Core;

public class ProductOrderItem : BaseEntity
{
    public int OrderId { get; set; }
    public ProductOrder Order { get; set; } = default!;
    public int ProductId { get; set; }
    public Product Product { get; set; } = default!;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
    public string? Notes { get; set; }
}
