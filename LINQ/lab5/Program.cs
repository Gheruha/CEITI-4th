using System;
using System.Collections.Generic;
using System.Linq;

namespace Lab5 {
public class Produs() {
  public int id { get; set; }
  public string denumire { get; set; }
  public double pret { get; set; }
}

public class UtilitatiLab5() {
  public static void AfiseazaColectieInt(List<int> colectie) {
    foreach (var x in colectie) {
      Console.WriteLine(x);
    }
  }

  public static void AfiseazaUseri(List<string> useri) {
    foreach (var u in useri) {
      Console.WriteLine(u);
    }
  }

  public static void AfiseazaProduse(List<Produs> produse) {
    foreach (var p in produse) {
      Console.WriteLine($"{p.id}, {p.denumire}, {p.pret}");
    }
  }
}

class Program() {
  static void Main(string[] args) {
    try {
      List<int> colectie_numere = new List<int> {
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
      };

      List<string> colectie_useri = new List<string> {
        "maxim", "ana", "cristian99", "mihai", "ioana23", "dan", "valeriu",
        "alina", "denis007", "vlad"
      };

      List<Produs> colectie_produse = new List<Produs> {
        new Produs { id = 1, denumire = "Paine", pret = 7.50 },
        new Produs { id = 2, denumire = "Lapte", pret = 16.20 },
        new Produs { id = 3, denumire = "Oua", pret = 12.00 },
        new Produs { id = 4, denumire = "Branza", pret = 35.00 },
        new Produs { id = 5, denumire = "Apa", pret = 7.50 },
        new Produs { id = 6, denumire = "Cafea", pret = 68.00 },
        new Produs { id = 7, denumire = "Zahar", pret = 18.90 },
        new Produs { id = 8, denumire = "Sare", pret = 7.50 }
      };

      var numere_pare = colectie_numere.Where(n => n % 2 == 0);
      Console.WriteLine("Numere pare:");
      UtilitatiLab5.AfiseazaColectieInt(numere_pare.ToList());

      Console.WriteLine("Introdu lungimea numelui de utilizator:");
      int lungime = int.Parse(Console.ReadLine() ?? "0");

      var useri_lungime = colectie_useri.Where(u => u.Length == lungime);
      Console.WriteLine($"Useri cu lungimea {lungime}:");
      UtilitatiLab5.AfiseazaUseri(useri_lungime.ToList());

      var pret_minim = colectie_produse.Min(p => p.pret);
      var produse_pret_minim = colectie_produse.Where(p => p.pret == pret_minim);
      Console.WriteLine("Produse cu pret minim:");
      UtilitatiLab5.AfiseazaProduse(produse_pret_minim.ToList());

      var asteptare_numere = numere_pare.Where(n => n > 0);
      var urgenta_numere = numere_pare.ToList();

      var asteptare_useri = useri_lungime.Select(u => u);
      var urgenta_useri = useri_lungime.ToList();

      var asteptare_produse = produse_pret_minim.Select(p => p);
      var urgenta_produse = produse_pret_minim.ToList();

      Console.WriteLine("Operatii in asteptare (numere):");
      UtilitatiLab5.AfiseazaColectieInt(asteptare_numere.ToList());
      Console.WriteLine("Operatii de urgenta (numere):");
      UtilitatiLab5.AfiseazaColectieInt(urgenta_numere);

      Console.WriteLine("Operatii in asteptare (useri):");
      UtilitatiLab5.AfiseazaUseri(asteptare_useri.ToList());
      Console.WriteLine("Operatii de urgenta (useri):");
      UtilitatiLab5.AfiseazaUseri(urgenta_useri);

      Console.WriteLine("Operatii in asteptare (produse):");
      UtilitatiLab5.AfiseazaProduse(asteptare_produse.ToList());
      Console.WriteLine("Operatii de urgenta (produse):");
      UtilitatiLab5.AfiseazaProduse(urgenta_produse);

    } catch (Exception ex) {
      Console.WriteLine(ex.Message);
    }
  }
}
}
