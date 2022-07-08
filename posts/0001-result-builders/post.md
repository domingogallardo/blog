<!--
** Title: Result builders en Swift
** Date: 08/07/2022
** Tags: Swift, Lenguajes de programación
-->

# Result builders en Swift #

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
