namespace WoodTrack.BLL.Mapping;

public class UserRoleProfile : BaseProfile
{
    public UserRoleProfile()
    {
        CreateMap<UserRole, UserRoleModel>();
        CreateMap<UserRoleUpsertModel, UserRole>();
        CreateMap<User, UserLoginDataModel>();
        CreateMap<UserLoginDataModel, LoginInformationModel>()
            .ForPath(x => x.UserId, opt => opt.MapFrom(x => x.Id))
            .ForMember(x => x.UserName, opt => opt.MapFrom(x => !string.IsNullOrWhiteSpace(x.UserName) ? x.UserName : x.Email));
    }
}
