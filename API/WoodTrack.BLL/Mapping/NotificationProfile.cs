namespace WoodTrack.BLL.Mapping;

public class NotificationProfile : BaseProfile
{
    public NotificationProfile()
    {
        CreateMap<Notification, NotificationModel>();
        CreateMap<NotificationUpsertModel, Notification>();
    }
}
