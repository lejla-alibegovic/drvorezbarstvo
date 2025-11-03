namespace WoodTrack.Core;

public class UserToken : IdentityUserToken<int>, IBaseEntity
{
    public int Id { get; set; }
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
}
