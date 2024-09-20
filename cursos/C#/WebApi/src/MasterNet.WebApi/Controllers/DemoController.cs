using Microsoft.AspNetCore.Mvc;

namespace MasterNet.WebApi.Controllers;

[ApiController]
[Route("Demo")]
public class DemoController : ControllerBase
{

    [HttpGet("getstring")]
    public string GetNombre()
    {
        return "vaxidrez.com";
    }

}