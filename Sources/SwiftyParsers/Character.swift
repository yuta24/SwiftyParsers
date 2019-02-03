import Foundation

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
