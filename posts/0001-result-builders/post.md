<!--
** Title: Result builders en Swift
** Date: 
** Tags: Swift, Lenguajes de programación
-->

# Result builders en Swift #

Desde que Apple presentó
[_SwiftUI_](https://developer.apple.com/documentation/swiftui/) en la
[WWDC19](https://developer.apple.com/wwdc19/204) he querido entender las funcionalidades de Swift en las que se
basaba esta tecnología. Leí [algún que otro
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
5.4](https://www.swift.org/blog/swift-5.4-released/) lanzado en abril
de 2021.

Más de un año después me he puesto realmente a estudiar los _result
builders_ y a intentar entender cómo funcionan. Después de pasar unos
días leyendo documentación, creando algunas notas en Obsidian y
probando código ha llegado el momento de intentar poner en orden todo
y hacer un post sobre el tema. Como se suele decir, la
mejor forma de aprender algo es tratando de explicarlo.

## Objetivo de los result builders ##

Si vemos un ejemplo sencillo de código en SwiftUI veremos algo que
podemos identificar como código Swift. Por ejemplo, el siguiente
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

El resultado es la siguiente imagen:

<img src="imagenes/hello-world-swiftui.png" width="200px"/>


Los _result builders_ son una de las construcciones más avanzadas y
difíciles de entender de Swift. Pero también son una de sus
características más interesantes, ya que son la base de la
implementación de
[_SwiftUI_](https://developer.apple.com/documentation/swiftui/) o de una
enorme [lista de
DSLs](https://github.com/carson-katri/awesome-result-builders)
(_Domain Specific Languages_).

Al igual que las macros en lenguajes de programación como LISP, o los
`define` de C, los _result builders_ permiten especificar unas
transformaciones que se aplicarán al código fuente en tiempo de
compilación. El código fuente original será código muy expresivo y
sencillo de leer y, en el proceso de compilación, será procesado por
el _result builder_ y transformado internamente a código Swift.

En este post voy a intentar explicar de una forma sencilla el
funcionamiento básico de un _result builder_. No voy a ser exhaustivo,
ni intentar cubrir todos los aspectos de su funcionamiento. Pero sí
proporcionar las ideas claves que te sirvan para construir un modelo
mental de su funcionamiento. Con este modelo mental podrás enfrentarte
sin problemas a los aspectos más avanzados de la funcionalidad.

## Historia ##

La idea de los _result builders_ se introduce en 2019 en Swift 5.1
para dar soporte a _SwiftUI_, el _framework_ de definición de
interfaces de usuario presentado por Apple en la WWDC19. 

En esa fecha se utilizan los _result builders_ como una característica
interna del compilador, no documentada, y se lanza a la comunidad la
propuesta [0289 Result
builders](https://github.com/apple/swift-evolution/blob/main/proposals/0289-result-builders.md)
(originalmente denominada _function builders_) para su
discusión. Después de mucha discusión en los foros de la comunidad, la
propuesta es aceptada dos años después, en 2021, cuando se termina de
especificar de forma completa el funcionamiento de la anotación
`@resultBuilder`.


## Primer ejemplo ##

```swift
@resultBuilder
struct ArrayBuilder {
    static func buildBlock(_ components: Int...) -> [Int] {
        return components
    }
}
```
