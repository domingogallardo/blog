<!--
** Title: Arrays con distintos tipos de datos en Swift
** Date: 21/07/2022
** Tags: Swift, Lenguajes de programación
-->

# Arrays con distintos tipos de datos en Swift

Investigando sobre SwiftUI y usándolo para entender mejor Swift una de
las primeras cosas que llaman la atención es la palabra reservada
`some`:

```swift
struct LandmarkRow: View {
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
        }
    }
}
```

¿Qué significa en el código anterior que la variable `body` contiene
_alguna_ vista?

No sé si a vosotros os pasa, pero cuando intento entender algo nuevo
siempre tengo la sensación de que estoy siguiendo las pistas de un
caso por resolver, como si fuera una especie de Sherlock Holmes o
Hercules Poirot. Una pregunta me lleva a otra y esta a otra, y así
hasta que al final termino desenredando el ovillo (o parte de él) y
conectando todos los conceptos nuevos que voy encontrando con los que
ya conozco. Y después, cuando explicas algo, toca hacer el camino en
orden inverso. Partir de lo que ya conoces y, a partir de ahí,
construir y contar lo nuevo.

En nuestro caso, el camino para entender `some` va a empezar con una
pregunta curiosa: en un lenguaje fuertemente tipado como Swift ¿es
posible definir un array con datos de distintos tipos?

En principio parece contradictorio. Si hay que especificar de forma
estricta el tipo del array, debemos especificar el tipo de sus
componentes:

```swift
var miArray: [Int] = []
```

El tipo del array anterior es `[Int]`. O sea que todos sus elementos
deben ser de tipo `Int`. Podríamos definir otros arrays distintos, con
objetos de tipo `String` o de tipo `Double`. Pero en cada caso los
arrays serían homogéneos y todos sus elementos tendrían el mismo tipo.

¿Es siempre así en Swift? Parece demasiado rígido. Podría ser que para
resolver un determinado problema la solución más sencilla pasara por
guardar en un único array tanto números enteros como cadenas y números
reales.

Si estuviéramos diseñando un nuevo lenguaje podríamos estar tentados a
definir algo como:

```swift
var arrayMisc: [Int | String | Double] = [1, "Hola", 2.0, 3.0, 2]
```

O sea, que el `arrayMisc` fuera heterogéneo y pudiera contener elementos
`Int` o `String` o `Double`. 

Parece interesante poder expresar algo así. Pero no debe ser una buena
idea porque no conozco ningún lenguaje que tenga una construcción de
este tipo. Por ejemplo, tendríamos el problema de cómo tratar los
elementos del array. ¿Qué pasa cuando hacemos un bucle y recorremos
sus elementos?:

```swift
for thing in arrayMisc {
   // procesar el elemento del array
}
```

¿De qué tipo sería la variable `thing`? Podría ser un `Int`, un
`String` o un `Double`, dependiendo del elemento del array que
estuviera instanciando. Tendríamos que introducir alguna construcción
en el lenguaje para permitir trabajar con los elementos del array
heterogéneo.

Por suerte no estamos diseñando un lenguaje nuevo, sino que estamos
estudiando Swift. Vamos a ver que se trata de un lenguaje moderno y
flexible que proporciona algunas estrategias que permiten, hasta
ciertos límites, agrupar datos variados en un mismo array.

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
cosas que harían mucho más sencillo nuestro programa. Por ejemplo, la
idea que estamos explorando de guardar instancias de distintos tipos
en un array.

Los diseñadores de lenguajes de programación modernos como Swift se
han dado cuenta de que no es bueno ser excesivamente rígidos y han
ideado estrategias que flexibilizan el sistema de tipos. Por ejemplo,
el polimorfismo, la sobrecarga de funciones o los genéricos. Estas
estrategias, evidentemente, hacen que los lenguajes sean más
complicados (tanto en su aprendizaje como en el funcionamiento interno
de los compilador). Pero terminan siendo apreciadas por los
desarrolladores porque permiten que el código sea más expresivo y
sencillo.

Podemos ver el problema que estamos tratando en este artículo como un
ejemplo concreto de este _trade-off_, de esta búsqueda de la
flexibilidad dentro de un lenguaje fuertemente tipado.

Vamos ya a explicar las distintas formas que proporciona Swift para
resolver la pregunta principal que nos estamos planteando.

## Tipo especial Any

El [tipo especial
`Any`](https://docs.swift.org/swift-book/ReferenceManual/Types.html#ID629)
permite que una variable sea de cualquier tipo. Por ejemplo,
podemos declarar una variable con un entero y después asignarle una cadena:

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

## Arrays de Anys

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

Parece que ya tenemos una estrategia que resuelve nuestro
problema. ¿Cuál es su inconveniente? Precisamente el tener que hacer
el _downcasting_ y su excesiva libertad. El _downcasting_ hace que el
código sea algo más confuso. Y el poder guardar cualquier cosa en el
array hace el código más propenso a errores. Los desarrolladores
pueden verse tentados a usar el operador `as!` y hacer el código menos
robusto y más propenso a romperse en tiempo de ejecución.

## Arrays con enumerados con tipos asociados ##

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

Y podemos crear un array de instancias de ese tipo:

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

Pero esta solución tiene también algunos problemas. En primer lugar, resulta
excesivamente rígida. ¿Qué pasa si en el futuro queremos ampliar los
tipos incluidos en el array? Por ejemplo, añadir datos booleanos. No
podríamos hacerlo de forma _aditiva_, no podríamos extender las
funcionalidades del código añadiendo nuevos elementos. Tendríamos que
reescribir la clase `Miscelanea` para incluir en ella el nuevo tipo y
recompilar la aplicación.

El segundo problema es que esta solución no permite incluir
en el array instancias de estructuras o clases. Supongamos que estamos
diseñando una aplicación de figuras geométricas y queremos guardar una
colección con distintos tipos de figuras: rectángulos, cuadrados,
triángulos, etc. No podríamos hacerlo.

Esto nos lleva a la siguiente solución.

## Arrays de un tipo protocolo

Otra solución, más flexible, para guardar tipos distintos en un array
es usar un
[protocolo](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)
(o una super clase).

En general, si queremos agrupar varios ítems en una colección es
porque todos ellos comparten alguna propiedad. Podemos especificar esa
propiedad en un protocolo y hacer que todos los tipos que guardamos en
el array se ajusten a ese protocolo.

En el caso del ejemplo del array de figuras geométricas deberíamos
buscar alguna propiedad que comparten todas estas figuras y definir un
protocolo `Figura` con esa propiedad o propiedades. Los tipos
concretos `Rectango`, `Cuadrado`, `Triangulo`, etc. deberían entonces
ajustarse al protocolo `Figura`. Y ya podríamos declarar un array de
`Figura`s.

Vamos a ver un ejemplo sencillo. Supongamos que todos los ítems que
guardamos en el array son ítems que tienen un nombre (un
`String`). Podemos definir un protocolo con esa propiedad:

```swift
protocol Nombrable {
    var nombre: String {get}
}
```

Una vez creado este protocolo, podemos hacer que los tipos que
añadamos al array cumplan esta propiedad. 

En lugar de crear tipos nuevos para el ejemplo, Swift nos permite
extender tipos existentes `Int`, `String` y `Double` con la propiedad
`nombre` y hacer que se ajusten al protocolo `Nombrable`:

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

Y ahora podemos crear el array de cosas nombrables y añadir en él
instancias de los tipos anteriores:

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

## El problema de los genéricos

La solución anterior de definir un protocolo para los componentes del
array parece la solución perfecta. Permite flexibilidad y
extensibilidad. Aunque no lo hemos visto en el ejemplo, permite
también usar el _downcasting_ y obtener instancias del tipo concreto
del dato usando una sentencia _switch_. 

Pero hay un aspecto que no hemos contemplado. Una de las
características más importantes de Swift es su apuesta por los [tipos
genéricos](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#). Desde
el comienzo del lenguaje se hizo una hoja de ruta, en forma de
[manifiesto](https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md),
que se ha ido implementando en cada nueva versión del lenguaje.  

En el caso de los protocolos, podemos hacer genérico algún elemento
del protocolo usando un [_associated
type_](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID189). De
hecho, en SwiftUi una vista es un protocolo genérico que tiene un tipo
asociado (consultar la referencia al protocolo `View` en la
[documentación de
Apple](https://developer.apple.com/documentation/swiftui/view)).

¿Qué sucede entonces si como tipo del array usamos un protocolo
genérico, un protocolo que tiene un _associated type_? ¿Qué sucede si
creamos un array de vistas de SwiftUI? Pues resulta que todo se hace
un poco más complicado y el compilador da un error. 

```swift
var array: [View] = []

// Error: Protocol 'View' can only be used as a generic constraint 
// because it has Self or associated type requirements
```

¿Qué está pasando? Mejor lo dejamos para otro post, que este ya se ha
hecho muy largo.

## Referencias ##

- [Arrays en Language
  Guide](https://docs.swift.org/swift-book/LanguageGuide/CollectionTypes.html#ID107)
- [Tipo Any en Language
  Reference](https://docs.swift.org/swift-book/ReferenceManual/Types.html#ID629)
- [Downcasting en Language
  Guide](https://docs.swift.org/swift-book/LanguageGuide/TypeCasting.html#ID341)
- [Tipos
enumerados en Language
Guide](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)
- [Protocolos en Language Guide](https://docs.swift.org/swift-book/LanguageGuide/Protocols.html)
- [Tipos
genéricos en Language
Guide](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#)
- [Generic
  manifiesto](https://github.com/apple/swift/blob/main/docs/GenericsManifesto.md)
- [Asociated type en Language Guide](https://docs.swift.org/swift-book/LanguageGuide/Generics.html#ID189)
- [Fichero de código con los ejemplos del post](code/array-multiples-tipos.swift)
