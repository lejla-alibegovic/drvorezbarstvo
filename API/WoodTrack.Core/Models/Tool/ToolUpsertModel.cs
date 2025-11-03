namespace WoodTrack.Core.Models;

public class ToolUpsertModel : BaseUpsertModel
{
    public string Code { get; set; } = default!;
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Dimension { get; set; }
    public DateTime? ChargedDate { get; set; }
    public DateTime? LastServiceDate { get; set; }
    public bool IsNeedNewService { get; set; }
    public int ToolCategoryId { get; set; }
    public int? ChargedByUserId { get; set; }
    public IEnumerable<ToolServiceUpsertModel> Services { get; set; } = [];
}
