
@resultBuilder
struct StringConcatenator {
    static func buildBlock(_ component1: String, _ component2: String) -> String {
        return component1 + ", " + component2
    }
/*
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ", ")
    }
*/
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

print(holaMundo())
print(holaMundoTransformada())

