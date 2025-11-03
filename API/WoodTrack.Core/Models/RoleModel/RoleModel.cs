namespace WoodTrack.Core.Models;

public class RoleModel : BaseModel
{
    public required string Name { get; set; }
    public required string NormalizedName { get; set; }
    public RoleLevel RoleLevel { get; set; }
    public ICollection<UserRoleModel> UserRoles { get; set; } = default!;
}
