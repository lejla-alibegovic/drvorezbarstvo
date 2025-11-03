namespace WoodTrack.Core.Models.ToolOrder;

public class ToolOrderUpsertModel : BaseUpsertModel
{
    public int ToolId { get; set; }
    //public ToolUpsertModel Tool { get; set; }
    public int Quantity { get; set; }
    public int UserId { get; set; }
    //public UserUpsertModel User { get; set; }
    public DateTime DeliveryDate { get; set; }
}
