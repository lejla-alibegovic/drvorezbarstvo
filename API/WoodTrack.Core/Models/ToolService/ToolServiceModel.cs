namespace WoodTrack.Core.Models;

public class ToolServiceModel : BaseModel
{
    public decimal NewDimension { get; set; }
    public DateTime DeadlineFinishedAt { get; set; }
    public string Description { get; set; } = default!;
    public int ToolId { get; set; }
    public ToolModel Tool { get; set; } = default!;
    public int? UserId { get; set; }
    public UserModel User { get; set; } = default!;
}
