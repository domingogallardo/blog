@resultBuilder
struct StringConcatenator {
    static func buildBlock(_ components: String...) -> String {
        return components.joined(separator: ", ")
    }

    static func buildArray(_ components: [String]) -> String {
        return components.joined(separator: "-")
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }
}

@StringConcatenator
func holaMundo() -> String {
    "Hola"
    "mundo"
    if Bool.random() {
        "cruel"
    } else {
        "divertido"
    }
    for i in (0...10) {
        "\(i)"
    }
}

func holaMundoTransformada() -> String {
    let v0 = "Hola"
    let v1 = "mundo"
    let v2 = Bool.random() ?
                StringConcatenator.buildEither(first: "cruel") :
                StringConcatenator.buildEither(second: "divertido")
    let v3 = StringConcatenator.buildBlock(v0, v1, v2)
    var v4: [String] = []
    for i in (0...10) {
        let vi = "\(i)"
        v4.append(vi)
    }
    let v5 = StringConcatenator.buildArray(v4)
    return StringConcatenator.buildBlock(v3, v5)
}

print(holaMundo())
print(holaMundoTransformada())