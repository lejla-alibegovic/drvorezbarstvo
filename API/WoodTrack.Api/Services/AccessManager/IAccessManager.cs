namespace WoodTrack.Api;

public interface IAccessManager
{
    Task<LoginInformationModel> SignInAsync(string email, string password, bool rememberMe = false);
    Task<bool> ChangePassword(int userId, string currentPassword, string newPassword);
}
