using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace WoodTrack.BLL.Migrations
{
    /// <inheritdoc />
    public partial class init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AspNetRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false),
                    RoleLevel = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Name = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Countries",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Countries", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ProductCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "ToolCategories",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ToolCategories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "AspNetRoleClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetRoleClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetRoleClaims_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUsers",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    IsFirstLogin = table.Column<bool>(type: "boolean", nullable: false),
                    VerificationSent = table.Column<bool>(type: "boolean", nullable: false),
                    FirstName = table.Column<string>(type: "text", nullable: true),
                    LastName = table.Column<string>(type: "text", nullable: true),
                    BirthDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    Gender = table.Column<int>(type: "integer", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: false),
                    ProfilePhoto = table.Column<string>(type: "text", nullable: true),
                    ProfilePhotoThumbnail = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    LicenseNumber = table.Column<string>(type: "text", nullable: true),
                    YearsOfExperience = table.Column<int>(type: "integer", nullable: true),
                    WorkingHours = table.Column<string>(type: "text", nullable: true),
                    Position = table.Column<string>(type: "text", nullable: true),
                    CountryId = table.Column<int>(type: "integer", nullable: true),
                    UserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedUserName = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    Email = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    NormalizedEmail = table.Column<string>(type: "character varying(256)", maxLength: 256, nullable: true),
                    EmailConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    PasswordHash = table.Column<string>(type: "text", nullable: true),
                    SecurityStamp = table.Column<string>(type: "text", nullable: true),
                    ConcurrencyStamp = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    PhoneNumberConfirmed = table.Column<bool>(type: "boolean", nullable: false),
                    TwoFactorEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    LockoutEnd = table.Column<DateTimeOffset>(type: "timestamp with time zone", nullable: true),
                    LockoutEnabled = table.Column<bool>(type: "boolean", nullable: false),
                    AccessFailedCount = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUsers", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUsers_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Cities",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Abrv = table.Column<string>(type: "text", nullable: false),
                    CountryId = table.Column<int>(type: "integer", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Cities", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Cities_Countries_CountryId",
                        column: x => x.CountryId,
                        principalTable: "Countries",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Products",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    Price = table.Column<decimal>(type: "numeric", nullable: false),
                    ImageUrl = table.Column<string>(type: "text", nullable: false),
                    IsEnable = table.Column<bool>(type: "boolean", nullable: false),
                    Manufacturer = table.Column<string>(type: "text", nullable: true),
                    Barcode = table.Column<string>(type: "text", nullable: true),
                    ProductCategoryId = table.Column<int>(type: "integer", nullable: false),
                    Length = table.Column<decimal>(type: "numeric", nullable: false),
                    Width = table.Column<decimal>(type: "numeric", nullable: false),
                    Height = table.Column<decimal>(type: "numeric", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Products", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Products_ProductCategories_ProductCategoryId",
                        column: x => x.ProductCategoryId,
                        principalTable: "ProductCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserClaims",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    ClaimType = table.Column<string>(type: "text", nullable: true),
                    ClaimValue = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserClaims", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserClaims_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserLogins",
                columns: table => new
                {
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    ProviderKey = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    ProviderDisplayName = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserLogins", x => new { x.LoginProvider, x.ProviderKey });
                    table.ForeignKey(
                        name: "FK_AspNetUserLogins_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserRoles",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    RoleId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserRoles", x => x.Id);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetRoles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "AspNetRoles",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_AspNetUserRoles_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "AspNetUserTokens",
                columns: table => new
                {
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    LoginProvider = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Id = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false),
                    Value = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AspNetUserTokens", x => new { x.UserId, x.LoginProvider, x.Name });
                    table.ForeignKey(
                        name: "FK_AspNetUserTokens_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Logs",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ActivityId = table.Column<int>(type: "integer", nullable: false),
                    TableName = table.Column<string>(type: "text", nullable: true),
                    RowId = table.Column<int>(type: "integer", nullable: true),
                    Email = table.Column<string>(type: "text", nullable: true),
                    IPAddress = table.Column<string>(type: "text", nullable: false),
                    HostName = table.Column<string>(type: "text", nullable: false),
                    WebBrowser = table.Column<string>(type: "text", nullable: false),
                    ActiveUrl = table.Column<string>(type: "text", nullable: false),
                    ReferrerUrl = table.Column<string>(type: "text", nullable: false),
                    Controller = table.Column<string>(type: "text", nullable: false),
                    ActionMethod = table.Column<string>(type: "text", nullable: false),
                    ExceptionType = table.Column<string>(type: "text", nullable: true),
                    ExceptionMessage = table.Column<string>(type: "text", nullable: true),
                    Description = table.Column<string>(type: "text", nullable: true),
                    UserId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Logs", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Logs_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    Message = table.Column<string>(type: "text", nullable: false),
                    Read = table.Column<bool>(type: "boolean", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Notifications_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ProductOrders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    CustomerId = table.Column<int>(type: "integer", nullable: false),
                    TransactionId = table.Column<string>(type: "text", nullable: true),
                    FullName = table.Column<string>(type: "text", nullable: true),
                    Address = table.Column<string>(type: "text", nullable: true),
                    PhoneNumber = table.Column<string>(type: "text", nullable: true),
                    Note = table.Column<string>(type: "text", nullable: true),
                    TotalAmount = table.Column<decimal>(type: "numeric", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    Date = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ProductOrders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ProductOrders_AspNetUsers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reports",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    PublisherId = table.Column<int>(type: "integer", nullable: true),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    Data = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reports", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reports_AspNetUsers_PublisherId",
                        column: x => x.PublisherId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "Tools",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    Code = table.Column<string>(type: "text", nullable: false),
                    Name = table.Column<string>(type: "text", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    Dimension = table.Column<decimal>(type: "numeric", nullable: false),
                    ChargedDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    LastServiceDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsNeedNewService = table.Column<bool>(type: "boolean", nullable: false),
                    ToolCategoryId = table.Column<int>(type: "integer", nullable: false),
                    ChargedByUserId = table.Column<int>(type: "integer", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Tools", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Tools_AspNetUsers_ChargedByUserId",
                        column: x => x.ChargedByUserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_Tools_ToolCategories_ToolCategoryId",
                        column: x => x.ToolCategoryId,
                        principalTable: "ToolCategories",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Reviews",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ClientId = table.Column<int>(type: "integer", nullable: false),
                    ProductId = table.Column<int>(type: "integer", nullable: true),
                    Rating = table.Column<int>(type: "integer", nullable: false),
                    Comment = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Reviews", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Reviews_AspNetUsers_ClientId",
                        column: x => x.ClientId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Reviews_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "OrderItems",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    OrderId = table.Column<int>(type: "integer", nullable: false),
                    ProductId = table.Column<int>(type: "integer", nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false),
                    UnitPrice = table.Column<decimal>(type: "numeric", nullable: false),
                    Notes = table.Column<string>(type: "text", nullable: true),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OrderItems", x => x.Id);
                    table.ForeignKey(
                        name: "FK_OrderItems_ProductOrders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "ProductOrders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_OrderItems_Products_ProductId",
                        column: x => x.ProductId,
                        principalTable: "Products",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Payments",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    IsPaid = table.Column<bool>(type: "boolean", nullable: false),
                    DateFrom = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateTo = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    CustomerId = table.Column<int>(type: "integer", nullable: false),
                    OrderId = table.Column<int>(type: "integer", nullable: false),
                    Price = table.Column<decimal>(type: "numeric", nullable: false),
                    Discount = table.Column<decimal>(type: "numeric", nullable: true),
                    Note = table.Column<string>(type: "text", nullable: true),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    Status = table.Column<int>(type: "integer", nullable: false),
                    TransactionId = table.Column<string>(type: "text", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Payments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Payments_AspNetUsers_CustomerId",
                        column: x => x.CustomerId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Payments_ProductOrders_OrderId",
                        column: x => x.OrderId,
                        principalTable: "ProductOrders",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ToolOrders",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    ToolId = table.Column<int>(type: "integer", nullable: false),
                    Quantity = table.Column<int>(type: "integer", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    DeliveryDate = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ToolOrders", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ToolOrders_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ToolOrders_Tools_ToolId",
                        column: x => x.ToolId,
                        principalTable: "Tools",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ToolServices",
                columns: table => new
                {
                    Id = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    NewDimension = table.Column<decimal>(type: "numeric", nullable: false),
                    DeadlineFinishedAt = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    Description = table.Column<string>(type: "text", nullable: false),
                    ToolId = table.Column<int>(type: "integer", nullable: false),
                    UserId = table.Column<int>(type: "integer", nullable: false),
                    DateCreated = table.Column<DateTime>(type: "timestamp without time zone", nullable: false),
                    DateUpdated = table.Column<DateTime>(type: "timestamp without time zone", nullable: true),
                    IsDeleted = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ToolServices", x => x.Id);
                    table.ForeignKey(
                        name: "FK_ToolServices_AspNetUsers_UserId",
                        column: x => x.UserId,
                        principalTable: "AspNetUsers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_ToolServices_Tools_ToolId",
                        column: x => x.ToolId,
                        principalTable: "Tools",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.InsertData(
                table: "AspNetRoles",
                columns: new[] { "Id", "ConcurrencyStamp", "DateCreated", "DateUpdated", "IsDeleted", "Name", "NormalizedName", "RoleLevel" },
                values: new object[,]
                {
                    { 1, "7d8393ad-9253-4948-bdcb-5d91ae2b5c97", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Administrator", "ADMINISTRATOR", 1 },
                    { 2, "3930cafa-fa82-4f9d-a82d-7a9e119b07f5", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Employee", "EMPLOYEE", 2 },
                    { 3, "bea04793-70bc-4521-8810-b7ba1a3a4bbd", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Client", "CLIENT", 3 }
                });

            migrationBuilder.InsertData(
                table: "AspNetUsers",
                columns: new[] { "Id", "AccessFailedCount", "Address", "BirthDate", "ConcurrencyStamp", "CountryId", "DateCreated", "DateUpdated", "Description", "Email", "EmailConfirmed", "FirstName", "Gender", "IsActive", "IsDeleted", "IsFirstLogin", "LastName", "LicenseNumber", "LockoutEnabled", "LockoutEnd", "NormalizedEmail", "NormalizedUserName", "PasswordHash", "PhoneNumber", "PhoneNumberConfirmed", "Position", "ProfilePhoto", "ProfilePhotoThumbnail", "SecurityStamp", "TwoFactorEnabled", "UserName", "VerificationSent", "WorkingHours", "YearsOfExperience" },
                values: new object[,]
                {
                    { 1, 0, "Mostar b.b", new DateTime(1999, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "56ab6029-e19e-48e9-a96b-362d0a3bfb0b", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "site.admin@wood_track.com", true, "Site", 1, true, false, false, "Admin", null, false, null, "SITE.ADMIN@WOOD_TRACK.COM", "SITE.ADMIN", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "site.admin", false, null, null },
                    { 2, 0, "Mostar b.b", new DateTime(2005, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "fdfb00d7-22e9-44ff-b219-3b750381616b", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "employee@mail.com", true, "Employee", 1, true, false, false, "1", null, false, null, "EMPLOYEE@MAIL.COM", "EMPLOYEE", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "employee", false, null, null },
                    { 3, 0, "Mostar b.b", new DateTime(1999, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "ec1a662e-0e52-49ee-a857-3a092b99042e", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "client1@mail.com", true, "Client", 1, true, false, false, "1", null, false, null, "CLIENT1@MAIL.COM", "CLIENT1", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "client1", false, null, null },
                    { 4, 0, "Mostar b.b", new DateTime(1979, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "cdc38b35-0ca8-4620-8387-4119119aae13", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "client2@mail.com", true, "Client", 2, true, false, false, "2", null, false, null, "CLIENT2@MAIL.COM", "CLIENT2", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "client2", false, null, null },
                    { 5, 0, "Mostar b.b", new DateTime(1989, 5, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "7968f03c-5b29-4c7d-b33d-d3d81bf66d15", null, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, null, "client3@mail.com", true, "Client", 1, true, false, false, "3", null, false, null, "Client3@MAIL.COM", "CLIENT3", "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", "38762123456", false, null, null, null, null, false, "client3", false, null, null }
                });

            migrationBuilder.InsertData(
                table: "Countries",
                columns: new[] { "Id", "Abrv", "DateCreated", "DateUpdated", "IsActive", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "BiH", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Bosna i Hercegovina" },
                    { 2, "HR", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Hrvatska" },
                    { 3, "SRB", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Srbija" },
                    { 4, "CG", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Crna Gora" },
                    { 5, "MKD", new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), null, true, false, "Makedonija" }
                });

            migrationBuilder.InsertData(
                table: "ProductCategories",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Dekorativni predmeti" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Kuhinjski pribor" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Namještaj" }
                });

            migrationBuilder.InsertData(
                table: "ToolCategories",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Električni alati" },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Ručno oruđe" },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, "Mjerni alati" }
                });

            migrationBuilder.InsertData(
                table: "AspNetUserRoles",
                columns: new[] { "Id", "DateCreated", "DateUpdated", "IsDeleted", "RoleId", "UserId" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 1 },
                    { 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 2 },
                    { 3, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 3 },
                    { 4, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 4 },
                    { 5, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 5 }
                });

            migrationBuilder.InsertData(
                table: "Cities",
                columns: new[] { "Id", "Abrv", "CountryId", "DateCreated", "DateUpdated", "IsActive", "IsDeleted", "Name" },
                values: new object[,]
                {
                    { 1, "MO", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Mostar" },
                    { 2, "SA", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Sarajevo" },
                    { 3, "JC", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Jajce" },
                    { 4, "TZ", 1, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Tuzla" },
                    { 5, "ZG", 2, new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, true, false, "Zagreb" }
                });

            migrationBuilder.InsertData(
                table: "Products",
                columns: new[] { "Id", "Barcode", "DateCreated", "DateUpdated", "Description", "Height", "ImageUrl", "IsDeleted", "IsEnable", "Length", "Manufacturer", "Name", "Price", "ProductCategoryId", "Width" },
                values: new object[,]
                {
                    { 1, "1234567890123", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ručno izrađena kutija od oraha s rezbarijama.", 10m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 20m, "WoodArt", "Drvena kutija za nakit", 49.99m, 1, 15m },
                    { 2, "1234567890124", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Set od 3 kašike od bukovog drveta, ručno izrađene.", 2m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 30m, "HandyCraft", "Set drvenih kašika", 24.50m, 2, 6m },
                    { 3, "1234567890125", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ručno izrađena stolica od hrastovine sa dekorativnim detaljima.", 90m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 45m, "CarveMasters", "Stolica od hrasta", 120.00m, 3, 45m },
                    { 4, "1234567890126", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Elegantni zidni sat od bukve.", 5m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 35m, "WoodClock", "Drveni sat", 55.00m, 1, 35m },
                    { 5, "1234567890127", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ručni rad od trešnjinog drveta.", 3m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 40m, "TrayMasters", "Drveni poslužavnik", 35.99m, 2, 30m },
                    { 6, "1234567890128", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Dekorativna zidna vješalica.", 10m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 50m, "HookWood", "Drvena vješalica", 22.50m, 1, 5m },
                    { 7, "1234567890129", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Kvalitetna daska od bambusa.", 2m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 45m, "KitchenPro", "Daska za rezanje", 18.00m, 2, 30m },
                    { 8, "1234567890130", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Masivni krevet od borovine.", 50m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 200m, "SolidSleep", "Drveni krevet", 350.00m, 3, 160m },
                    { 9, "1234567890131", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Elegantna polica od hrastovine.", 180m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 80m, "ShelfCraft", "Polica za knjige", 80.00m, 3, 25m },
                    { 10, "1234567890132", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ručno izrađen tanjir od oraha.", 2m, "https://images.vexels.com/media/users/3/145231/isolated/lists/1a16851a4d591d118fab747af0f38b84-chair-furniture-icon.png", false, true, 25m, "PlateWood", "Drveni tanjir", 15.00m, 2, 25m }
                });

            migrationBuilder.InsertData(
                table: "Tools",
                columns: new[] { "Id", "ChargedByUserId", "ChargedDate", "Code", "DateCreated", "DateUpdated", "Description", "Dimension", "IsDeleted", "IsNeedNewService", "LastServiceDate", "Name", "ToolCategoryId" },
                values: new object[,]
                {
                    { 1, 2, new DateTime(2025, 10, 2, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7713), "T-001", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Električna bušilica za metal i drvo.", 2.5m, false, false, null, "Bušilica", 1 },
                    { 2, 2, new DateTime(2025, 10, 3, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7722), "T-002", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Set odvijača različitih veličina.", 1.2m, false, false, null, "Odvijač", 2 },
                    { 3, 2, new DateTime(2025, 10, 4, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7725), "T-003", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Mjerni metar dužine 5m.", 0.5m, false, false, null, "Metar", 3 },
                    { 4, 2, new DateTime(2025, 10, 5, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7729), "T-004", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Kutna brusilica za metal.", 3.1m, false, false, null, "Brusilica", 1 },
                    { 5, 2, new DateTime(2025, 10, 6, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7732), "T-005", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Standardni čekić za građevinske radove.", 1.8m, false, false, null, "Čekić", 2 },
                    { 6, 2, new DateTime(2025, 10, 7, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7735), "T-006", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Alat za nivelisanje površina.", 0.7m, false, false, null, "Libela", 3 },
                    { 7, 2, new DateTime(2025, 10, 8, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7738), "T-007", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Ručna pila za drvo.", 2.3m, false, false, null, "Pila", 2 },
                    { 8, 2, new DateTime(2025, 10, 9, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7742), "T-008", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Bežična bušilica sa baterijom.", 2.0m, false, false, null, "Akumulatorska bušilica", 1 },
                    { 9, 2, new DateTime(2025, 10, 10, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7745), "T-009", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Digitalni mjerni alat za precizno mjerenje.", 0.8m, false, false, null, "Šubler", 3 },
                    { 10, 2, new DateTime(2025, 10, 11, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7747), "T-010", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Izdržljiva kliješta za rad s kablovima.", 1.1m, false, false, null, "Kliješta", 2 },
                    { 11, 2, new DateTime(2025, 10, 12, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7750), "T-011", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Električni šrafciger.", 1.3m, false, false, null, "Šrafciger", 1 },
                    { 12, 2, new DateTime(2025, 9, 30, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7753), "T-012", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Set ključeva za matice.", 2.2m, false, false, null, "Ključ za matice", 2 },
                    { 13, 2, new DateTime(2025, 9, 29, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7757), "T-013", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Digitalni termometar.", 0.3m, false, false, null, "Termometar", 3 },
                    { 14, 2, new DateTime(2025, 9, 28, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7760), "T-014", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Električna glodalica.", 2.8m, false, false, null, "Glodalica", 1 },
                    { 15, 2, new DateTime(2025, 9, 27, 22, 41, 15, 362, DateTimeKind.Local).AddTicks(7762), "T-015", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, "Stolarska stega.", 1.7m, false, false, null, "Stega", 2 }
                });

            migrationBuilder.InsertData(
                table: "Reviews",
                columns: new[] { "Id", "ClientId", "Comment", "DateCreated", "DateUpdated", "IsDeleted", "ProductId", "Rating" },
                values: new object[,]
                {
                    { 1, 3, "Odlično!", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 5 },
                    { 2, 3, "Vrlo korisno.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 4 },
                    { 3, 3, "Nije po mom ukusu.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 2 },
                    { 4, 3, "Lijep dizajn.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 4, 4 },
                    { 5, 4, "Solidno.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 2, 3 },
                    { 6, 4, "Preporučujem.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 4 },
                    { 7, 4, "Savršeno!", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 4, 5 },
                    { 8, 4, "Očekivao sam više.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 5, 2 },
                    { 9, 5, "Jako korisno.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 4 },
                    { 10, 5, "Izvrsno!", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 5, 5 },
                    { 11, 5, "Nije baš kvalitetno.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 6, 2 },
                    { 12, 5, "Ok.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 10, 3 },
                    { 13, 2, "Nisam zadovoljan.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 1, 2 },
                    { 14, 2, "Može proći.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 3, 4 },
                    { 15, 2, "Odlična izrada!", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 6, 5 },
                    { 16, 1, "Koristan proizvod.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 7, 4 },
                    { 17, 1, "Toplo preporučujem.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 8, 5 },
                    { 18, 1, "Nisam oduševljen.", new DateTime(2025, 1, 1, 0, 0, 0, 0, DateTimeKind.Local), null, false, 9, 2 }
                });

            migrationBuilder.CreateIndex(
                name: "IX_AspNetRoleClaims_RoleId",
                table: "AspNetRoleClaims",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "RoleNameIndex",
                table: "AspNetRoles",
                column: "NormalizedName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserClaims_UserId",
                table: "AspNetUserClaims",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserLogins_UserId",
                table: "AspNetUserLogins",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_RoleId",
                table: "AspNetUserRoles",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUserRoles_UserId",
                table: "AspNetUserRoles",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "EmailIndex",
                table: "AspNetUsers",
                column: "NormalizedEmail");

            migrationBuilder.CreateIndex(
                name: "IX_AspNetUsers_CountryId",
                table: "AspNetUsers",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "UserNameIndex",
                table: "AspNetUsers",
                column: "NormalizedUserName",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Cities_CountryId",
                table: "Cities",
                column: "CountryId");

            migrationBuilder.CreateIndex(
                name: "IX_Logs_UserId",
                table: "Logs",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_UserId",
                table: "Notifications",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_OrderId",
                table: "OrderItems",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_OrderItems_ProductId",
                table: "OrderItems",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_CustomerId",
                table: "Payments",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_Payments_OrderId",
                table: "Payments",
                column: "OrderId");

            migrationBuilder.CreateIndex(
                name: "IX_ProductOrders_CustomerId",
                table: "ProductOrders",
                column: "CustomerId");

            migrationBuilder.CreateIndex(
                name: "IX_Products_ProductCategoryId",
                table: "Products",
                column: "ProductCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Reports_PublisherId",
                table: "Reports",
                column: "PublisherId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_ClientId",
                table: "Reviews",
                column: "ClientId");

            migrationBuilder.CreateIndex(
                name: "IX_Reviews_ProductId",
                table: "Reviews",
                column: "ProductId");

            migrationBuilder.CreateIndex(
                name: "IX_ToolOrders_ToolId",
                table: "ToolOrders",
                column: "ToolId");

            migrationBuilder.CreateIndex(
                name: "IX_ToolOrders_UserId",
                table: "ToolOrders",
                column: "UserId");

            migrationBuilder.CreateIndex(
                name: "IX_Tools_ChargedByUserId",
                table: "Tools",
                column: "ChargedByUserId");

            migrationBuilder.CreateIndex(
                name: "IX_Tools_ToolCategoryId",
                table: "Tools",
                column: "ToolCategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_ToolServices_ToolId",
                table: "ToolServices",
                column: "ToolId");

            migrationBuilder.CreateIndex(
                name: "IX_ToolServices_UserId",
                table: "ToolServices",
                column: "UserId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AspNetRoleClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserClaims");

            migrationBuilder.DropTable(
                name: "AspNetUserLogins");

            migrationBuilder.DropTable(
                name: "AspNetUserRoles");

            migrationBuilder.DropTable(
                name: "AspNetUserTokens");

            migrationBuilder.DropTable(
                name: "Cities");

            migrationBuilder.DropTable(
                name: "Logs");

            migrationBuilder.DropTable(
                name: "Notifications");

            migrationBuilder.DropTable(
                name: "OrderItems");

            migrationBuilder.DropTable(
                name: "Payments");

            migrationBuilder.DropTable(
                name: "Reports");

            migrationBuilder.DropTable(
                name: "Reviews");

            migrationBuilder.DropTable(
                name: "ToolOrders");

            migrationBuilder.DropTable(
                name: "ToolServices");

            migrationBuilder.DropTable(
                name: "AspNetRoles");

            migrationBuilder.DropTable(
                name: "ProductOrders");

            migrationBuilder.DropTable(
                name: "Products");

            migrationBuilder.DropTable(
                name: "Tools");

            migrationBuilder.DropTable(
                name: "ProductCategories");

            migrationBuilder.DropTable(
                name: "AspNetUsers");

            migrationBuilder.DropTable(
                name: "ToolCategories");

            migrationBuilder.DropTable(
                name: "Countries");
        }
    }
}
