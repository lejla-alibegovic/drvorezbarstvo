namespace WoodTrack.Api.Controllers
{
    [ApiController]
    [Route("/[controller]/[action]")]
    public class AccessController : BaseController
    {
        private readonly IAccessManager _accessManager;
        private readonly IUsersService _usersService;
        private readonly IMapper _mapper;
        public AccessController(
            IAccessManager accessManager,
            IUsersService usersService,
            IMapper mapper,
            ILogger<AccessController> logger,
            IActivityLogsService activityLogs) : base(logger, activityLogs)
        {
            _accessManager = accessManager;
            _usersService = usersService;
            _mapper = mapper;
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(AccessSignInModel model, CancellationToken cancellationToken = default)
        {
            if (string.IsNullOrWhiteSpace(model.UserName) || string.IsNullOrWhiteSpace(model.Password))
                return BadRequest("Model is not valid");
            try
            {

                var loginInformation = await _accessManager.SignInAsync(model.UserName, model.Password);

                return Ok(loginInformation);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Registration([FromBody] RegistrationModel model)
        {
            try
            {
                return Ok(await _usersService.AddAsync(_mapper.Map<UserUpsertModel>(model)));
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when registration user");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _usersService.GetType().ToString(), e, null, model.UserName);
                return BadRequest(e.Message);
            }
        }
    }
}
