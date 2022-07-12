<!--
** Title: Result builders en Swift
** Date: 
** Tags: Swift, Lenguajes de programación
-->

# Result builders en Swift (1) #

Desde que Apple presentó
[_SwiftUI_](https://developer.apple.com/documentation/swiftui/) en la
[WWDC19](https://developer.apple.com/wwdc19/204) he querido entender
las funcionalidades de Swift sobre las que se construye esta tecnología. Leí [algún que otro
post](https://www.swiftbysundell.com/articles/the-swift-51-features-that-power-swiftuis-api/)
que entraba en el tema y me quedé con la idea de que en Swift 5.1
habían introducido algo llamado _function builders_ que era la
funcionalidad  que permitía construir las vistas de SwiftUI de forma
declarativa, pero no seguí estudiando más el tema.

Una cosa extraña de los _function builders_ era que se trataba de una
funcionalidad no documentada de Swift, que no había pasado por el
proceso habitual de [evolución del
lenguaje](https://github.com/apple/swift-evolution) en el que las
propuestas de nuevas características se terminan aprobando o no tras
una discusión abierta con la comunidad.

No tardó mucho en aparecer [una
propuesta](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md)
y [un _pitch_](https://forums.swift.org/t/function-builders/25167) en
los foros de la comunidad. Las discusiones se alargaron, se
consideraron distintas alternativas, cambió de nombre a _result
builders_ y al final, casi dos años después, terminó siendo
[aceptada](https://forums.swift.org/t/accepted-se-0289-result-builders/41377)
en octubre de 2020 y publicada en el lenguaje en la [versión
5.4](https://www.swift.org/blog/swift-5.4-released/) lanzada en abril
de 2021.

Más de un año después me he puesto realmente a estudiar los _result
builders_ y a intentar entender cómo funcionan. Después de pasar unos
días leyendo documentación, creando algunas notas en Obsidian y
haciendo pruebas con código Swift ha llegado el momento de intentar
poner en orden todo y hacer un post sobre el tema. Como se suele
decir, la mejor forma de aprender algo es tratando de explicarlo.

## Objetivo de los _result builders_ ##

Vamos a empezar explicando cuál es el objetivo de los _result
builders_ y después explicaremos cómo funciona.

### Un ejemplo con SwiftUI ###

Si vemos un ejemplo sencillo de código SwiftUI comprobaremos que
podemos identificarlo como código Swift, pero que hay algo que no
encaja del todo. Por ejemplo, el siguiente
código construye una vista en la que se apilan verticalmente una
imagen y un texto.

```swift
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}
```

El resultado es el siguiente:

<img src="imagenes/hello-world-swiftui.png" width="200px"/>

En el código hay cosas avanzadas de Swift, que igual comento en algún
otro post, como el uso de `some` o la forma de definir clausuras al
final, como último parámetro, usando solo las llaves. 

Pero fijémonos en la construcción del `VStack`:

```swift
VStack {
    Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
    Text("Hello, world!")
}
```

Las llaves después de `VStack` definen una clausura que se le pasa al
incializador. Si miramos en ella veremos que hay algo raro: hay dos
sentencias que construyen una instancia de `Image` y otra instancia de
`Text`. Son precisamente la imagen y el texto que se apilan y que se
muestran en la vista resultante. ¿Cómo se pasan las instancias de
`Image` y `Text` al `Vstack`? ¿Dónde está el return de la
clausura?. ¿Qué magia es esta?

La explicación está en el _result builder_. Esta funcionalidad realiza
una transformación en tiempo de compilación del código anterior (que
no es código Swift correcto) en un código similar al siguiente:

```swift
VStack {
    let v0 = Image(systemName: "globe")
                 .imageScale(.large)
                 .foregroundColor(.accentColor)
    let v1 = Text("Hello, world!")
    return ViewBuilder.buildBlock(v0, v1)
}
```

Este código sí que es código correcto de Swift. Las instancias creadas
de `Image` y de `Text` se guardan en dos variables auxiliares y se
llama a una función estática (`ViewBuilder.buildBlock`) que recibe
estas dos vistas y las combina en una estructura que se devuelve.


### Creación de DSLs ###

Mediante el _result builder_ anterior podemos entonces transformar el
código limpio y claro del principio (que no funciona en Swift) en un
código compilable. El _result builder_ añade todo lo necesario
(variables temporales, llamada a la función de construcción, etc.)
para que el código resultante sea correcto para el compilador. Y lo
hace de forma totalmente transparente. El desarrollador no ve nada del
segundo código, sólo ve el primero, el código limpio y claro.

El código que transforma el _result builder_ es lo que se denomina un
DSL (_Domain Specific Language_). En este caso, el DSL nos permite
construir vistas de _SwiftUI_, describiendo y combinando sus elementos
constituyentes.

Aunque no lo hemos visto en el ejemplo, también es posible construir
los elementos constituyentes de forma recursiva usando el mismo
DSL. Por ejemplo, uno de los elementos que se pasan al `VStack` podría
ser a su vez otro `VStack` en el que se hubieran combinado otros
elementos básicos.

Los _result builders_ no solo se han utilizado para construir SwiftUI,
sino que la comunidad ha creado una gran [lista nde
DSLs](https://github.com/carson-katri/awesome-result-builders) para
definir todo tipo de elementos, como HTML, CSS, grafos, funciones
REST o tests. Incluso en la reciente WWDC22 se ha presentado un DSL
para construir expresiones regulares en Swift,
[SwiftRegex](https://developer.apple.com/wwdc22/110357).

Resumiendo, al igual que las macros en lenguajes de programación como
LISP, o los `define` de C, los _result builders_ permiten especificar
unas transformaciones que se aplicarán al código fuente en tiempo de
compilación. Veremos a continuación cómo se ha incluido esa
funcionalidad en el lenguaje Swift.


## Primer ejemplo ##

Vamos a definir un _result builder_ que 

En primer lugar, para definir un _result builder_ debemos especificar
una función `buildBlock`. Esta función es la que encarga de construir
un resultado a partir de unos elementos. En el caso del ejemplo
anterior se debe construir una composición de dos vistas a partir de
las vistas individuales (la instancia de `Image` y de `Text`).

¿Cómo podemos definir esta función? La forma más sencilla es definir
una función estática, a la que se pueda llamar sin necesidad de crear
una instancia. Esta función se debe llamar `buildBlock` y debe tomar
como parámetros los componentes individuales y devolver un nuevo
componente resultado de su composición. Podemos definirla en una
estructura, una clase o un enumerado anotado con el atributo
`@resultBuilder`.

Un ejemplo muy sencillo es el siguiente:

```swift
@resultBuilder
struct StringConcatenator {
    static func buildBlock(_ component1: String, _ component2: String) -> String {
        return component1 + ", " + component2
    }
}
```

La función `buildBlock` toma dos cadenas y devuelve su concatenación,
separándolas por una coma. La definimos como una función `static` de la
estructura `StringConcatenator`. El atributo `@resultBuilder` indica
que este tipo es un _result builder_ y que vamos a poder especificar
un DSL con él.

¿Cómo podemos ahora indicar que queremos usar este _result builder_?
A los ingenieros de Swift se les ocurrió una idea genial. Al definir
el tipo `StringConcatenator` como un _result builder_ el compilador
crea el atributo `@StringConcatenator` que podremos usar donde nos
interese aplicarlo.

Por ejemplo, podemos escribir el siguiente código:

```
@StringConcatenator
func holaMundo() -> String {
    "Hola"
    "mundo"
}

print(holaMundo())
```

Estamos definiendo una función cuyo cuerpo va a ser transformado por
el _result builder_ `StringConcatenator` en tiempo de compilación. En
la transformación se va a llamar a la función constructora del _result
builder_ pasando como argumentos los componentes `"Hola"` y
`"mundo"`. Y la función constructora devolverá la composición de ambas
cadenas, que se será lo que devuelva la función `holaMundo()`.

De esta forma, el código anterior imprimirá:

```text
Hola, mundo
```

¿Qué está haciendo internamente el compilador? Al encontrar el
atributo `@StringConcatenator` en la declaración de la función el
compilador entiende que el cuerpo de la función es un DSL que debe
transformar. El código resultante es el siguiente:

```swift
func holaMundo() -> String {
    let v0 = "Hola"
    let v1 = "mundo"
    return StringConcatenator.buildBlock(v0, v1)
}
```

Cada sentencia del cuerpo de la función a transformar especifica un
componente que el compilador debe procesar. En este caso lo único que
hace es asignar esos componentes a variables auxiliares. Y al final
del código se debe terminar llamando a `buildBlock` para combinar esos
componentes. 
