namespace WoodTrack.Core.Models;

public class ProductOrderItemModel : BaseModel
{
    public int OrderId { get; set; }
    public int ProductId { get; set; }
    public required ProductModel Product { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
    public string? Notes { get; set; }
}
