namespace WoodTrack.Core;

public class ToolOrder : BaseEntity
{
    public int ToolId { get; set; }
    public Tool Tool { get; set; } = default!;
    public int Quantity { get; set; }
    public int UserId { get; set; }
    public User User { get; set; } = default!;
    public DateTime DeliveryDate { get; set; }
}
