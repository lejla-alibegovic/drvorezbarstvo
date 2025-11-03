namespace WoodTrack.Common;

public class ToolReportModel
{
    public string Code { get; set; } = default!;
    public string Name { get; set; } = default!;
    public decimal Dimension { get; set; }
    public DateTime? ChargedDate { get; set; }
    public string CategoryName { get; set; } = default!;
}
