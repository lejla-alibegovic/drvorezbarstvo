namespace WoodTrack.Core.Models;

public class ReportUpsertModel : BaseUpsertModel
{
    public int? PublisherId { get; set; }
    public ReportType Type { get; set; }
    public string Data { get; set; } = default!;
}
