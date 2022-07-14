<!--
** Title: Result builders en Swift (2)
** Date: 
** Tags: Swift, Lenguajes de programación
-->

# Result builders en Swift (2) #

En el [post anterior](../posts/0001-resultbuilders-1.md) de la serie
sobre _result builders_ vimos cómo éstos permiten utilizar un DSL para
definir una clausura o un bloque de código que construye un componente
a partir de componentes elementales.

Vimos el ejemplo sencillo de un constructor de cadenas:

```swift
@resultBuilder
struct StringConcatenator {
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ", ")
    }
}
```

El código anterior crea la anotación `@StringConcatenator` que podemos usar
para aplicar el _result builder_. Por ejemplo, podemos aplicarlo a la
definición de una función:

```swift
@StringConcatenator
func holaMundo() -> String {
    "Hola"
    "mundo"
}

print(holaMundo())
// Imprime: Hola, mundo
```

La función anterior construye una cadena uniendo las cadenas
elementales que definimos en su cuerpo. Recordemos que el _result
builder_ transforma en tiempo de compilación este cuerpo,
convirtiéndolo en algo como:

```swift
func holaMundo() -> String {
    let v0 = "Hola"
    let v1 = "mundo"
    return StringConcatenator.buildBlock(v0, v1)
}
```

Por último, terminamos explicando que si anotábamos con el atributo un
parámetro de una función, el _result builder_ se aplicaba a la clausura
que se pasaba como parámetro. Algo interesante porque permite usar el
_result builder_ sin que aparezca la anotación:

```swift
func imprimeSaludo(@StringConcatenator _ contenido: () -> String) {
    print(contenido())
}

// Llamamos a la función con una clausura que usa el DSL.
// No es necesario añadir la anotación @StringConcatenator.
imprimeSaludo {
    "Hola"
    "mundo"
}
// Imprime: Hola, mundo
```

En este segundo post a ver otros lugares en los que se puede usar el
atributo del _result builder_ y vamos a conocer más cosas sobre su
construcción, estudiando otros elementos que puede contener.

## Result builders en inicializadores ##


```swift
let vista = 
    HStack {
        ForEach(
            1...5,
            id: \.self
        ){
            Text("Item \($0)")
        }
    }
```

<img src="imagenes/hstack.png" width="300px"/>


```swift
struct Persona {
    let contenido: () -> String

    var saludo: String {
        contenido()
    }

    init(@StringConcatenator contenido: @escaping () -> String) {
        self.contenido = contenido
    }
}

let frodo = Persona {
    "Hola"
    "me"
    "llamo"
    "Frodo"
}

print(frodo.saludo)
```

```swift
struct PersonaSimple {
    @StringConcatenator let contenido: () -> String

    var saludo: String {
        contenido()
    }
}

let frodo2 = PersonaSimple {
    "Hola"
    "me"
    "llamo"
    "Frodo"
}

print(frodo2.saludo)
```



## Result builders en protocolos ##

```swift
protocol Educado {
    @StringConcatenator var saludo: String {get}
}

struct PersonaEducada: Educado {
    var nombre: String
    var saludo: String {
        "Hola"
        "me"
        "llamo"
        nombre
    }
}

let gandalf = PersonaEducada(nombre: "Gandalf")

print(gandalf.saludo)
```



## Expresiones, componentes y resultados finales ##

```swift
@resultBuilder
struct ArrayBuilder {
    static func buildExpression(_ expression: Int) -> [Int] {
        return [expression]
    }

    static func buildBlock(_ components: [Int]...) -> [Int] {
        return Array(components.joined())
    }

    static func buildFinalResult(_ component: [Int]) -> [Double] {
        component.map {Double($0)}
    }
}

@ArrayBuilder
func buildArray() -> [Double] {
    100
    200
    300
}

print(buildArray())
```

## Referencias ##
