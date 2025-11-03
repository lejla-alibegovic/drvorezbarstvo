using WoodTrack.Core.Models.ToolOrder;

namespace WoodTrack.BLL;

public class ToolOrdersService : BaseService<ToolOrder, int, ToolOrderModel, ToolOrderUpsertModel, BaseSearchObject>, IToolOrdersService
{
    public ToolOrdersService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {
    }

    public override async Task<PagedList<ToolOrderModel>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(x => x.Tool)
            .Include(x => x.User)
            .Where(o =>
                (
                    string.IsNullOrEmpty(searchObject.SearchFilter) || o.Id.ToString().Contains(searchObject.SearchFilter.ToLower())
                    || (o.User.FirstName + " " + o.User.LastName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (o.User.LastName + " " + o.User.FirstName).ToLower().Contains(searchObject.SearchFilter.ToLower())
                    || (o.Tool.Name).ToLower().Contains(searchObject.SearchFilter.ToLower())
                )
                && !o.IsDeleted
            )
            .OrderByDescending(o => o.DateCreated)
            .ToPagedListAsync(searchObject, cancellationToken);
        return Mapper.Map<PagedList<ToolOrderModel>>(pagedList);
    }

    public Task<int> Count(CancellationToken cancellationToken = default)
    {
        return DbSet.Where(x => !x.IsDeleted).CountAsync(cancellationToken);
    }
}
