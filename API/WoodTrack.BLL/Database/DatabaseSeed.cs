namespace WoodTrack.BLL.Database;

public partial class DatabaseContext
{
    public void Initialize()
    {
        if (Database.GetAppliedMigrations()?.Count() == 0)
            Database.Migrate();
    }

    private readonly DateTime _dateTime = new(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local);
    private void SeedData(ModelBuilder modelBuilder)
    {
        SeedCountries(modelBuilder);
        SeedCities(modelBuilder);
        SeedUsers(modelBuilder);
        SeedRoles(modelBuilder);
        SeedUserRoles(modelBuilder);
        SeedProductsAndCategories(modelBuilder);
        SeedReviews(modelBuilder);
        SeedTools(modelBuilder);
    }

    private void SeedCountries(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Country>().HasData(
             new Country
             {
                 Id = 1,
                 Abrv = "BiH",
                 DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                 IsActive = true,
                 IsDeleted = false,
                 Name = "Bosna i Hercegovina"
             },
              new Country
              {
                  Id = 2,
                  Abrv = "HR",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Hrvatska"
              },
              new Country
              {
                  Id = 3,
                  Abrv = "SRB",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Srbija"
              },
              new Country
              {
                  Id = 4,
                  Abrv = "CG",
                  DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                  IsActive = true,
                  IsDeleted = false,
                  Name = "Crna Gora"
              },
            new Country
            {
                Id = 5,
                Abrv = "MKD",
                DateCreated = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                IsActive = true,
                IsDeleted = false,
                Name = "Makedonija"
            });

    }
    private void SeedCities(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<City>().HasData(
            new()
            {
                Id = 1,
                Name = "Mostar",
                Abrv = "MO",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 2,
                Name = "Sarajevo",
                Abrv = "SA",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 3,
                Name = "Jajce",
                Abrv = "JC",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 4,
                Name = "Tuzla",
                Abrv = "TZ",
                CountryId = 1,
                IsActive = true,
                DateCreated = _dateTime
            },
            new()
            {
                Id = 5,
                Name = "Zagreb",
                Abrv = "ZG",
                CountryId = 2,
                IsActive = true,
                DateCreated = _dateTime
            });
    }
    private void SeedUsers(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<User>().HasData(
            new User
            {
                Id = 1,
                IsActive = true,
                Email = "site.admin@wood_track.com",
                NormalizedEmail = "SITE.ADMIN@WOOD_TRACK.COM",
                UserName = "site.admin",
                NormalizedUserName = "SITE.ADMIN",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1999, 5, 5),
                FirstName = "Site",
                LastName = "Admin",
                Gender = Gender.Male,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 2,
                IsActive = true,
                Email = "employee@mail.com",
                NormalizedEmail = "EMPLOYEE@MAIL.COM",
                UserName = "employee",
                NormalizedUserName = "EMPLOYEE",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(2005, 5, 5),
                FirstName = "Employee",
                LastName = "1",
                Gender = Gender.Male,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 3,
                IsActive = true,
                Email = "client1@mail.com",
                NormalizedEmail = "CLIENT1@MAIL.COM",
                UserName = "client1",
                NormalizedUserName = "CLIENT1",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1999, 5, 5),
                FirstName = "Client",
                LastName = "1",
                Gender = Gender.Male,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 4,
                IsActive = true,
                Email = "client2@mail.com",
                NormalizedEmail = "CLIENT2@MAIL.COM",
                UserName = "client2",
                NormalizedUserName = "CLIENT2",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1979, 5, 5),
                FirstName = "Client",
                LastName = "2",
                Gender = Gender.Female,
                DateCreated = _dateTime
            },
            new User
            {
                Id = 5,
                IsActive = true,
                Email = "client3@mail.com",
                NormalizedEmail = "Client3@MAIL.COM",
                UserName = "client3",
                NormalizedUserName = "CLIENT3",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                Address = "Mostar b.b",
                BirthDate = new DateTime(1989, 5, 5),
                FirstName = "Client",
                LastName = "3",
                Gender = Gender.Male,
                DateCreated = _dateTime
            }
        );
    }

    private void SeedRoles(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Role>().HasData(
            new Role
            {
                Id = 1,
                RoleLevel = RoleLevel.Administrator,
                DateCreated = _dateTime,
                Name = "Administrator",
                NormalizedName = "ADMINISTRATOR",
                ConcurrencyStamp = Guid.NewGuid().ToString()
            },
             new Role
             {
                 Id = 2,
                 RoleLevel = RoleLevel.Employee,
                 DateCreated = _dateTime,
                 Name = "Employee",
                 NormalizedName = "EMPLOYEE",
                 ConcurrencyStamp = Guid.NewGuid().ToString()
             },
             new Role
             {
                 Id = 3,
                 RoleLevel = RoleLevel.Client,
                 DateCreated = _dateTime,
                 Name = "Client",
                 NormalizedName = "CLIENT",
                 ConcurrencyStamp = Guid.NewGuid().ToString()
             }
        );
    }
    private void SeedUserRoles(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<UserRole>().HasData(
            new UserRole
            {
                Id = 1,
                DateCreated = _dateTime,
                UserId = 1,
                RoleId = 1
            },
             new UserRole
             {
                 Id = 2,
                 DateCreated = _dateTime,
                 UserId = 2,
                 RoleId = 2
             },
              new UserRole
              {
                  Id = 3,
                  DateCreated = _dateTime,
                  UserId = 3,
                  RoleId = 3
              },
              new UserRole
              {
                  Id = 4,
                  DateCreated = _dateTime,
                  UserId = 4,
                  RoleId = 3
              },
              new UserRole
              {
                  Id = 5,
                  DateCreated = _dateTime,
                  UserId = 5,
                  RoleId = 3
              }
        );
    }
    public void SeedProductsAndCategories(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ProductCategory>().HasData(
            new ProductCategory
            {
                Id = 1,
                Name = "Dekorativni predmeti",
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new ProductCategory
            {
                Id = 2,
                Name = "Kuhinjski pribor",
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new ProductCategory
            {
                Id = 3,
                Name = "Namještaj",
                DateCreated = _dateTime,
                IsDeleted = false
            }
        );

        modelBuilder.Entity<Product>().HasData(
            new Product
            {
                Id = 1,
                Name = "Drvena kutija za nakit", Description = "Ručno izrađena kutija od oraha s rezbarijama.", Price = 49.99m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "WoodArt", Barcode = "1234567890123", ProductCategoryId = 1, Length = 20m, Width = 15m, Height = 10m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 2,
                Name = "Set drvenih kašika", Description = "Set od 3 kašike od bukovog drveta, ručno izrađene.", Price = 24.50m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "HandyCraft", Barcode = "1234567890124", ProductCategoryId = 2, Length = 30m, Width = 6m, Height = 2m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 3,
                Name = "Stolica od hrasta", Description = "Ručno izrađena stolica od hrastovine sa dekorativnim detaljima.", Price = 120.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "CarveMasters", Barcode = "1234567890125", ProductCategoryId = 3, Length = 45m, Width = 45m, Height = 90m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 4,
                Name = "Drveni sat", Description = "Elegantni zidni sat od bukve.", Price = 55.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "WoodClock", Barcode = "1234567890126", ProductCategoryId = 1, Length = 35m, Width = 35m, Height = 5m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 5,
                Name = "Drveni poslužavnik", Description = "Ručni rad od trešnjinog drveta.", Price = 35.99m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "TrayMasters", Barcode = "1234567890127", ProductCategoryId = 2, Length = 40m, Width = 30m, Height = 3m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 6,
                Name = "Drvena vješalica", Description = "Dekorativna zidna vješalica.", Price = 22.50m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "HookWood", Barcode = "1234567890128", ProductCategoryId = 1, Length = 50m, Width = 5m, Height = 10m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 7,
                Name = "Daska za rezanje", Description = "Kvalitetna daska od bambusa.", Price = 18.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "KitchenPro", Barcode = "1234567890129", ProductCategoryId = 2, Length = 45m, Width = 30m, Height = 2m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 8,
                Name = "Drveni krevet", Description = "Masivni krevet od borovine.", Price = 350.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "SolidSleep", Barcode = "1234567890130", ProductCategoryId = 3, Length = 200m, Width = 160m, Height = 50m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 9,
                Name = "Polica za knjige", Description = "Elegantna polica od hrastovine.", Price = 80.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "ShelfCraft", Barcode = "1234567890131", ProductCategoryId = 3, Length = 80m, Width = 25m, Height = 180m, DateCreated = _dateTime, IsDeleted = false },
            new Product
            {
                Id = 10,
                Name = "Drveni tanjir", Description = "Ručno izrađen tanjir od oraha.", Price = 15.00m, ImageUrl = "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", IsEnable = true, Manufacturer = "PlateWood", Barcode = "1234567890132", ProductCategoryId = 2, Length = 25m, Width = 25m, Height = 2m, DateCreated = _dateTime, IsDeleted = false
            }
        );
    }
    private void SeedReviews(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Review>().HasData(
            new Review { Id = 1, ClientId = 3, ProductId = 1, Rating = 5, Comment = "Odlično!", DateCreated = _dateTime },
            new Review { Id = 2, ClientId = 3, ProductId = 2, Rating = 4, Comment = "Vrlo korisno.", DateCreated = _dateTime },
            new Review { Id = 3, ClientId = 3, ProductId = 3, Rating = 2, Comment = "Nije po mom ukusu.", DateCreated = _dateTime },
            new Review { Id = 4, ClientId = 3, ProductId = 4, Rating = 4, Comment = "Lijep dizajn.", DateCreated = _dateTime },

            new Review { Id = 5, ClientId = 4, ProductId = 2, Rating = 3, Comment = "Solidno.", DateCreated = _dateTime },
            new Review { Id = 6, ClientId = 4, ProductId = 3, Rating = 4, Comment = "Preporučujem.", DateCreated = _dateTime },
            new Review { Id = 7, ClientId = 4, ProductId = 4, Rating = 5, Comment = "Savršeno!", DateCreated = _dateTime },
            new Review { Id = 8, ClientId = 4, ProductId = 5, Rating = 2, Comment = "Očekivao sam više.", DateCreated = _dateTime },

            new Review { Id = 9, ClientId = 5, ProductId = 1, Rating = 4, Comment = "Jako korisno.", DateCreated = _dateTime },
            new Review { Id = 10, ClientId = 5, ProductId = 5, Rating = 5, Comment = "Izvrsno!", DateCreated = _dateTime },
            new Review { Id = 11, ClientId = 5, ProductId = 6, Rating = 2, Comment = "Nije baš kvalitetno.", DateCreated = _dateTime },
            new Review { Id = 12, ClientId = 5, ProductId = 10, Rating = 3, Comment = "Ok.", DateCreated = _dateTime },

            new Review { Id = 13, ClientId = 2, ProductId = 1, Rating = 2, Comment = "Nisam zadovoljan.", DateCreated = _dateTime },
            new Review { Id = 14, ClientId = 2, ProductId = 3, Rating = 4, Comment = "Može proći.", DateCreated = _dateTime },
            new Review { Id = 15, ClientId = 2, ProductId = 6, Rating = 5, Comment = "Odlična izrada!", DateCreated = _dateTime },

            new Review { Id = 16, ClientId = 1, ProductId = 7, Rating = 4, Comment = "Koristan proizvod.", DateCreated = _dateTime },
            new Review { Id = 17, ClientId = 1, ProductId = 8, Rating = 5, Comment = "Toplo preporučujem.", DateCreated = _dateTime },
            new Review { Id = 18, ClientId = 1, ProductId = 9, Rating = 2, Comment = "Nisam oduševljen.", DateCreated = _dateTime }
        );
    }

    private void SeedTools(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ToolCategory>().HasData(
            new ToolCategory { Id = 1, Name = "Električni alati", DateCreated = _dateTime, IsDeleted = false },
            new ToolCategory { Id = 2, Name = "Ručno oruđe", DateCreated = _dateTime, IsDeleted = false },
            new ToolCategory {Id = 3, Name = "Mjerni alati", DateCreated = _dateTime, IsDeleted = false }
        );

        modelBuilder.Entity<Tool>().HasData(
            new Tool
            {
                Id = 1,
                Code = "T-001",
                Name = "Bušilica",
                Description = "Električna bušilica za metal i drvo.",
                Dimension = 2.5M,
                ChargedDate = DateTime.Now.AddDays(-10),
                ToolCategoryId = 1,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 2,
                Code = "T-002",
                Name = "Odvijač",
                Description = "Set odvijača različitih veličina.",
                Dimension = 1.2M,
                ChargedDate = DateTime.Now.AddDays(-9),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 3,
                Code = "T-003",
                Name = "Metar",
                Description = "Mjerni metar dužine 5m.",
                Dimension = 0.5M,
                ChargedDate = DateTime.Now.AddDays(-8),
                ToolCategoryId = 3,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 4,
                Code = "T-004",
                Name = "Brusilica",
                Description = "Kutna brusilica za metal.",
                Dimension = 3.1M,
                ChargedDate = DateTime.Now.AddDays(-7),
                ToolCategoryId = 1,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 5,
                Code = "T-005",
                Name = "Čekić",
                Description = "Standardni čekić za građevinske radove.",
                Dimension = 1.8M,
                ChargedDate = DateTime.Now.AddDays(-6),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 6,
                Code = "T-006",
                Name = "Libela",
                Description = "Alat za nivelisanje površina.",
                Dimension = 0.7M,
                ChargedDate = DateTime.Now.AddDays(-5),
                ToolCategoryId = 3,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 7,
                Code = "T-007",
                Name = "Pila",
                Description = "Ručna pila za drvo.",
                Dimension = 2.3M,
                ChargedDate = DateTime.Now.AddDays(-4),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 8,
                Code = "T-008",
                Name = "Akumulatorska bušilica",
                Description = "Bežična bušilica sa baterijom.",
                Dimension = 2.0M,
                ChargedDate = DateTime.Now.AddDays(-3),
                ToolCategoryId = 1,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 9,
                Code = "T-009",
                Name = "Šubler",
                Description = "Digitalni mjerni alat za precizno mjerenje.",
                Dimension = 0.8M,
                ChargedDate = DateTime.Now.AddDays(-2),
                ToolCategoryId = 3,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 10,
                Code = "T-010",
                Name = "Kliješta",
                Description = "Izdržljiva kliješta za rad s kablovima.",
                Dimension = 1.1M,
                ChargedDate = DateTime.Now.AddDays(-1),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 11,
                Code = "T-011",
                Name = "Šrafciger",
                Description = "Električni šrafciger.",
                Dimension = 1.3M,
                ChargedDate = DateTime.Now,
                ToolCategoryId = 1,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 12,
                Code = "T-012",
                Name = "Ključ za matice",
                Description = "Set ključeva za matice.",
                Dimension = 2.2M,
                ChargedDate = DateTime.Now.AddDays(-12),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 13,
                Code = "T-013",
                Name = "Termometar",
                Description = "Digitalni termometar.",
                Dimension = 0.3M,
                ChargedDate = DateTime.Now.AddDays(-13),
                ToolCategoryId = 3,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 14,
                Code = "T-014",
                Name = "Glodalica",
                Description = "Električna glodalica.",
                Dimension = 2.8M,
                ChargedDate = DateTime.Now.AddDays(-14),
                ToolCategoryId = 1,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            },
            new Tool
            {
                Id = 15,
                Code = "T-015",
                Name = "Stega",
                Description = "Stolarska stega.",
                Dimension = 1.7M,
                ChargedDate = DateTime.Now.AddDays(-15),
                ToolCategoryId = 2,
                ChargedByUserId = 2,
                DateCreated = _dateTime,
                IsDeleted = false
            }
        );
    }
}
