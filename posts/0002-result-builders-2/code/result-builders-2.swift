
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
}

let frodo2 = PersonaSimple {

}

struct PersonaEager {
    @StringConcatenator let contenido: String

    var saludo: String {
        contenido
    }
}

let gandalf = Persona {
    "Hola"
    "me"
    "llamo"
    "Gandalf"
}

print(gandalf.saludo)
