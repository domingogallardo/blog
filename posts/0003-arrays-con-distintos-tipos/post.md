<!--
** Title: Arrays con distintos tipos de datos en Swift
** Date: 
** Tags: Swift, Lenguajes de programación
-->

# Arrays con distintos tipos de datos en Swift

Una pregunta curiosa: ¿es posible definir un array con datos de
distintos tipos en un lenguaje fuertemente tipado como Swift? En
principio parece contradictorio. Si hay que especificar de forma
estricta el tipo del array, debemos especificar el tipo de sus
componentes:

```swift
var miArray: [Int] = []
```

El tipo del array anterior es `[Int]`. O sea que todos sus elementos
deben ser de tipo `Int`. 

¿Es siempre así en Swift? A priori parece demasiado rígido. Habrá
veces en las que necesitemos una cierta variabilidad en el tipo de los
elementos de un array. 

Vamos a ver que un lenguaje moderno como Swift tiene estrategias como
el polimorfismo o los genéricos que permiten, hasta ciertos límites,
agrupar datos variados en un mismo array.


## Lenguajes fuertemente tipados

En un lenguaje fuertemente tipado todas las variables, parámetros,
valores devueltos por las funciones, etc. deben tener un tipo
perfectamente especificado. Esto tiene muchas ventajas: el compilador
nos avisa de errores cuando compilamos el programa, el IDE nos
proporciona pistas al escribirlo y el código resultante es más legible
y fácil de entender. 

Sin embargo, el hecho de que todo deba tener un tipo predeterminado a
veces nos quita mucha flexibilidad, nos obliga a escribir código
excesivamente rígido y repetitivo. Y a veces nos imposibilita hacer
cosas que harían mucho más sencillo nuestro programa. Por ejemplo,
guardar instancias de distintos tipos en un array.

Los diseñadores de lenguajes de programación modernos como Swift se
han dado cuenta de que no es bueno ser excesivamente rígidos y han
ideado estrategias que flexibilizan el sistema de tipos. Por ejemplo,
el polimorfismo, la sobrecarga de funciones o los genéricos. Estas
estrategias, evidentemente, hacen que los lenguajes sean más
complicados (tanto en su aprendizaje como en el funcionamiento interno
de los compilador). Pero terminan siendo apreciadas por los
desarrolladores porque permiten que el código sea más expresivo y
sencillo.

Vamos a repasar en este artículo un ejemplo concreto de este
_trade-off_, esta búsqueda de la flexibilidad dentro de un lenguaje
fuertemente tipado. 


## Lenguajes débilmente tipados ##

En los lenguajes débilmente tipados como Python es muy fácil definir
un array con distintos tipos de datos: 

```python
miArray = [1, "hola", 3.0]
print(miArray)

# imprime: [1, 'hola', 3.0]
```

Esto imprime:

```text
[1, 'hola', 3.0]
```

Al ser Python débilmente tipeado, no tiene problemas en hacer cosas
como:


```python
print(miArray[0] + miArray[2])

# imprime: 4.0
```

Esto puede parecer una ventaja, hasta que nos damos cuenta de que el
compilador realmente no está comprobando nada y permite expresiones
como la siguiente, que van a dar un error en tiempo de ejecución
porque no se pueden sumar un entero y una cadena: 

```python
print(miArray[0] + miArray[1])

# error en tiempo de ejecución
```

Es el problema de los lenguajes débilmente tipados. El compilador no
puede detectar muchos errores y éstos se producen en tiempo de
ejecución.

¿Cuál es el enfoque de Swift, un lenguaje fuertemente tipado? ¿Hay
alguna forma de guardar instancias de distintos tipos en un array? La
respuesta es que sí, aunque con ciertas limitaciones. Vamos a verlo.

## Tipo especial Any

El tipo especial `Any` permite que la variable declarada sea de
cualquier tipo. Por ejemplo, podemos decir: 

```swift
var x: Any = 10
x = "Hola"
```

Aunque podría parecer que esto es equivalente al funcionamiento de
lenguajes débilmente tipados, el compilador de Swift sigue
funcionando. No podemos hacer casi nada con una variable `Any`. Por
ejemplo, el siguiente código da un error de compilación: 

```swift
let x: Any = 10
let y: Any = 5

print(x+y)

// Error: binary operator '+' cannot be applied to two 'Any' operands
```

Podríamos hacer la suma haciendo un
[downcasting](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html#ID341):  

```swift
let x: Any = 10
let y: Any = 5

print((x as! Int) + (y as! Int))

// Imprime: 15
```

El operador `as!` devuelve el valor con el tipo indicado. Si la
variable no es compatible con ese tipo se produce un error en tiempo
de ejecución. 

## Array de Anys

Entonces, una primera forma de permitir arrays con múltiples tipos es
usar el tipo especial  `Any`.

```swift

var miArray: [Any] = [1, "Hola", 3.0]
```

Este array es similar al array de Python. La ventaja es que, tal y
como hemos visto antes, el compilador de Swift no deja hacer lo de
operar con sus valores:

```swift
print(miArray[0] + miArray[1])

// error: binary operator '+' cannot be applied to two 'Any' operands
```

Sí que podemos usar el _downcasting_ para procesar los elementos del
array. Podemos usar un `switch` para determinar el tipo de elemento:

```swift
for thing in miArray {
    switch thing {
    case let algunInt as Int:
        print("Un entero con valor de \(algunInt)")
    case let algunDouble as Double: 
        print("Un double con valor de \(algunDouble)")
    case let algunString as String:
        print("Una cadena con valor de \"\(algunString)\"")
    default:
        print("Alguna otra cosa")
    }
}
```

Imprime:

```text
Un entero con valor de 1
Una cadena con valor de "Hola"
Un double con valor de 3.0
```

¿Cuál es el inconveniente? Precisamente el tener que hacer el
downcasting. Hace que el código sea más confuso y más propenso a
errores, al usar el operador `as!` que puede hacer que el programa se
rompa en tiempo de ejecución. 

## Arrays con enumerados con tipos asociados ##

Un problema de la solución anterior era que el tipo `Any` permite una
libertad excesiva y nos lleva a problemas similares a los de los
lenguajes débilmente tipados. El hecho de que en el array podamos
incluir _cualquier_ tipo nos puede dar problemas. 

¿Podríamos limitar los tipos a incluir en el array a unos
determinados? Supongamos, por ejemplo, que sólo necesito que en mi
array hayan enteros, cadenas y números reales. ¿Existe alguna
característica de Swift que permita esto?

Pues sí, una forma de hacerlo son los tipos enumerados. En Swift los
[tipos
enumerados](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)
son muy potentes. Es posible asociar tuplas de valores a instancias
concretas del tipo. Podemos, por ejemplo, definir un tipo que sea un
entero, una cadena o un número real y que tenga asociado a cada opción
del enumerado un valor de ese tipo:

```swift
enum Miscelanea {
    case entero(Int)
    case cadena(String)
    case real(Double)
}
```

Y podemos crear un array de instancia de ese tipo:

```swift
var miArray: [Miscelanea] = [.entero(1), .cadena("Hola"), .real(2.0)]
```

Para recorrer el array necesitaremos usar otra vez una instrucción
`switch`:

```swift
for thing in miArray {
    switch thing {
        case let .entero(algunInt): 
            print(algunInt)
        case let .cadena(algunaCadena):
            print(algunaCadena)
        case let .real(algunDouble): 
            print(algunDouble)
    }
}
```

Esto imprime lo mismo que antes:

```text
1
Hola
2.0
```

La ventaja ahora es que el código es totalmente seguro. En el array no
podemos añadir nada que no sea algo distinto del enumerado y el
lenguaje controla correctamente todas las posibles opciones que podemos
tener en el array.

Pero esta solución tiene algunos problemas. En primer lugar, resulta
excesivamente rígida. ¿Qué pasa si en el futuro queremos ampliar los
tipos incluidos en el array? Por ejemplo, añadir datos booleanos. No
podríamos hacerlo de forma _aditiva_, no podríamos extender las
funcionalidades del código añadiendo nuevos elementos. Tendríamos que
reescribir la clase `Miscelanea` para incluir en ella el nuevo tipo y
recompilar la aplicación.

El segundo problema importante es que esta solución no permite incluir
en el array instancias de estructuras o clases. Supongamos que estamos
diseñando una aplicación de figuras geométricas y queremos guardar una
colección con distintos tipos de figuras: rectángulos, cuadrados,
triángulos, etc. No podríamos hacerlo.

Esto nos lleva a la siguiente solución.

## Array de un tipo protocolo

Otra solución, más flexible, para guardar tipos distintos en un
array es usar un protocolo (o una super clase). 

En general, si queremos agrupar varios ítems en una colección es
porque todos ellos comparten alguna propiedad. Podemos especificar esa
propiedad en un protocolo y hacer que todos los tipos que guardamos en
el array se ajusten a ese protocolo.

En el caso del ejemplo del array de figuras geométricas deberíamos
buscar alguna propiedad que comparten todas estas figuras y definir un
protocolo `Figura` con esa propiedad o propiedades al que se ajusten
rectángulos, cuadrados, triángulos, etc.

Vamos a ver un ejemplo sencillo. Supongamos que todos los ítems que
guardamos en el array son ítems que tienen un nombre (un
`String`). Podemos definir un protocolo con esa propiedad:

```swift
protocol Nombrable {
    var nombre: String {get}
}
```

Podemos hacer que los tipos que añadamos al array cumplan esta
propiedad. Podríamos crear tipos nuevos para los datos que vamos a
incluir en el array, pero Swift nos permite extender tipos
existentes:

```swift
extension Int: Nombrable {
    var nombre: String {String(self)}
}

extension String: Nombrable {
    var nombre: String {self}
}

extension Double: Nombrable {
    var nombre: String {String(self)}
}
```

Con el código anterior estamos ampliando los tipos de Swift con la
propiedad `nombre` y haciendo que todos ellos se ajusten al protocolo
`Nombrable`.

Y ahora podemos crear el array de cosas nombrables:

```swift
var miArray: [Nombrable] = [1, "Hola", 2.0]

for thing in miArray {
    print(thing.nombre)
}
```

Esto imprime:

```text
1
Hola
2.0
```

Esta solución de usar un protocolo o una superclase para definir el
array es la más flexible y usada. Es más recomendable usar un
protocolo porque tanto estructuras como clases se pueden ajustar a
él. Si definimos una superclase sólo podríamos usarla en clases (en
Swift no se puede utilizar herencia en las estructuras).

A diferencia de los enumerados, si en el futuro queremos ampliar el
array a nuevos tipos, lo único que tendríamos que hacer es ajustar
esos nuevos tipos al protocolo sobre el que está definido el array.

Por ejemplo, podríamos incluir booleanos en nuestro array:

```swift
extension Bool: Nombrable {
    var nombre: String {
        self ? "true" : "false"
    }
}

var miArray: [Nombrable] = [1, "Hola", 2.0, false]

for thing in miArray {
    print(thing.nombre)
}
```

Esto imprime:

```
1
Hola
2.0
false
```


