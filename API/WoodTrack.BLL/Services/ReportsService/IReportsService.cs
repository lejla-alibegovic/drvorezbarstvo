namespace WoodTrack.BLL;

public interface IReportsService
{
    Task<byte[]> GenerateClientsReport(UsersSearchObject searchObject);
    Task<byte[]> GenerateOrdersReport(ProductOrderSearchObject searchObject);
    Task<byte[]> GenerateToolsReport(ToolSearchObject searchObject);
}
