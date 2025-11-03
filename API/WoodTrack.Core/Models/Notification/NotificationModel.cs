namespace WoodTrack.Core.Models;

public class NotificationModel : BaseModel
{
    public int UserId { get; set; }
    public required UserModel User { get; set; }
    public required string Message { get; set; }
    public bool Read { get; set; }
}
