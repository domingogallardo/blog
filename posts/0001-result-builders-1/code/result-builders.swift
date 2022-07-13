
@resultBuilder
struct StringConcatenator {
/*
    static func buildBlock(_ component1: String, _ component2: String) -> String {
        return component1 + ", " + component2
    }
*/
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ", ")
    }
}

@StringConcatenator
func holaMundo() -> String {
    "Hola"
    "mundo"
}

func holaMundoTransformada() -> String {
    let v0 = "Hola"
    let v1 = "mundo"
    return StringConcatenator.buildBlock(v0, v1)
}

print(holaMundo()) // Imprime: Hola, mundo
print(holaMundoTransformada()) // Imprime: Hola, mundo

@StringConcatenator
func saludo(nombre: String) -> String {
    "Hola"
    "me"
    "llamo"
    nombre
}

func saludoTransformada(nombre: String) -> String {
    let v0 = "Hola"
    let v1 = "me"
    let v2 = "llamo"
    let v3 = nombre
    return StringConcatenator.buildBlock(v0, v1, v2, v3)
}

print(saludoTransformada(nombre: "Frodo")) // Imprime: Hola, me, llamo, Frodo

struct Persona {
    let nombre: String

    @StringConcatenator
    var saludo: String {
        "Hola"
        "me"
        "llamo"
        nombre
    }
}

let frodo = Persona(nombre: "Frodo")
print(frodo.saludo) // Imprime: Hola, me, llamo, Frodo

func imprimeSaludo(@StringConcatenator _ contenido: () -> String) {
    print(contenido())
}

imprimeSaludo {
    "Hola"
    "mundo"
}
// Imprime: Hola, mundo

func imprimeSaludoTransformado(_ contenido: () -> String) {
    print(contenido())
}

imprimeSaludoTransformado({
    let v0 = "Hola"
    let v1 = "mundo"
    return StringConcatenator.buildBlock(v0, v1)
})
// Imprime: Hola, mundo

