import Foundation

public func satisfy(_ p: @escaping (Character) -> Bool) -> Parser<Character> {
    return item() >>- ({ (x) -> Parser<Character> in
        return p(x) ? pure(x) : zero()
    })
}

public func char(_ x: Character) -> Parser<Character> {
    return satisfy({ x == $0 })
}

public func not(_ c: Character) -> Parser<Character> {
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
    if let (x, xs) = separate(str) {
        return char(x) >>- ({ _ in
            string(xs) >>- ({ _ in
                return pure(str)
            })
        })
    } else {
        return pure("")
    }
}

public func satisfyRange(_ a: Character, _ z: Character) -> Parser<Character> {
    return satisfy({
        return a <= $0 && $0 <= z
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

public func digit() -> Parser<Character> {
    return satisfy(isDigit)
}

public func lower() -> Parser<Character> {
    return satisfy(isLower)
}

public func upper() -> Parser<Character> {
    return satisfy(isUpper)
}

public func letter() -> Parser<Character> {
    return lower() <|> upper()
}

public func alphanum() -> Parser<Character> {
    return letter() <|> digit()
}

public func word() -> Parser<String> {
    let r = letter() >>- ({ (x) in
        word() >>- ({ (xs) in
            return pure(String(x) + xs)
        })
    })
    return r <|> pure("")
}

public func ident() -> Parser<String> {
    return lower() >>- ({ (x) in
        many(alphanum()) >>- ({ (xs) in
            return pure(String(x) + String(xs))
        })
    })
}

public func nat() -> Parser<Int> {
    return many1(digit()) >>- ({ (xs) in
        if let r = Int(String(xs)) {
            return pure(r)
        } else {
            return zero()
        }
    })
}

public func int() -> Parser<Int> {
    let r = char("-") >>- ({ _ in
        nat() >>- ({ n in
            return pure(-n)
        })
    })
    return r <|> nat()
}

public func ints() -> Parser<[Int]> {
    return char("[") >>- ({ _ in
        int() >>- ({ n in
            many(char(",") >>- ({ _ in
                return int()
            })) >>- ({ ns in
                char("]") >>- ({ _ in
                    return pure([n] + ns)
                })
            })
        })
    })
}

public func number() -> Parser<Int> {
    return nat() <|> pure(0)
}

public func spaces() -> Parser<()> {
    return many1(satisfy({
        return $0 == " " || $0 == "\n" || $0 == "\t"
    })) >>- ({ _ in pure(()) })
}
