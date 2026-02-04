using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Laboratorul1
{
    public class Elev
    {
        public int id { get; set; }
        public string nume { get; set; }
        public string prenume { get; set; }
        public int varsta { get; set; }
        public string genul { get; set; }
        public string telefon { get; set; }

        public string tip { get; set; }
    }
    public class UtilitatiElevi()
    {
        public static void Afiseaza(List<Elev> listaelivilor)
        {
            foreach (var elev in listaelivilor)
            {
                Console.WriteLine($"{elev.id}, {elev.nume}, {elev.prenume}, {elev.varsta}, {elev.genul}, {elev.telefon}, {elev.tip}");
            }

        }
    }
    class ElevLinq
    {


        static void Main(string[] args)
        {
            try
            {
                List<Elev> listaelevilor = new List<Elev>
            {
                new Elev() { id = 1, nume = "Popescu",   prenume = "Andrei",   varsta = 20, genul = "M", tip = "Buget",    telefon = "069123456" },
                new Elev() { id = 2, nume = "Ionescu",   prenume = "Maria",    varsta = 19, genul = "F", tip = "Contract", telefon = "067234567" },
                new Elev() { id = 3, nume = "Rusu",      prenume = "Vlad",     varsta = 22, genul = "M", tip = "Buget",    telefon = "068345678" },
                new Elev() { id = 4, nume = "Sandu",     prenume = "Elena",    varsta = 18, genul = "F", tip = "Contract", telefon = "079456789" },
                new Elev() { id = 5, nume = "Lungu",     prenume = "Daniel",   varsta = 25, genul = "M", tip = "Contract", telefon = "078567890" },
                new Elev() { id = 6, nume = "Rotaru",    prenume = "Ioana",    varsta = 21, genul = "F", tip = "Buget",    telefon = "060678920" },
                new Elev() { id = 7, nume = "Negru",     prenume = "Paul",     varsta = 17, genul = "M", tip = "Contract", telefon = "061789012" },
                new Elev() { id = 8, nume = "Stancu",    prenume = "Alina",    varsta = 23, genul = "F", tip = "Buget",    telefon = "062090123" },
                new Elev() { id = 9, nume = "Dumitru",   prenume = "Radu",     varsta = 19, genul = "M", tip = "Buget",    telefon = "063901234" },
                new Elev() { id = 10,nume = "Marin",     prenume = "Bianca",   varsta = 24, genul = "F", tip = "Contract", telefon = "064012345" }
            };


                // Selectarea elevilor ce sunt adulti 
                var adulti_fluent = listaelevilor.Where(e => e.varsta >= 18);
                var adulti_query = from elev
                                   in listaelevilor
                                   where elev.varsta >= 18
                                   select elev;

                Console.WriteLine("Lista adulti creata prin metoda (fluenta):");
                UtilitatiElevi.Afiseaza(adulti_fluent.ToList());
                Console.WriteLine("Lista adulti creata prin metoda (query):");
                UtilitatiElevi.Afiseaza(adulti_query.ToList());

                // Selectarea elevilor ce au numarul 20 in numarul de telefon
                var elevi_telefon_fluent = listaelevilor.Where(e => e.telefon.Contains("20"));
                var elevi_telefon_query = from elev
                                          in listaelevilor
                                          where elev.telefon.Contains("20")
                                          select elev;

                Console.WriteLine("Lista elevilor cu numar de telefon 'special' creata prin metoda (fluent):");
                UtilitatiElevi.Afiseaza(elevi_telefon_fluent.ToList());
                Console.WriteLine("Lista elevilor cu numar de telefon 'special' creata prin metoda (query):");
                UtilitatiElevi.Afiseaza(elevi_telefon_query.ToList());

                // Selectarea elevilor ce sunt la buget
                var elevi_buget_fluent = listaelevilor.Where(e => e.tip == "Buget");
                var elevi_buget_query = from elev
                                        in listaelevilor
                                        where elev.tip == "Buget"
                                        select elev;

                Console.WriteLine("Lista elevilor ce au buget creata prin metoda (fluent)");
                UtilitatiElevi.Afiseaza(elevi_buget_fluent.ToList());
                Console.WriteLine("Lista elevilor ce au buget creata prin metoda (query)");
                UtilitatiElevi.Afiseaza(elevi_buget_query.ToList());

                // Selectarea elevilor ale caror nume incepe cu litera M
                var elevi_nume_fluent = listaelevilor.Where(e => e.nume.Contains("M"));
                var elevi_nume_query = from elev
                                       in listaelevilor
                                       where elev.nume.Contains("M")
                                       select elev;

                Console.WriteLine("Lista elevilor ale caror nume incepe cu litera M creata prin metoda (fluent)");
                UtilitatiElevi.Afiseaza(elevi_nume_fluent.ToList());
                Console.WriteLine("Lista elevilor ale caror nume incepe cu litera M creata prin metoda (query)");
                UtilitatiElevi.Afiseaza(elevi_nume_query.ToList());

                // Selectarea elevilor ce sunt minori
                var elevi_minori_fluent = listaelevilor.Where(e =>
                {
                    if (e.varsta < 18)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                });
                Console.WriteLine("Lista elevilor care sunt minori prin metoda (fluent)");
                UtilitatiElevi.Afiseaza(elevi_minori_fluent.ToList());
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}

