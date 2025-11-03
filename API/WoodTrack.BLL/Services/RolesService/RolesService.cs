namespace WoodTrack.BLL;

public class RolesService : BaseService<Role, int, RoleModel, RoleUpsertModel, BaseSearchObject>, IRolesService
{
    public RolesService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {

    }
}
