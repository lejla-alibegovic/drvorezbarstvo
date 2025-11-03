namespace WoodTrack.Core;

public class Notification : BaseEntity
{
    public int UserId { get; set; }
    public User User { get; set; } = default!;
    public string Message { get; set; } = default!;
    public bool Read { get; set; }
}
