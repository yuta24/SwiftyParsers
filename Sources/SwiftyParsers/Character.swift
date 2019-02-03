
func separete(_ xs: String) -> (Character, String)? {
    if let f = xs.first {
        return (f, String(xs.suffix(from: xs.index(after: xs.startIndex))))
    } else {
        return nil
    }
}

func isOctDigit(_ c: Character) -> Bool {
    return ("0"..."7").contains(c)
}

func isHexDigit(_ c: Character) -> Bool {
    return ("a"..."f").contains(c) || ("A"..."F").contains(c)
}

func isDigit(_ c: Character) -> Bool {
    return ("0"..."9").contains(c)
}

func isAlpha(_ c: Character) -> Bool {
    return isLower(c) || isUpper(c)
}

func isAlphaNum(_ c: Character) -> Bool {
    return isAlpha(c) || isDigit(c)
}

func isLower(_ c: Character) -> Bool {
    return ("a"..."z").contains(c)
}

func isUpper(_ c: Character) -> Bool {
    return ("A"..."Z").contains(c)
}

func isChar(_ c: Character) -> (Character) -> Bool {
    return {
        return c == $0
    }
}

public func satisfy(_ condition: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser(parse: { (xs) -> (Character, String)? in
        if let result = separete(xs), condition(result.0) {
            return result
        } else {
            return nil
        }
    })
}

public func satisfyRange(_ a: Character, _ z: Character) -> Parser<Character> {
    return satisfy({
        return a <= $0 && $0 <= z
    })
}

public func char(_ c: Character) -> Parser<Character> {
    return satisfy({
        return c == $0
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

public func string(_ str: String) -> Parser<String> {
    return Parser<String>(parse: { (target) -> (String, String)? in
        if target.hasPrefix(str) {
            let remain = target.suffix(from: target.index(target.startIndex, offsetBy: str.count))
            return (str, String(remain))
        } else {
            return nil
        }
    })
}

public func octDigit() -> Parser<Character> {
    return satisfy(isOctDigit(_:))
}

public func hexDigit() -> Parser<Character> {
    return satisfy(isHexDigit(_:))
}

public func digit() -> Parser<Character> {
    return satisfy(isDigit(_:))
}

public func letter() -> Parser<Character> {
    return satisfy(isAlpha(_:))
}

public func alphaNum() -> Parser<Character> {
    return satisfy(isAlphaNum(_:))
}

public func lower() -> Parser<Character> {
    return satisfy(isLower(_:))
}

public func upper() -> Parser<Character> {
    return satisfy(isUpper(_:))
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
