namespace WoodTrack.BLL.Services.RecommenderSystemService;

public interface IRecommenderSystemService
{
    void Train();
    List<ProductModel> RecommendProductsForClient(int clientId, int topN = 5);
}
