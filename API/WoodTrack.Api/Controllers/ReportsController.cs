namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
[Route("/[controller]")]
public class ReportsController : ControllerBase
{
    private readonly IReportsService _reportsService;
    public ReportsController(IReportsService reportsService)
    {
        _reportsService = reportsService;
    }

    [HttpGet("clients")]
    public async Task<IActionResult> GetClientsReport(UsersSearchObject searchObject)
    {
        var pdfBytes = await _reportsService.GenerateClientsReport(searchObject);
        return File(pdfBytes, "application/pdf", "izvjestaj_klijenata.pdf");
    }

    [HttpGet("orders")]
    public async Task<IActionResult> GetOrdersReport(ProductOrderSearchObject searchObject)
    {
        var pdfBytes = await _reportsService.GenerateOrdersReport(searchObject);
        return File(pdfBytes, "application/pdf", "izvjestaj_narudzbi.pdf");
    }

    [HttpGet("tools")]
    public async Task<IActionResult> GetToolsReport(ToolSearchObject searchObject)
    {
        var pdfBytes = await _reportsService.GenerateToolsReport(searchObject);
        return File(pdfBytes, "application/pdf", "izvjestaj_alata.pdf");
    }

}
