using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace JakubSzaredkoEFProducts.Migrations
{
    /// <inheritdoc />
    public partial class BackToCompanyTPH : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersCompanyID",
                table: "ProductSupplier");

            migrationBuilder.DropTable(
                name: "Customers");

            migrationBuilder.DropTable(
                name: "Suppliers");

            migrationBuilder.AlterColumn<int>(
                name: "CompanyID",
                table: "Companies",
                type: "INTEGER",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "INTEGER")
                .Annotation("Sqlite:Autoincrement", true);

            migrationBuilder.AddColumn<string>(
                name: "Discriminator",
                table: "Companies",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_ProductSupplier_Companies_SuppliersCompanyID",
                table: "ProductSupplier",
                column: "SuppliersCompanyID",
                principalTable: "Companies",
                principalColumn: "CompanyID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ProductSupplier_Companies_SuppliersCompanyID",
                table: "ProductSupplier");

            migrationBuilder.DropColumn(
                name: "Discriminator",
                table: "Companies");

            migrationBuilder.AlterColumn<int>(
                name: "CompanyID",
                table: "Companies",
                type: "INTEGER",
                nullable: false,
                oldClrType: typeof(int),
                oldType: "INTEGER")
                .OldAnnotation("Sqlite:Autoincrement", true);

            migrationBuilder.CreateTable(
                name: "Customers",
                columns: table => new
                {
                    CompanyID = table.Column<int>(type: "INTEGER", nullable: false),
                    City = table.Column<string>(type: "TEXT", nullable: false),
                    CompanyName = table.Column<string>(type: "TEXT", nullable: false),
                    Street = table.Column<string>(type: "TEXT", nullable: false),
                    ZipCode = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Customers", x => x.CompanyID);
                });

            migrationBuilder.CreateTable(
                name: "Suppliers",
                columns: table => new
                {
                    CompanyID = table.Column<int>(type: "INTEGER", nullable: false),
                    City = table.Column<string>(type: "TEXT", nullable: false),
                    CompanyName = table.Column<string>(type: "TEXT", nullable: false),
                    Street = table.Column<string>(type: "TEXT", nullable: false),
                    ZipCode = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Suppliers", x => x.CompanyID);
                });

            migrationBuilder.AddForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersCompanyID",
                table: "ProductSupplier",
                column: "SuppliersCompanyID",
                principalTable: "Suppliers",
                principalColumn: "CompanyID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
