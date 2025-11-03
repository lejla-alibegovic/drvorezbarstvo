using Microsoft.AspNetCore.Http;

namespace WoodTrack.Core.Models;

public class UserUpsertModel : BaseUpsertModel
{
    public string FirstName { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public string UserName { get; set; } = default!;
    public string Email { get; set; } = default!;
    public string? OldPassword { get; set; } = default!;
    public string? NewPassword { get; set; } = default!;
    public string PhoneNumber { get; set; } = default!;
    public DateTime? BirthDate { get; set; }
    public Gender? Gender { get; set; }
    public string? ProfilePhoto { get; set; }
    public string? ProfilePhotoThumbnail { get; set; }
    public string Address { get; set; } = default!;
    public string? Description { get; set; }
    public string? LicenseNumber { get; set; }
    public int? YearsOfExperience { get; set; }
    public string? WorkingHours { get; set; }
    public string? Position { get; set; }
    public int? CountryId { get; set; }
    public bool IsClient { get; set; }
    public bool IsEmployee { get; set; }
    public IFormFile? ProfilePhotoFile { get; set; } = default!;
}
