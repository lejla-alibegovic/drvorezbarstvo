namespace WoodTrack.BLL.Services.RecommenderSystemService;

public class RecommenderSystemService : IRecommenderSystemService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly MLContext _mlContext;
    private ITransformer? _model;
    private List<ReviewData> _data;

    public RecommenderSystemService(IServiceScopeFactory scopeFactory)
    {
        _scopeFactory = scopeFactory;
        _mlContext = new MLContext();
    }

    public void LoadReviews()
    {
        using var scope = _scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
        _data = db.Reviews
            .Where(r => r.ProductId.HasValue)
            .Select(r => new ReviewData
            {
                ClientId = r.ClientId,
                ProductId = r.ProductId.Value,
                Label = r.Rating
            }).ToList();
    }

    public void Train()
    {
        LoadReviews();

        if (_data == null || _data.Count < 10)
            throw new InvalidOperationException("Nedovoljno podataka za treniranje modela.");

        var trainingData = _mlContext.Data.LoadFromEnumerable(_data);

        var options = new MatrixFactorizationTrainer.Options
        {
            MatrixColumnIndexColumnName = nameof(ReviewData.ClientId),
            MatrixRowIndexColumnName = nameof(ReviewData.ProductId),
            LabelColumnName = nameof(ReviewData.Label),
            NumberOfIterations = 20,
            ApproximationRank = 100,
        };

        var pipeline = _mlContext.Transforms.Conversion.MapValueToKey(nameof(ReviewData.ClientId))
            .Append(_mlContext.Transforms.Conversion.MapValueToKey(nameof(ReviewData.ProductId)))
            .Append(_mlContext.Recommendation().Trainers.MatrixFactorization(options));
        _model = pipeline.Fit(trainingData);
    }

    public List<ProductModel> RecommendProductsForClient(int clientId, int topN = 5)
    {
        if (_model == null)
            throw new InvalidOperationException("Model nije treniran.");

        var allProductIds = _data.Select(r => (int)r.ProductId).Distinct().ToList();
        var ratedProductIds = _data.Where(r => r.ClientId == clientId)
                                   .Select(r => (int)r.ProductId)
                                   .ToHashSet();

        var productsToRecommend = allProductIds.Except(ratedProductIds);

        var predictionEngine = _mlContext.Model.CreatePredictionEngine<ReviewData, ProductPrediction>(_model);

        var predictions = new List<(int productId, float score)>();
        foreach (var productId in productsToRecommend)
        {
            var prediction = predictionEngine.Predict(new ReviewData
            {
                ClientId = clientId,
                ProductId = productId
            });
            predictions.Add((productId, prediction.Score));
        }

        var recommendedProductIdsWithScore = predictions.OrderByDescending(x => x.score).Take(topN).ToList();

        using var scope = _scopeFactory.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
        var mapper = scope.ServiceProvider.GetRequiredService<IMapper>();
        var recommendedProducts = db.Products
            .Where(p => recommendedProductIdsWithScore.Select(x => x.productId).Contains(p.Id))
            .ToList();

        return mapper.Map<List<ProductModel>>(recommendedProducts);
    }
}
