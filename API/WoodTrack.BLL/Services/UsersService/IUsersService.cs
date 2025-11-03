namespace WoodTrack.BLL;

public interface IUsersService : IBaseService<int, UserModel, UserUpsertModel, UsersSearchObject>
{
    Task<UserLoginDataModel?> FindByUserNameOrEmailAsync(string userName, CancellationToken cancellationToken = default);
    Task<int> ClientCount(CancellationToken cancellationToken = default);
    Task<int> EmployeeCount(CancellationToken cancellationToken = default);
    Task<Dictionary<DateTime, int>> GetDailyClientRegistrationsAsync(CancellationToken cancellationToken = default);
    Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesDropdownItems();
    Task<IEnumerable<KeyValuePair<int, string>>> GetClientsDropdownItems();
}
