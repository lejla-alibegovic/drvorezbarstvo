namespace WoodTrack.Core;

public class User : IdentityUser<int>, IBaseEntity
{
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
    public bool IsActive { get; set; }
    public bool IsFirstLogin { get; set; }
    public bool VerificationSent { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
    public DateTime? BirthDate { get; set; }
    public Gender? Gender { get; set; }
    public string Address { get; set; } = default!;
    public string? ProfilePhoto { get; set; }
    public string? ProfilePhotoThumbnail { get; set; }
    public string? Description { get; set; }
    public string? LicenseNumber { get; set; }
    public int? YearsOfExperience { get; set; }
    public string? WorkingHours { get; set; }
    public string? Position { get; set; }
    public int? CountryId { get; set; }
    public Country? Country { get; set; }
    public ICollection<UserRole> UserRoles { get; set; } = default!;
}
