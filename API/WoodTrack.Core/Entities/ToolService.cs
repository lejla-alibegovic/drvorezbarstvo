namespace WoodTrack.Core;

public class ToolService : BaseEntity
{
    public decimal NewDimension { get; set; }
    public DateTime DeadlineFinishedAt { get; set; }
    public string Description { get; set; } = default!;
    public int ToolId { get; set; }
    public Tool Tool { get; set; } = default!;
    public int UserId { get; set; }
    public User User { get; set; } = default!;
}
