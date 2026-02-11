using System.Diagnostics;
using System.Linq;

namespace Lab3 {
public class Angajat() {
  public int id_angajat { get; set; }
  public string nume_angajat { get; set; }
  public bool calificat { get; set; }
  public double salariu { get; set; }
  public int id_adresa { get; set; }
}

public class Adresa() {
  public int id { get; set; }
  public string strada { get; set; }
  public int bloc { get; set; }
  public int apartament { get; set; }
}

public class UtilitatiLab3() {
  public static void AfiseazaAngajati(List<Angajat> lista_angajati) {
    foreach (var angajat in lista_angajati) {
      Console.WriteLine(
          $"Nume angajat: {angajat.nume_angajat}, Salariu: {angajat.salariu}, Calificat: {angajat.calificat}, Adresa: {angajat.id_adresa}");
    }
  }

  internal static void
  AfiseazaGrupAngajati(List<IGrouping<double, Angajat>> list) {
    foreach (var grup in list) {
      foreach (var valoare in grup) {
        Console.WriteLine(
            $"Nunme angajat: {valoare.nume_angajat}, Salariu: {valoare.salariu}");
      }
    }
  }

  internal static void AfiseazaColectie(List<int> colectie) {
    foreach (var numar in colectie) {
      Console.WriteLine(numar);
    }
  }
}

class Program() {
  static void Main(string[] args) {
    try {
      // Adaugare angajati
      List<Angajat> lista_angajati = new List<Angajat> {
        new Angajat { id_angajat = 1, nume_angajat = "Gheruha Maxim",
                      calificat = true, salariu = 20000, id_adresa = 1 },
        new Angajat { id_angajat = 2, nume_angajat = "Pinzari Adrian",
                      calificat = true, salariu = 20000, id_adresa = 2 },
        new Angajat { id_angajat = 3, nume_angajat = "Curnic Dorin",
                      calificat = true, salariu = 40000, id_adresa = 3 },
        new Angajat { id_angajat = 4, nume_angajat = "Petcu Adrian",
                      calificat = true, salariu = 30000, id_adresa = 4 },
        new Angajat { id_angajat = 5, nume_angajat = "Sandu Maxim",
                      calificat = true, salariu = 50000, id_adresa = 5 },
      };

      // Adaugare adrese
      List<Adresa> lista_adreselor = new List<Adresa>() {
        new Adresa { id = 1, strada = "Hincesti", bloc = 10, apartament = 39 },
        new Adresa { id = 2, strada = "Ialoveni", bloc = 10, apartament = 39 },
        new Adresa { id = 3, strada = "Chisinau", bloc = 10, apartament = 39 },
        new Adresa { id = 4, strada = "Cahul", bloc = 10, apartament = 39 },
        new Adresa { id = 5, strada = "Hincesti", bloc = 10, apartament = 39 },
      };

      // Afisarea numelui si adresei angajatilor
      var angajati_nume_adresa = lista_angajati.Join(
          lista_adreselor, angajat => angajat.id_adresa, adresa => adresa.id,
          (angajat, adresa) => new { nume_angajat = angajat.nume_angajat,
                                     adresa_angajat = adresa.strada });

      // Afisare angajati_nume_adresa:
      foreach (var angajat in angajati_nume_adresa) {
        Console.WriteLine(
            $"Nume angajat: {angajat.nume_angajat}, Adresa: {angajat.adresa_angajat}");
      }

      // Gruparea angajații după salariu
      var angajati_grupati_dupa_salariu =
          lista_angajati.GroupBy(angajat => angajat.salariu);
      UtilitatiLab3.AfiseazaGrupAngajati(
          angajati_grupati_dupa_salariu.ToList());

      // Crearea celor doua colectii de cifre:
      List<int> colectie1 = new List<int> { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
      List<int> colectie2 = new List<int> { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14 };

      // Afisarea valorilor distincte din colectia 1
      var colectie1_distincte = colectie1.Distinct();
      Console.WriteLine("Afisarea valorilor distincte din colectia 1:");
      UtilitatiLab3.AfiseazaColectie(colectie1_distincte.ToList());

      // Afisarea elementelor ce apar in colectia 1 dar nu apar in colectia 2
      var colectie1_fara_colectie2 = colectie1.Except(colectie2);
      Console.WriteLine("Afisarea elementelor ce apar in colectia 1 dar nu " +
                        "apar in colectia 2:");
      UtilitatiLab3.AfiseazaColectie(colectie1_fara_colectie2.ToList());

      // Afisarea elementelor ce apar in ambele colectii
      var colectie1_si_colectie2 = colectie1.Intersect(colectie2);
      Console.WriteLine("Afisarea elementelor ce apar in ambele colectii");
      UtilitatiLab3.AfiseazaColectie(colectie1_si_colectie2.ToList());

      // Afisarea elementelor unice din cele doua colectii
      var colectie1_unica = colectie1.Distinct();
      var colectie2_unica = colectie2.Distinct();
      var colectie_unica = colectie1_unica.Union(colectie2_unica);

      Console.WriteLine("Afisarea elementelor unice din cele doua colectii");
      UtilitatiLab3.AfiseazaColectie(colectie_unica.ToList());

      // Vericarea unui numar cu ajutorul metodei DefaultIfEmpty
      int numar_cautat = 100;
      var verificare =
          colectie_unica.DefaultIfEmpty(numar_cautat).Contains(numar_cautat);
      Console.WriteLine(
          "Vericarea unui numar cu ajutorul metodei DefaultIfEmpty");
      Console.WriteLine(verificare);

      // Generarea unei secvențe de 1000 de numere întregi
      IEnumerable<int> secventa_1000 = Enumerable.Range(10, 1010);
      UtilitatiLab3.AfiseazaColectie(secventa_1000.ToList());

      // Generarea unei secvențe în care se repetă numărul 7 de 100 de ori
      IEnumerable<int> secventa_7 = Enumerable.Repeat(7, 100);
      UtilitatiLab3.AfiseazaColectie(secventa_7.ToList());
    } catch (Exception ex) {
      Console.WriteLine(ex.Message);
    }
  }
}

}
