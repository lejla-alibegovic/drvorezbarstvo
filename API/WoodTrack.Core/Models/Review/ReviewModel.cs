namespace WoodTrack.Core.Models;

public class ReviewModel : BaseModel
{
    public int ClientId { get; set; }
    public UserModel Client { get; set; } = default!;
    public int? ProductId { get; set; }
    public ProductModel? Product { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
}
