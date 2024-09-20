// using MasterNet.Domain;
// using MasterNet.Persistence;
// using Microsoft.EntityFrameworkCore;

// using var context = new MasterNetDbContext();
// var cursoNuevo = new Curso 
// {
//     Id = Guid.NewGuid(),
//     Titulo = "Programacion con C#",
//     Descripcion = "Las bases de la programacion",
//     FechaPublicacion = DateTime.Now
// };

// context.Add(cursoNuevo);
// await context.SaveChangesAsync();

// var cursos =  await context.Cursos!.ToListAsync();
// foreach(var curso in cursos)
// {
//     Console.WriteLine($"{curso.Id}   {curso.Titulo}");
// }