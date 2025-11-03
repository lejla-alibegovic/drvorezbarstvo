namespace WoodTrack.Core;

public class Product : BaseEntity
{
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Price { get; set; }
    public string ImageUrl { get; set; } = default!;
    public bool IsEnable { get; set; } = true;
    public string? Manufacturer { get; set; }
    public string? Barcode { get; set; }
    public int ProductCategoryId { get; set; }
    public ProductCategory ProductCategory { get; set; } = default!;
    public decimal Length { get; set; }
    public decimal Width { get; set; }
    public decimal Height { get; set; }
    public ICollection<Review> Reviews { get; set; } = [];
}