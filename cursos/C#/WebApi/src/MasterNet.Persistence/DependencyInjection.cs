using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

namespace MasterNet.Persistence;

public static class DependencyInjection
{

    public static IServiceCollection AddPersistence(
        this IServiceCollection services,
        IConfiguration configuration
    )
    {
        services.AddDbContext<MasterNetDbContext>(opt => {
            opt.LogTo(Console.WriteLine, new [] {
                DbLoggerCategory.Database.Command.Name
            }, LogLevel.Information).EnableSensitiveDataLogging();

            opt.UseSqlite(configuration.GetConnectionString("SqliteDatabase"));
        });


        return services;
    }


}