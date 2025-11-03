namespace WoodTrack.BLL;

public interface IDropdownService
{
    Task<IEnumerable<KeyValuePair<int, string>>> GetGendersAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetOrderStatusesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetReportTypesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetCitiesAsync(int? countryId);
    Task<IEnumerable<KeyValuePair<int, string>>> GetCountriesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetEmployeesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetClientsAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetProductCategoriesAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetToolsAsync();
    Task<IEnumerable<KeyValuePair<int, string>>> GetToolCategoriesAsync();
}