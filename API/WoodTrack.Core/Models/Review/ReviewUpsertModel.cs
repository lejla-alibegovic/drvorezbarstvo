namespace WoodTrack.Core.Models;

public class ReviewUpsertModel : BaseUpsertModel
{
    public int ClientId { get; set; }
    public int? ProductId { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
}
