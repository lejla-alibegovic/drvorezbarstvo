namespace WoodTrack.Core;

public class Tool : BaseEntity
{
    public string Code { get; set; } = default!;
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Dimension { get; set; }
    public DateTime? ChargedDate { get; set; }
    public DateTime? LastServiceDate { get; set; }
    public bool IsNeedNewService { get; set; }
    public int ToolCategoryId { get; set; }
    public ToolCategory ToolCategory { get; set; } = default!;
    public int? ChargedByUserId { get; set; }
    public User? ChargedByUser { get; set; } = default!;
    public ICollection<ToolService> Services { get; set; } = [];
}
