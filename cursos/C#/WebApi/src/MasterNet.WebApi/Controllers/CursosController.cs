using MasterNet.Application.Cursos.CursoCreate;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Infrastructure;
using static MasterNet.Application.Cursos.CursoCreate.CursoCreateCommand;

namespace MasterNet.WebApi.Controllers;

[ApiController]
[Route("api/cursos")]
public class CursosController : ControllerBase
{
    private readonly ISender _sender;
    public CursosController(ISender sender)   
    {
        _sender = sender;
    }

    [HttpPost("create")]
    public async Task<ActionResult<Guid>> CursoCreate(
        [FromForm] CursoCreateRequest request,
        CancellationToken cancellationToken
    )
    {
        var command = new CursoCreateCommandRequest(request);
        var resultado = await _sender.Send(command, cancellationToken);
        return Ok(resultado);
    }
    

}