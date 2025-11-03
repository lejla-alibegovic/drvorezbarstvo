namespace WoodTrack.BLL.Database;


internal class RoleConfiguration : BaseConfiguration<Role>
{
    public override void Configure(EntityTypeBuilder<Role> builder)
    {
        builder
             .Property(ar => ar.Id)
             .ValueGeneratedNever();
    }
}
