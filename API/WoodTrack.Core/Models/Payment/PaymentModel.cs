namespace WoodTrack.Core.Models
{
    public class PaymentModel : BaseModel
    {
        public bool IsPaid { get; set; }
        public DateTime DateFrom { get; set; }
        public DateTime DateTo { get; set; }
        public int CustomerId { get; set; }
        public UserModel Customer { get; set; } = default!;
        public int OrderId { get; set; }
        public ProductOrderModel Order { get; set; } = default!;
        public decimal Price { get; set; }
        public decimal? Discount { get; set; }
        public string? Note { get; set; }
        public PaymentType Type { get; set; }
        public PaymentStatus Status { get; set; }
        public string TransactionId { get; set; } = default!;
    }
}
