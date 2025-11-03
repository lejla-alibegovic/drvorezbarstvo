namespace WoodTrack.Core;

public class Country:BaseEntity
{
    public string Name { get; set; } = default!;
    public string Abrv { get; set; } = default!;
    public bool IsActive { get; set; }
}
