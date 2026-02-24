using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Xml.Linq;

namespace LabXML
{
    public class Carte()
    {
        public string titlu { get; set; }
        public string autor { get; set; }
        public string gen { get; set; }
        public double pret { get; set; }
    }

    public class UtilitatiLabXML()
    {
        public static void AfiseazaCarti(List<Carte> lista_carti)
        {
            foreach (var carte in lista_carti)
            {
                Console.WriteLine(
                    $"Titlu: {carte.titlu}, Autor: {carte.autor}, Gen: {carte.gen}, Pret: {carte.pret}");
            }
        }

        public static void AfiseazaTitluPret(List<Carte> lista_carti)
        {
            foreach (var carte in lista_carti)
            {
                Console.WriteLine($"Titlu: {carte.titlu}, Pret: {carte.pret}");
            }
        }

        public static void AfiseazaAutori(List<string> autori)
        {
            foreach (var autor in autori)
            {
                Console.WriteLine(autor);
            }
        }
    }

    class Program()
    {
        static void Main(string[] args)
        {
            try
            {
                string cale_xml = "carti.xml";
                XDocument doc = XDocument.Load(cale_xml);
                
                List<Carte> lista_carti =
                    doc.Root.Elements("book")
                        .Select(b => new Carte
                        {
                            titlu = (string)b.Element("title"),
                            autor = (string)b.Element("author"),
                            gen = (string)b.Element("genre"),
                            pret = double.Parse((string)b.Element("price"),
                                              CultureInfo.InvariantCulture)
                        })
                        .ToList();

                // Afisarea tuturor cartilor din fisier
                Console.WriteLine("1) Toate cartile din fisier:");
                UtilitatiLabXML.AfiseazaCarti(lista_carti);

                // Afisarea cartilor dintr-un anumit gen (citit de la utilizator)
                Console.WriteLine("\n2) Introdu genul (ex: Programare, Fictiune, Fantasy):");
                string gen_cautat = Console.ReadLine() ?? "";

                var carti_gen = lista_carti.Where(c =>
                    string.Equals(c.gen, gen_cautat, StringComparison.OrdinalIgnoreCase));

                Console.WriteLine($"\nCartile din genul: {gen_cautat}");
                UtilitatiLabXML.AfiseazaCarti(carti_gen.ToList());

                // Afisarea titlului si pretului cartilor cu pret mai mic decat o valoare
                Console.WriteLine("\n3) Introdu pretul maxim (ex: 20.5):");
                string input_pret = Console.ReadLine() ?? "0";

                if (!double.TryParse(input_pret, NumberStyles.Any, CultureInfo.InvariantCulture,
                                     out double pret_maxim))
                {
                    double.TryParse(input_pret, NumberStyles.Any, CultureInfo.GetCultureInfo("ro-RO"),
                                    out pret_maxim);
                }

                var carti_sub_pret = lista_carti.Where(c => c.pret < pret_maxim).ToList();

                Console.WriteLine($"\nTitlu si pret pentru cartile cu pret < {pret_maxim}:");
                UtilitatiLabXML.AfiseazaTitluPret(carti_sub_pret);

                // Afisarea autorilor fara duplicate
                var autori_distincti = lista_carti.Select(c => c.autor).Distinct().ToList();
                Console.WriteLine("\n4) Autorii (fara duplicate):");
                UtilitatiLabXML.AfiseazaAutori(autori_distincti);

                // Afisarea cartii cu cel mai mare pret
                var carte_max = lista_carti.OrderByDescending(c => c.pret).FirstOrDefault();
                Console.WriteLine("\n5) Cartea cu cel mai mare pret:");
                if (carte_max != null)
                {
                    UtilitatiLabXML.AfiseazaCarti(new List<Carte> { carte_max });
                }
                else
                {
                    Console.WriteLine("Nu exista carti in fisier.");
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
