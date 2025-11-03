namespace WoodTrack.Api;
public class FileManager : IFileManager
{
    private readonly IConfiguration _configuration;
    private readonly IWebHostEnvironment _webHostEnvironment;

    public FileManager(IConfiguration configuration, IWebHostEnvironment webHostEnvironment)
    {
        _configuration = configuration;
        _webHostEnvironment = webHostEnvironment;
    }

    public async Task<string> UploadFileAsync(IFormFile file)
    {
        var filePath = GetFilePath(file);
        await using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await file.CopyToAsync(fileStream);
        }
        return NormalizePath(Path.GetRelativePath(_webHostEnvironment.WebRootPath, filePath));
    }

    public void DeleteFile(string? filePath)
    {
        if (string.IsNullOrEmpty(filePath))
            return;

        if (!File.Exists(filePath))
            return;

        File.Delete(filePath);
    }

    private string GetFilePath(IFormFile file)
    {
        if (string.IsNullOrWhiteSpace(_webHostEnvironment.WebRootPath))
        {
            _webHostEnvironment.WebRootPath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot");
        }
        var fileExtension = Path.GetExtension(file.FileName);
        var fileType = GetFileType(fileExtension);
        if (fileType == FileType.Unknown)
        {
            return string.Empty;
        }
        var uploadsDirectoryPath = _configuration.GetSection("Uploads").GetSection(fileType.ToString()).Value;
        var fileName = $"{Path.GetFileNameWithoutExtension(file.FileName)}_{Guid.NewGuid()}{Path.GetExtension(file.FileName)}";
        var filePath = Path.Combine(_webHostEnvironment.WebRootPath, uploadsDirectoryPath!, fileName);

        var directoryPath = Path.GetDirectoryName(filePath);
        if (directoryPath == null)
            return string.Empty;

        if (!Directory.Exists(directoryPath))
            Directory.CreateDirectory(directoryPath);

        return filePath;
    }

    private string NormalizePath(string path)
    {
        return "/" + path.Replace(Path.DirectorySeparatorChar, '/');
    }

    private FileType GetFileType(string fileExtension)
    {
        if (string.IsNullOrEmpty(fileExtension))
            return FileType.Unknown;

        switch (fileExtension.ToLower())
        {
            case ".jpg":
            case ".jpeg":
            case ".png":
            case ".gif":
            case ".bmp":
            case ".jfif":
                return FileType.Image;

            case ".pdf":
            case ".doc":
            case ".docx":
            case ".xls":
            case ".xlsx":
            case ".ppt":
            case ".pptx":
                return FileType.Document;

            case ".mp4":
            case ".avi":
            case ".wmv":
            case ".mov":
                return FileType.Video;

            default: return FileType.Unknown;
        }
    }

}
