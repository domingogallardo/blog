
@resultBuilder
struct StringConcatenator {
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ", ")
    }
}

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
// Imprime: Hola, me, llamo, Frodo

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
// Imprime: Hola, me, llamo, Frodo


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
// Imprime: Hola, me, llamo, Gandalf

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
    100+100
    (100+100)*2
}

print(buildArray())
// Imprime [100.0, 200.0, 400.0]