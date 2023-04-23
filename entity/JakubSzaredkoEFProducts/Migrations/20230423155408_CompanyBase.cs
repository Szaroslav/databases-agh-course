using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace JakubSzaredkoEFProducts.Migrations
{
    /// <inheritdoc />
    public partial class CompanyBase : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersSupplierID",
                table: "ProductSupplier");

            migrationBuilder.RenameColumn(
                name: "SupplierID",
                table: "Suppliers",
                newName: "CompanyID");

            migrationBuilder.RenameColumn(
                name: "SuppliersSupplierID",
                table: "ProductSupplier",
                newName: "SuppliersCompanyID");

            migrationBuilder.RenameIndex(
                name: "IX_ProductSupplier_SuppliersSupplierID",
                table: "ProductSupplier",
                newName: "IX_ProductSupplier_SuppliersCompanyID");

            migrationBuilder.AlterColumn<string>(
                name: "Street",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "TEXT",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "City",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "TEXT",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ZipCode",
                table: "Suppliers",
                type: "TEXT",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "Customers",
                columns: table => new
                {
                    CompanyID = table.Column<int>(type: "INTEGER", nullable: false)
                        .Annotation("Sqlite:Autoincrement", true),
                    CompanyName = table.Column<string>(type: "TEXT", nullable: false),
                    Street = table.Column<string>(type: "TEXT", nullable: false),
                    City = table.Column<string>(type: "TEXT", nullable: false),
                    ZipCode = table.Column<string>(type: "TEXT", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Customers", x => x.CompanyID);
                });

            migrationBuilder.AddForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersCompanyID",
                table: "ProductSupplier",
                column: "SuppliersCompanyID",
                principalTable: "Suppliers",
                principalColumn: "CompanyID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersCompanyID",
                table: "ProductSupplier");

            migrationBuilder.DropTable(
                name: "Customers");

            migrationBuilder.DropColumn(
                name: "ZipCode",
                table: "Suppliers");

            migrationBuilder.RenameColumn(
                name: "CompanyID",
                table: "Suppliers",
                newName: "SupplierID");

            migrationBuilder.RenameColumn(
                name: "SuppliersCompanyID",
                table: "ProductSupplier",
                newName: "SuppliersSupplierID");

            migrationBuilder.RenameIndex(
                name: "IX_ProductSupplier_SuppliersCompanyID",
                table: "ProductSupplier",
                newName: "IX_ProductSupplier_SuppliersSupplierID");

            migrationBuilder.AlterColumn<string>(
                name: "Street",
                table: "Suppliers",
                type: "TEXT",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "TEXT");

            migrationBuilder.AlterColumn<string>(
                name: "City",
                table: "Suppliers",
                type: "TEXT",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "TEXT");

            migrationBuilder.AddForeignKey(
                name: "FK_ProductSupplier_Suppliers_SuppliersSupplierID",
                table: "ProductSupplier",
                column: "SuppliersSupplierID",
                principalTable: "Suppliers",
                principalColumn: "SupplierID",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
