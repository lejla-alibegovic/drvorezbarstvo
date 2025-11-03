namespace WoodTrack.Common;

public class LoginInformationModel
{
    public int Id { get; set; }
    public bool IsFirstLogin { get; set; }
    public int UserId { get; set; }
    public string UserName { get; set; } = default!;
    public string FirstName { get; set; } = default!;
    public string PhoneNumber { get; set; } = default!;
    public string Address { get; set; } = default!;
    public DateTime BirthDate { get; set; } = default!;
    public string LastName { get; set; } = default!;
    public string Email { get; set; } = default!;
    public string ProfilePhoto { get; set; } = default!;
    public string ProfilePhotoThumbnail { get; set; } = default!;
    public bool IsClient { get; set; }
    public string Token { get; set; } = default!;
}
