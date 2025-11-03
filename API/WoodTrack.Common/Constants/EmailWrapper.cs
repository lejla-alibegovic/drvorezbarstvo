namespace WoodTrack.Common;

public class EmailWrapper
{
    public static string WrapBody(string content)
    {
        StringBuilder body = new StringBuilder();
        body.AppendLine("<html>");
        body.AppendLine("<body>");
        body.AppendLine("<div style='width:70%;margin-left:auto;margin-right:auto;background-color:whitesmoke;margin-top:10px;max-width:640px;box-shadow:0px 1px 5px rgba(0,0,0,0.1);border-radius:4px;overflow:hidden;padding:15px;font-family:\"Segoe UI Webfont\",-apple-system,\"Helvetica Neue\",\"Lucida Grande\",\"Roboto\",\"Ebrima\",\"Nirmala UI\",\"Gadugi\",\"Segoe Xbox Symbol\",\"Segoe UI Symbol\",\"Meiryo UI\",\"Khmer UI\",\"Tunga\",\"Lao UI\",\"Raavi\",\"Iskoola Pota\",\"Latha\",\"Leelawadee\",\"Microsoft YaHei UI\",\"Microsoft JhengHei UI\",\"Malgun Gothic\",\"Estrangelo Edessa\",\"Microsoft Himalaya\",\"Microsoft New Tai Lue\",\"Microsoft PhagsPa\",\"Microsoft Tai Le\",\"Microsoft Yi Baiti\",\"Mongolian Baiti\",\"MV Boli\",\"Myanmar Text\",\"Cambria Math\"'>");
        body.AppendLine("<div style='color:black'>");

        body.AppendLine(content);

        body.AppendLine("</br> ");
        body.AppendLine("<hr style='background-color:#78498d9e;border:none;height:0.5px' />");
        body.AppendLine("<p style='color:#747F8D; font-size:13px; line-height:16px; text-align:left;'>");
        body.AppendLine("Ova e-pošta je automatski generisana. Molimo Vas da ne odgovarate na ovu poruku.</p>");
        body.AppendLine("<div style='text-align:left;'>");
        body.AppendLine("<span style='color:black;'>Lijep pozdrav,</span> <span style='font-weight: bold; color:black;'>Wood Track Team</span>");
        body.AppendLine("</div>");
        body.AppendLine("</div>");
        body.AppendLine("</div>");
        body.AppendLine("</body>");
        body.AppendLine("</html>");

        return body.ToString();
    }

}
