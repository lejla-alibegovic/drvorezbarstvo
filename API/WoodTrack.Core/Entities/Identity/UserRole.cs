namespace WoodTrack.Core;

public class UserRole : IdentityUserRole<int>, IBaseEntity
{
    public int Id { get; set; }
    public User User { get; set; } = default!;
    public Role Role { get; set; } = default!;
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
}
