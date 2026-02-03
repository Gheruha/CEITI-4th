using Lab2;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Lab2
{
    public class Film
    {
        public int idFilm { get; set; }
        public string denumire { get; set; }
        public double bugetul { get; set; }
        public int casa { get; set; }
        public string anul_aparitiei { get; set; }
        public int rating { get; set; }

    }
    public class UtilitatiFilme
    {
        public static void Afiseaza(List<Film> listafilmelor)
        {
            foreach (var film in listafilmelor)
            {
                Console.WriteLine($"{film.idFilm}, {film.denumire}, {film.bugetul}, {film.casa}, {film.anul_aparitiei}, {film.rating};");
            }
        }

        // Afisarea filmelor pana cand unul are denumirea mai mare de 10
        public static void Afiseaza_special(List<Film> listafilmelor)
        {
            foreach (var film in listafilmelor)
            {
                if (film.denumire.Length >= 10)
                {
                    break;
                }

                Console.WriteLine(
                    $"{film.idFilm}, {film.denumire}, {film.bugetul}, {film.casa}, {film.anul_aparitiei}, {film.rating}"
                );
            }
        }
    }
    class FilmLinq
    {


        static void Main(string[] args)
        {
            try
            {
                List<Film> listafilmelor = new List<Film>
                    {
                    new Film { idFilm = 1, denumire = "Dexter", bugetul = 25_000_000, casa = 130_000_000, anul_aparitiei = "2004", rating = 9 },
                    new Film { idFilm = 2, denumire = "Fast and Furious", bugetul = 38_000_000, casa = 207_000_000, anul_aparitiei = "2001", rating = 8 },
                    new Film { idFilm = 3, denumire = "Young Sheldon", bugetul = 20_000_000, casa = 150_000_000, anul_aparitiei = "2017", rating = 8 },
                    new Film { idFilm = 4, denumire = "Breaking Bad", bugetul = 30_000_000, casa = 300_000_000, anul_aparitiei = "2008", rating = 10 },
                    new Film { idFilm = 5, denumire = "The dark Knight", bugetul = 185_000_000, casa = 1_005_000_000, anul_aparitiei = "2008", rating = 10 },
                    new Film { idFilm = 6, denumire = "Inception", bugetul = 160_000, casa = 829_000_000, anul_aparitiei = "2010", rating = 9 },
                    new Film { idFilm = 7, denumire = "Interstellar", bugetul = 165_000_000, casa = 677_000_000, anul_aparitiei = "2014", rating = 9 },
                    new Film { idFilm = 8, denumire = "The Matrix", bugetul = 160_000, casa = 465_000_000, anul_aparitiei = "1999", rating = 9 },
                    new Film { idFilm = 9, denumire = "Peaky Blinders", bugetul = 18_000_000, casa = 120_000_000, anul_aparitiei = "2013", rating = 4 },
                    new Film { idFilm = 10, denumire = "The Big Bang Theory", bugetul = 22_000_000, casa = 280_000_000, anul_aparitiei = "2007", rating = 8 }
                    };

                // Afisarea filmelor cu bugetul de peste 200_000 prin (Query Syntax)
                var filme_buget = from filme
                                  in listafilmelor
                                  where filme.bugetul > 200_000
                                  select filme;
                Console.WriteLine("Filmele cu bugetul de peste 200000:");
                UtilitatiFilme.Afiseaza(filme_buget.ToList());

                // Afisarea filmelor ce incep cu litera D prin (Method Syntax)
                var filme_d = listafilmelor.Where(f => f.denumire.Contains("D"));
                Console.WriteLine("Lista filmelor ce incep cu litera D:");
                UtilitatiFilme.Afiseaza(filme_d.ToList());

                // Afisarea filmelor din 2004
                var filme_2004 = listafilmelor.Where(f => f.anul_aparitiei == "2004");
                Console.WriteLine("Lista filmelor ce au apartur in 2004:");
                UtilitatiFilme.Afiseaza(filme_2004.ToList());

                // Afisarea filmelor ce contin litera L
                var filme_l = listafilmelor.Where(f => f.denumire.Contains("L") || f.denumire.Contains("l"));
                Console.WriteLine("Lista filmelor ce contin litera L:");
                UtilitatiFilme.Afiseaza(filme_l.ToList());

                // Sortare filme in ordine crescatoare dupa denumire
                var filme_crescator = from filme
                                      in listafilmelor
                                      orderby filme.denumire
                                      select filme;
                Console.WriteLine("Lista filmelor in ordine crescatoare dupa denumire:");
                UtilitatiFilme.Afiseaza(filme_crescator.ToList());

                // Afisarea ultimului element din lista
                var film_ultimul = listafilmelor.Last();
                Console.WriteLine("Ultimul film din lista");
                UtilitatiFilme.Afiseaza(new List<Film> { film_ultimul });

                // Afisarea doar primului film din lista 
                var film_primul = listafilmelor.First();
                Console.WriteLine("Afisarea primul film din lista");
                UtilitatiFilme.Afiseaza(new List<Film> { film_primul });

                // Afisarea filmelor grupate dupa buget
                var filme_grupate_select =
                from film in listafilmelor
                group film by film.bugetul into g
                select new { Buget = g.Key, Filme = g.ToList() };
                Console.WriteLine("Afisarea filmelor greupate dupa buget");
                foreach (var g in filme_grupate_select)
                {
                    Console.WriteLine($"\nBuget: {g.Buget}");
                    UtilitatiFilme.Afiseaza(g.Filme);
                }

                // Afisarea filmelor cu ratingul mai mare de 5
                var filme_rating = listafilmelor.Where(f => f.rating > 5);
                Console.WriteLine("Lista filmelor cu rating mai mare de 5:");
                UtilitatiFilme.Afiseaza(filme_rating.ToList());

                // Afisarea filmelor pana cand unul are denumirea mai mare de 10
                Console.WriteLine("Lista filmelor pana cand unul are denumirea mai mare de 10:");
                UtilitatiFilme.Afiseaza_special(listafilmelor);

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}