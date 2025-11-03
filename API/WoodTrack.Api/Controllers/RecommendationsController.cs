namespace WoodTrack.Api.Controllers;

[ApiController]
[Route("/[controller]")]
public class RecommendationsController : ControllerBase
{
    private readonly IRecommenderSystemService _recommenderSystemService;

    public RecommendationsController(IRecommenderSystemService recommenderSystemService)
    {
        _recommenderSystemService = recommenderSystemService;
    }

    [HttpGet("{userId}/{topN}")]
    public ActionResult<List<ProductModel>> Get(int userId, int topN = 5)
    {
        var recommendedProducts = _recommenderSystemService.RecommendProductsForClient(userId, topN);
        return Ok(recommendedProducts);
    }
}
