namespace WoodTrack.BLL;

public class NotificationsService : BaseService<Notification, int, NotificationModel, NotificationUpsertModel, NotificationsSearchObject>, INotificationsService
{
    private readonly IHubContext<NotificationHub> _hubContext;
    private readonly IEmail _email;

    public NotificationsService(
        IMapper mapper,
        DatabaseContext databaseContext,
        IHubContext<NotificationHub> hubContext,
        IEmail email
        ) : base(mapper, databaseContext)
    {
        _hubContext = hubContext;
        _email = email;
    }

    public override async Task<PagedList<NotificationModel>> GetPagedAsync(NotificationsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var query = DbSet
            .OrderBy(x => x.Read)
            .OrderByDescending(x => x.DateCreated)
            .AsQueryable();

        if (searchObject.UserId.HasValue && searchObject.UserId > 0)
        {
            query = query.Where(c => c.UserId == searchObject.UserId);
        }

        var pagedList = await query.ToPagedListAsync(searchObject, cancellationToken);

        return Mapper.Map<PagedList<NotificationModel>>(pagedList);
    }
}
