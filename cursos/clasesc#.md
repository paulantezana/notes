# Curso de c#

Tipos de datos
    - Primitivos
        - Enteros
            - Con signo
                * sbyte
                * short
                * int
                * long
            - Sin signo
                * byte
                * ushort
                * uint
                * ulong
        - Reales
            * float
            * double
            * decimal
        - Boleanos true | false

# Metodos
    - Puede haber unsa sobrecarga de metodos
    - Existen los metodos de flecha "=>"

# checked
checked: es una centencia para verificar el desbordamiento en las opraciones aritmeticas, si hay desboradamiento se producira una exepcion.

unchecked:  lo opuesto a checked

# POO
* Los metodos y propiedades son privados (private) por defecto. pero, se recomienda inidicar private
    - private
    - protected
    - public

```c#
class Circulo
{
    private const double pi = 3.1416; // recomendacion // cuando es privado usar "camelCase"
    public double CalcularArea(int radio) // recomendacion // cuando es publico usar "PascalCase"
    {
        return pi * radio * radio;
    }
}
```

* Se puede dividir una clase en dos partes usando la centencia "partial"
```c#
partial class Coche
{
    public Coche() // Primer constructor
    {
        ruedas = 4;
    }

    public Coche(int ruedas) // Segundo Constructor
    {
        this.ruedas = ruedas;
    }
}

partial class Coche
{
    public string ObtenerInformacion() => $"El auto tiene {ruedas} ruedas";

    private int ruedas;
}
```
* Comentarios TODO: son comentarios que se marcan como una tarea y se mostraran en la lista de tareas de visual estudio.
```c#
// DOTO: comentario de una tarea pendiente
```

# Polimorfismo
* new : especifica que se esta redefiniedo un metodo de la clase heredada
* virtual: Obliga a las clases que lo heredena a estableser como sobre escrivir con "override"
* override: sobreescrive un metodo. funciona solo si la clase padre heredada tiene el metodo como "virtual"

# Interface
cuando se implementa la interfas obliga a la clase implementar todo los metodos definidos en la interfas
* Por combencion todo los interfaces deberian nombrase con la la letra inicial "I"

```c#
interface IMamiferosTerrestres
{
    int NumeroDePatas();
}

class Caballos : IMamiferosTerrestres
{
    public int NumeroDePatas()
    {
        Console.WriteLine("5");
        return 5;
    }
}
```

# Clases abstractas
Son clases de nivel mas superior posible que sus metodos abstractos en sus herencias son obligados a desarrollar.
* Cuando un metodo de una clase es abstracta la clase esta obligada a declararse como abstracta

```c#
abstract class Animales
{
    public void Respirar()
    {
        Console.WriteLine("Puedo respirar");
    }

    public abstract void GetNombre(); // Obliga en la herencia a desarollar
}

class Mamiferos : Animales
{
    public override void GetNombre()
    {
        Console.WriteLine("Mi nombre es GG");
    }
}
```

# Clases cellados
Impide que se herede la clase o impide que un medo de la clase sea sobreescrito al heredar

```c#
sealed class Caballos // Esta clase no podra se heredada
{
    ...
}

class Caballos 
{
    public sealed int NumeroDePatas() // Este metodo no podra ser reescrito en la herencia
    {
        Console.WriteLine("5");
        return 5;
    }
}
```

# Struct
- No permiten la declaracion de constructor por defect
- El compilador no inicia los campos. Puedes iniciarlos en el constructor
- No puede haber sobrecarga de constructores
- No hereda de otras clases pero si implementa interfaces
- Son sellados (sealed)

```c#
struct Caballos
{
    public Caballos(string nombre)
    {
        Console.WriteLine($"El nombre es {nombre}");
    }
    public int NumeroDePatas() // Este metodo no podra ser reescrito en la herencia
    {
        Console.WriteLine("5");
        return 5;
    }
}
```

# Enum
- Son un conjunto de constantes con nombre
- Sirve para reprecentar y manejar valores fijos (constantes en un programa)
```#c
enum Salarios { bajo = 100, bueno = 2000, excelente = 7000};
```


# Programacion Generica

































# Patrones de diseño
## Patron singelton