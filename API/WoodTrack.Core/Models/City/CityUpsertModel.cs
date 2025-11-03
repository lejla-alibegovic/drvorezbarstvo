namespace WoodTrack.Core.Models;

public class CityUpsertModel : BaseUpsertModel
{
    public required string Name { get; set; }
    public required string Abrv { get; set; }
    public int CountryId { get; set; }
    public bool IsActive { get; set; }
}
