namespace WoodTrack.Core.SearchObjects
{
    public class ProductOrderSearchObject : BaseSearchObject
    {
        public OrderStatus? Status { get; set; }
        public int? UserId { get; set; }
    }
}
