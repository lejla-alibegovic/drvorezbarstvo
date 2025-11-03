namespace WoodTrack.Core;

public class UserLogin : IdentityUserLogin<int>, IBaseEntity
{
    public int Id { get; set; }
    public DateTime DateCreated { get; set; }
    public DateTime? DateUpdated { get; set; }
    public bool IsDeleted { get; set; }
}
