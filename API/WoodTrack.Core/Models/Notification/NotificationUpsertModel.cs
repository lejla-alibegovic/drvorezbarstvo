namespace WoodTrack.Core.Models;

public class NotificationUpsertModel : BaseUpsertModel
{
    public int UserId { get; set; }
    public required string Message { get; set; }
    public bool Read { get; set; }
}
