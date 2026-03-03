using System;
using System.Data;
using System.Linq;
/*
Crearea unui DataSet cu un DataTable
Creați un DataSet și adaugați un DataTable numit Produse.
Adaugați coloanele: ID (int), NumeProdus (string), Categorie (string), Pret
(decimal). Adaugați  5-6 produse fictive. Selectați  și afișați toate produsele
din tabel. Grupați produsele pe categorii și afișați rezultatele lor. Selectați
toate produsele cu preț mai mare de 100 lei
 * */
namespace Laboratorul6 {
class Program() {
  static void Main(string[] args) {
    DataSet produseData = new DataSet("Produse");
    // Crearea data table pentru Produse
    DataTable produseTable = new DataTable("ProduseTable");
    produseTable.Columns.Add("ID", typeof(int));
    produseTable.Columns.Add("Nume Produs", typeof(string));
    produseTable.Columns.Add("Categorie", typeof(string));
    produseTable.Columns.Add("Pret", typeof(decimal));

    // Adaugare date
    produseData.Tables.Add(produseTable);
    produseTable.Rows.Add(1, "Laptop 1", "Calculatoare", 20000);
    produseTable.Rows.Add(2, "Calculator 1", "Calculatoare", 40000);
    produseTable.Rows.Add(3, "Telefon 1", "Smartphones", 10000);
    produseTable.Rows.Add(4, "Mouse", "Accestorii", 100);
    produseTable.Rows.Add(5, "Tastatura", "Accesorii", 350);
    produseTable.Rows.Add(6, "Telefon 2", "Smartphones", 15000);

    // Afisarea tuturor datelor din tabel
    var produse_all =
        produseTable.AsEnumerable()
            .Select(row => new { ID = row.Field<int>("ID"),
                                 NumeProdus = row.Field<string>("Nume produs"),
                                 Categorie = row.Field<string>("Categorie"),
                                 Pret = row.Field<decimal>("Pret") })
            .ToList();
    foreach (var p in produse_all) {
      Console.WriteLine(
          $"ID: {p.ID}, Nume Produs: {p.NumeProdus}, Categorie: {p.Categorie}, Pret: {p.Pret}");
    }

    // Gruparea si afisarea produselor dupa categorie
    var produse_grupate =
        from produs in produseTable.AsEnumerable()
            group produs by produs.Field<string>("Categorie")
                into categorie select new { Categorie = categorie.Key,
                                            Produse = categorie };
    foreach (var g in produse_grupate) {
      Console.WriteLine($"\nCategorie: {g.Categorie}");
      foreach (var row in g.Produse) {
        Console.WriteLine(
            $"{row.Field<int>("ID")}, {row.Field<string>("Nume Produs")}, {row.Field<decimal>("Pret")}");
      }
    }

    var produse_scumpe =
        from produs in produseTable
            .AsEnumerable()
                where produs.Field<decimal>("Pret")> 100 select new {
      ID = produs.Field<int>("ID"),
                             NumeProdus = produs.Field<string>(
                                 "Nume produs"),
                                 Categorie = produs.Field<string>(
                                     "Categorie"),
                                     Pret = produs.Field<decimal>("Pret") };

    Console.WriteLine("Produse mai scumple de 100 de lei: ");
    foreach (var p in produse_scumpe.ToList()) {
      Console.WriteLine(
          $"ID: {p.ID}, Nume Produs: {p.NumeProdus}, Categorie: {p.Categorie}, Pret: {p.Pret}");
    }
  }
}
}
