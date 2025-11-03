namespace WoodTrack.Core;

public class RoleClaim : IdentityRoleClaim<int>, IBaseEntity
{
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
}
