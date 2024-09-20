using Bogus;
using MasterNet.Domain;
using MasterNet.Persistence;
using MasterNet.Persistence.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace MasterNet.WebApi.Extensions;

public static class DataSeed
{

    public static async Task SeedDataAuthentication(
        this IApplicationBuilder app
    )
    {
        using var scope = app.ApplicationServices.CreateScope();
        var service = scope.ServiceProvider;
        var loggerFactory = service.GetRequiredService<ILoggerFactory>();

        try{
            var context = service.GetRequiredService<MasterNetDbContext>();
            await context.Database.MigrateAsync();
            var userManager = service.GetRequiredService<UserManager<AppUser>>();

            if(!userManager.Users.Any())
            {
                var userAdmin = new AppUser {
                    NombreCompleto = "Vaxi Drez",
                    UserName = "vaxidrez",
                    Email = "vaxi.drez@gmail.com"
                };

                await userManager.CreateAsync(userAdmin, "Password123$");
                await userManager.AddToRoleAsync(userAdmin, CustomRoles.ADMIN);

                 var userClient = new AppUser {
                    NombreCompleto = "Juan Perez",
                    UserName = "juanperez",
                    Email = "juan.perez@gmail.com"
                };

                await userManager.CreateAsync(userClient, "Password123$");
                await userManager.AddToRoleAsync(userClient, CustomRoles.CLIENT);
            }

            
            var cursos = await context.Cursos!.Take(10).Skip(0).ToListAsync();

            if(!context.Set<CursoInstructor>().Any())
            {
                var instructores = 
                await context.Instructores!.Take(10).Skip(0).ToListAsync();

                foreach(var curso in cursos)
                {
                    curso.Instructores = instructores;
                }
            }

            if(!context.Set<CursoPrecio>().Any())
            {
                var precios = await context.Precios!.ToListAsync();
                foreach(var curso in cursos)
                {
                    curso.Precios = precios;
                }
            }
           
            if(!context.Set<Calificacion>().Any())
            {
                foreach(var curso in cursos)
                {
                    var fakerCalificacion = new Faker<Calificacion>()
                        .RuleFor(c => c.Id, _ => Guid.NewGuid())
                        .RuleFor(c => c.Alumno, f=>f.Name.FullName())
                        .RuleFor(c => c.Comentario, f=>f.Commerce.ProductDescription())
                        .RuleFor(c => c.Puntaje, 5)
                        .RuleFor(c => c.CursoId, curso.Id);
                    
                    var calificaciones = fakerCalificacion.Generate(10);
                    context.AddRange(calificaciones);
                }
            }
   

            await context.SaveChangesAsync();
            
        }catch(Exception e)
        {
          var logger = loggerFactory.CreateLogger<MasterNetDbContext>();
          logger.LogError(e.Message);
        }


    }




}