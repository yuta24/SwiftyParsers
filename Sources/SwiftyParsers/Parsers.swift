import Foundation

public func satisfyRange(_ a: Character, _ z: Character) -> Parser<Character> {
    return satisfy({
        return a <= $0 && $0 <= z
    })
}

public func notChar(_ c: Character) -> Parser<Character> {
    return satisfy({
        return c != $0
    })
}

public func any() -> Parser<Character> {
    return satisfy({ _ in
        return true
    })
}

public func octDigit() -> Parser<Character> {
    return satisfy(isOctDigit(_:))
}

public func hexDigit() -> Parser<Character> {
    return satisfy(isHexDigit(_:))
}

public func tab() -> Parser<Character> {
    return satisfy(isChar("\t"))
}

public func newline() -> Parser<Character> {
    return satisfy(isChar("\n"))
}

public func space() -> Parser<Character> {
    return satisfy(isChar(" "))
}
