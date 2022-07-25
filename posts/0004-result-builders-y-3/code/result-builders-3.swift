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
    var v3: String? = nil
    if Bool.random() {
        let v3a = "cruel"
        v3 =  StringConcatenator.buildEither(first: v3a)
    } else {
        let v3b = "divertido"
        v3 = StringConcatenator.buildEither(second: v3b)
    }
    let v4 = StringConcatenator.buildBlock(v0, v1, v3!)
    var v5: [String] = []
    for i in (0...10) {
        let vi = "\(i)"
        v5.append(vi)
    }
    let v6 = StringConcatenator.buildArray(v5)
    return StringConcatenator.buildBlock(v4, v6)
}

print(holaMundo())
print(holaMundoTransformada())

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

    static func buildArray(_ components: [[Int]]) -> [Int] {
        return Array(components.joined())
    }
}

@ArrayBuilder
func buildArray() -> [Double] {
    100
    100+100
    (100+100)*2
    for i in (1...3) {
        i
    }
}

print(buildArray())