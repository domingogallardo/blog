
let x: Any = 10
let y: Any = 5

print((x as! Int) + (y as! Int))

// Imprime: 15

var miArray1: [Any] = [1, "Hola", 3.0]

// print(miArray[0] + miArray[1])

for thing in miArray1 {
    switch thing {
    case let algunInt as Int:
        print("Un entero con valor de \(algunInt)")
    case let algunDouble as Double: 
        print("Un double con valor de \(algunDouble)")
    case let algunString as String:
        print("Una cadena con valor de \"\(algunString)\"")
    default:
        print("Alguna otra cosa")
    }
}

protocol Nombrable {
    var nombre: String {get}
}

extension Int: Nombrable {
    var nombre: String {
        String(self)
    }
}

extension String: Nombrable {
    var nombre: String {
        self
    }
}

extension Double: Nombrable {
    var nombre: String {
        String(self)
    }
}

var miArray2: [Nombrable] = [1, "Hola", 2.0]

for thing in miArray2 {
    print(thing.nombre)
}

enum Miscelanea {
    case entero(Int)
    case cadena(String)
    case real(Double)
}

var miArray3: [Miscelanea] = [.entero(1), .cadena("Hola"), .real(2.0)]

for thing in miArray3 {
    switch thing {
        case let .entero(algunInt): 
            print(algunInt)
        case let .cadena(algunaCadena):
            print(algunaCadena)
        case let .real(algunDouble): 
            print(algunDouble)
    }
}

extension Bool: Nombrable {
    var nombre: String {
        self ? "true" : "false"
    }
}

var miArray: [Nombrable] = [1, "Hola", 2.0, false]

for thing in miArray {
    print(thing.nombre)
}