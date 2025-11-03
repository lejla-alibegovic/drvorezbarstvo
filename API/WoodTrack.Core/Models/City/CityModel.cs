namespace WoodTrack.Core.Models;

public class CityModel : BaseModel
{
    public required string Name { get; set; }
    public required string Abrv { get; set; }
    public CountryModel Country { get; set; } = default!;
    public int CountryId { get; set; }
    public bool IsActive { get; set; }
}
