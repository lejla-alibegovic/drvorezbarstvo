namespace WoodTrack.Core.Models;

public class UserRoleUpsertModel : BaseUpsertModel
{
    public int UserId { get; set; }
    public int RoleId { get; set; }
}
