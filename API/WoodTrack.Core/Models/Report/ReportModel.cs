namespace WoodTrack.Core.Models;

public class ReportModel : BaseModel
{
    public int? PublisherId { get; set; }
    public UserModel? Publisher { get; set; }
    public ReportType Type { get; set; }
    public DateTime GeneratedAt { get; set; }
    public string Data { get; set; } = default!;
}
