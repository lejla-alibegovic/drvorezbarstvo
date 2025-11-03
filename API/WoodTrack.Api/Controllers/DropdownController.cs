namespace WoodTrack.Api.Controllers;

public class DropdownController : BaseController
{
    private readonly IDropdownService _dropdownService;
    public DropdownController(IDropdownService service, ILogger<DropdownController> logger, IActivityLogsService activityLogs) : base(logger, activityLogs)
    {
        _dropdownService = service;
    }

    [HttpGet]
    [Route("genders")]
    public async Task<IActionResult> Genders()
    {
        var list = await _dropdownService.GetGendersAsync();
        return Ok(list);
    }


    [HttpGet]
    [Route("orderStatuses")]
    public async Task<IActionResult> OrderStatuses()
    {
        var list = await _dropdownService.GetOrderStatusesAsync();
        return Ok(list);
    }


    [HttpGet]
    [Route("reportTypes")]
    public async Task<IActionResult> ReportTypes()
    {
        var list = await _dropdownService.GetReportTypesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("cities")]
    public async Task<IActionResult> Cities([FromQuery] int? countryId)
    {
        var list = await _dropdownService.GetCitiesAsync(countryId);
        return Ok(list);
    }

    [HttpGet]
    [Route("countries")]
    public async Task<IActionResult> Countries()
    {
        var list = await _dropdownService.GetCountriesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("employees")]
    public async Task<IActionResult> Employees()
    {
        var list = await _dropdownService.GetEmployeesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("clients")]
    public async Task<IActionResult> Clients()
    {
        var list = await _dropdownService.GetClientsAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("product-categories")]
    public async Task<IActionResult> ProductCategories()
    {
        var list = await _dropdownService.GetProductCategoriesAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("tools")]
    public async Task<IActionResult> Tools()
    {
        var list = await _dropdownService.GetToolsAsync();
        return Ok(list);
    }

    [HttpGet]
    [Route("tool-categories")]
    public async Task<IActionResult> ToolCategories()
    {
        var list = await _dropdownService.GetToolCategoriesAsync();
        return Ok(list);
    }
}
