namespace WoodTrack.Core.SearchObjects;

public class BaseSearchObject
{
    public string? SearchFilter { get; set; } = string.Empty;
    public int PageNumber { get; set; } = 1;
    public int PageSize { get; set; } = 10;
}
