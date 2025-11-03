namespace WoodTrack.Core.Models;

public class ToolModel : BaseModel
{
    public string Code { get; set; } = default!;
    public string Name { get; set; } = default!;
    public string Description { get; set; } = default!;
    public decimal Dimension { get; set; }
    public DateTime? ChargedDate { get; set; }
    public DateTime? LastServiceDate { get; set; }
    public bool IsNeedNewService { get; set; }
    public int ToolCategoryId { get; set; }
    public ToolCategoryModel ToolCategory { get; set; } = default!;
    public int? ChargedByUserId { get; set; }
    public UserModel? ChargedByUser { get; set; } = default!;
    public ICollection<ToolServiceModel> Services { get; set; } = [];
}
