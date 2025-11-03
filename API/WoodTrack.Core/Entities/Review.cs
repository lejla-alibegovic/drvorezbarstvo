namespace WoodTrack.Core;

public class Review : BaseEntity
{
    public int ClientId { get; set; }
    public User Client { get; set; } = default!;
    public int? ProductId { get; set; }
    public Product? Product { get; set; }
    public int Rating { get; set; }
    public string? Comment { get; set; }
}
