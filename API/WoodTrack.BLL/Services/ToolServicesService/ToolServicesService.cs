namespace WoodTrack.BLL.Services.ServicesService;

public class ToolServicesService : BaseService<ToolService, int, ToolServiceModel, ToolServiceUpsertModel, BaseSearchObject>, IToolServicesService
{
    public ToolServicesService(IMapper mapper, DatabaseContext databaseContext) : base(mapper, databaseContext)
    {

    }
}
