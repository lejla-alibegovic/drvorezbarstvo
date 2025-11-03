namespace WoodTrack.BLL;

public class ReviewsService : BaseService<Review, int, ReviewModel, ReviewUpsertModel, ReviewsSearchObject>, IReviewsService
{
    public ReviewsService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {

    }


    public override async Task<PagedList<ReviewModel>> GetPagedAsync(ReviewsSearchObject searchObject, CancellationToken cancellationToken = default)
    {
        var pagedList = await DbSet
            .Include(p => p.Product)
            .Include(p => p.Client)
            .Where(o =>
                (
                    string.IsNullOrEmpty(searchObject.SearchFilter) || o.Product.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())
                )
                && (searchObject.Rating == null || searchObject.Rating == o.Rating)
                && !o.IsDeleted
            )
            .ToPagedListAsync(searchObject, cancellationToken);
        pagedList.Items = pagedList.Items.Select(x =>
        {
            x.Product.Reviews = null;
            return x;
        }).ToList();
        return Mapper.Map<PagedList<ReviewModel>>(pagedList);
    }
}
