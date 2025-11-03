namespace WoodTrack.Core.Models.ToolOrder;

public class ToolOrderModel : BaseModel
{
    public int ToolId { get; set; }
    public ToolModel Tool { get; set; } = default!;
    public int Quantity { get; set; }
    public int UserId { get; set; }
    public UserModel User { get; set; } = default!;
    public DateTime DeliveryDate { get; set; }
}
