namespace WoodTrack.Core.SearchObjects
{
    public class OrderSearchObject : BaseSearchObject
    {
        public OrderStatus? Status { get; set; }
        public int? UserId { get; set; }
    }
}
