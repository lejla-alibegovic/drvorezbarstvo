namespace WoodTrack.Core.Models;

public class CountryModel : BaseModel
{
    public required string Name { get; set; }
    public required string Abrv { get; set; }
    public bool IsActive { get; set; }
}
