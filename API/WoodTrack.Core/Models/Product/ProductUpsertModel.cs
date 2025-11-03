using Microsoft.AspNetCore.Http;

namespace WoodTrack.Core.Models;

public class ProductUpsertModel : BaseUpsertModel
{
    public required string Name { get; set; }
    public string Description { get; set; } = default!;
    public decimal Price { get; set; }
    public int Stock { get; set; }
    public string? ImageUrl { get; set; } = "";
    public bool IsEnable { get; set; } = true;
    public string? Manufacturer { get; set; }
    public string? Barcode { get; set; }
    public int ProductCategoryId { get; set; }
    public IFormFile? ImageFile { get; set; } = default!;
    public decimal Length { get; set; }
    public decimal Width { get; set; }
    public decimal Height { get; set; }
    public ICollection<ReviewUpsertModel> Reviews { get; set; } = [];
}
