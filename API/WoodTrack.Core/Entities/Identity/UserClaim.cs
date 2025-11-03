namespace WoodTrack.Core;

public class UserClaim : IdentityUserClaim<int>, IBaseEntity
{
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
}
