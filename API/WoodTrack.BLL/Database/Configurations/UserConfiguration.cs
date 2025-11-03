namespace WoodTrack.BLL.Database;

internal class UserConfiguration : BaseConfiguration<User>
{
    public override void Configure(EntityTypeBuilder<User> builder)
    {
        builder
              .Property(u => u.Id);
    }
}
