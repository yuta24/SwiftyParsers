
func separete(_ xs: String) -> (Character, String)? {
    if let f = xs.first {
        return (f, String(xs.suffix(from: xs.index(after: xs.startIndex))))
    } else {
        return nil
    }
}

func isDigit(_ c: Character) -> Bool {
    return ("0"..."9").contains(c)
}

func isLower(_ c: Character) -> Bool {
    return ("a"..."z").contains(c)
}

func isUpper(_ c: Character) -> Bool {
    return ("A"..."Z").contains(c)
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
