namespace WoodTrack.Core.Models;

public class ProductOrderItemUpsertModel : BaseUpsertModel
{
    public int OrderId { get; set; }
    public int ProductId { get; set; }
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal TotalPrice => Quantity * UnitPrice;
    public string? Notes { get; set; }
}
