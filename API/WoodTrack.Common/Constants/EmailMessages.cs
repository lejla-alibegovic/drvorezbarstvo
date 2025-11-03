namespace WoodTrack.Common;

public class EmailMessages
{
    public const string ConfirmationEmailSubject = "Drvorezbarska Radnja | Aktivacija naloga";

    public static string GeneratePasswordEmail(string name, string password)
    {
        string body =
            $"<div style='font-family:Arial,sans-serif;max-width:600px;margin:0 auto;color:#333;'>" +
            $"  <div style='background-color:#f8f5f0;padding:20px;text-align:center;border-bottom:3px solid #8b5a2b;'>" +
            $"    <h2 style='color:#5d4037;margin:0;'><i class='fas fa-tree'></i> Drvorezbarska Radnja</h2>" +
            $"    <p style='margin:5px 0 0;color:#a1887f;font-size:14px;'>Aplikacija za upravljanje narudžbama i proizvodnjom</p>" +
            $"  </div>" +
            $"  <div style='padding:30px;'>" +
            $"    <p style='font-size:16px;'>Poštovani {name},</p>" +
            $"    <p style='font-size:16px;'>Dobrodošli u aplikaciju naše drvorezbarske radnje!</p>" +
            $"    <p style='font-size:16px;'>Vaš korisnički nalog je uspešno kreiran.</p>" +
            $"    " +
            $"    <div style='background-color:#f8f5f0;padding:15px;border-radius:5px;margin:20px 0;text-align:center;border:1px solid #d7ccc8;'>" +
            $"      <p style='margin:5px 0;font-size:14px;'>Privremena lozinka za pristup sistemu:</p>" +
            $"      <p style='margin:5px 0;font-size:18px;font-weight:bold;letter-spacing:1px;color:#5d4037;'>{password}</p>" +
            $"      <p style='margin:5px 0;font-size:12px;color:#666;'>Obavezno promenite lozinku pri prvoj prijavi.</p>" +
            $"    </div>" +
            $"    " +
            $"    <p style='font-size:16px;'>U aplikaciji možete pratiti narudžbe, proizvodnju i stanje materijala.</p>" +
            $"    <p style='font-size:16px;'>Za pomoć ili pitanja, slobodno nas kontaktirajte.</p>" +
            $"    <p style='font-size:16px;'>S poštovanjem,<br/>Tim Drvorezbarske Radnje</p>" +
            $"  </div>" +
            $"  <div style='background-color:#f8f5f0;padding:15px;text-align:center;font-size:12px;color:#666;border-top:1px solid #d7ccc8;'>" +
            $"    <p>© {DateTime.Now.Year} Drvorezbarska Radnja. Sva prava zadržana.</p>" +
            $"  </div>" +
            $"</div>";

        return EmailWrapper.WrapBody(body);
    }
}
