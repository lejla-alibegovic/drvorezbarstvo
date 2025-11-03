using System.Net.Mail;
using WoodTrack.Common;
using WoodTrack.Common.Models;
using WoodTrack.Core.Models;

namespace WoodTrack.Api.Controllers;

[Authorize(AuthenticationSchemes = "Bearer")]
public class ToolOrdersController : BaseCrudController<ToolOrderModel, ToolOrderUpsertModel, BaseSearchObject, IToolOrdersService>
{
    private readonly IEmail _emailService;
    private readonly IToolOrdersService _service;

    public ToolOrdersController(
        IEmail emailService,
        IToolOrdersService service,
        ILogger<ToolOrdersController> logger,
        IActivityLogsService activityLogs,
        IMapper mapper) : base(service, logger, activityLogs)
    {
        this._emailService = emailService;
        _service = service;
    }

    [HttpPost("send-email")]
    public async Task<IActionResult> SendOrderEmail([FromForm] EmailRequest request)
    {
        try
        {
            if (string.IsNullOrWhiteSpace(request.To))
            {
                return BadRequest("Email recipient is required");
            }

            var iFormFile = GetFormFile();
            Attachment attachment = null;
            if (iFormFile != null)
            {
                attachment = ConvertIFormFileToAttachment(iFormFile);
            }

            await _emailService.Send(request.Subject, request.Body, request.To, attachment);

            return Ok(new { Message = "Email sent successfully" });
        }
        catch (Exception ex)
        {
            return StatusCode(500, "An error occurred while sending email");
        }
    }

    private Attachment ConvertIFormFileToAttachment(IFormFile file)
    {
        if (file.Length > 0)
        {
            var ms = new MemoryStream();
            file.CopyTo(ms);
            ms.Position = 0;
            return new Attachment(ms, file.FileName, file.ContentType);
        }
        return null;
    }
}
