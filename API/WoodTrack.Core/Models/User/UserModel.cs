namespace WoodTrack.Core.Models;

public class UserModel : BaseModel
{
    public bool IsActive { get; set; }
    public bool IsFirstLogin { get; set; }
    public bool VerificationSent { get; set; }
    public string? FirstName { get; set; } = default!;
    public string? LastName { get; set; } = default!;
    public string UserName { get; set; } = default!;
    public string NormalizedUserName { get; set; } = default!;
    public string Email { get; set; } = default!;
    public string NormalizedEmail { get; set; } = default!;
    public bool EmailConfirmed { get; set; }
    public string PhoneNumber { get; set; } = default!;
    public bool PhoneNumberConfirmed { get; set; }
    public int AccessFailedCount { get; set; }
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
    public CountryModel? Country { get; set; }
}
