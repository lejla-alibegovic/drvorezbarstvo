using WoodTrack.BLL.Services.RecommenderSystemService;

namespace WoodTrack.BLL;

public static class Registry
{
    public static void AddServices(this IServiceCollection services)
    {
        services.AddScoped<IActivityLogsService, ActivityLogsService>();
        services.AddScoped<ICitiesService, CitiesService>();
        services.AddScoped<ICountriesService, CountriesService>();
        services.AddScoped<IDropdownService, DropdownService>();
        services.AddScoped<IUsersService, UsersService>();
        services.AddScoped<IProductOrdersService, ProductOrdersService>();
        services.AddScoped<IToolOrdersService, ToolOrdersService>();
        services.AddScoped<IProductOrderItemsService, ProductOrderItemsService>();
        services.AddScoped<IPaymentsService, PaymentsService>();
        services.AddScoped<IProductsService, ProductsService>();
        services.AddScoped<IProductCategoriesService, ProductCategoriesService>();
        services.AddScoped<IToolsService, ToolsService>();
        services.AddScoped<IToolCategoriesService, ToolCategoriesService>();
        services.AddScoped<IToolServicesService, ToolServicesService>();
        services.AddScoped<IReportsService, ReportsService>();
        services.AddScoped<IReviewsService, ReviewsService>();
        services.AddScoped<IRolesService, RolesService>();
        services.AddScoped<IRabbitMQProducer, RabbitMQProducer>();
        services.AddScoped<IToolServicesService, ToolServicesService>();
        services.AddScoped<INotificationsService, NotificationsService>();
        services.AddSingleton<IRecommenderSystemService, RecommenderSystemService>();
    }
}
