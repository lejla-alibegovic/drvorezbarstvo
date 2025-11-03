namespace WoodTrack.Core;

public class Report : BaseEntity
{
    public int? PublisherId { get; set; }
    public User? Publisher { get; set; }
    public ReportType Type { get; set; }
    public string Data { get; set; } = default!;
}
