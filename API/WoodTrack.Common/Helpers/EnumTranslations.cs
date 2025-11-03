using WoodTrack.Core;

namespace WoodTrack.Common.Helpers;

public static class EnumTranslations
{
    public static readonly Dictionary<Gender, string> GenderTranslations = new Dictionary<Gender, string>
    {
        { Gender.Male, "Muško" },
        { Gender.Female, "Žensko" },
        { Gender.Unknown, "Nepoznato" }
    };
}
