import Foundation

public func seq<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<(A, B)> {
    return p >>- ({ (x) -> Parser<(A, B)> in
        q >>- ({ (y) -> Parser<(A, B)> in
            return pure((x, y))
        })
    })
//    return Parser {
//        if let pr = p.parse($0), let qr = q.parse($0) {
//            return ((pr.0, qr.0), qr.1)
//        } else {
//            return nil
//        }
//    }
}

public func sat(_ p: @escaping (Character) -> Bool) -> Parser<Character> {
    return item() >>- ({ (x) -> Parser<Character> in
        return p(x) ? pure(x) : zero()
    })
}

public func char(_ x: Character) -> Parser<Character> {
    return sat({ x == $0 })
}

public func digit() -> Parser<Character> {
    return sat(isDigit)
}

public func lower() -> Parser<Character> {
    return sat(isLower)
}

public func upper() -> Parser<Character> {
    return sat(isUpper)
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
//    let r = bind(letter(), { (x) -> Parser<String> in
//            bind(word(), { (xs) -> Parser<String> in
//                return pure(String(x) + xs)
//            })
//        })
//    return r <+> pure("")
}

public func string(_ str: String) -> Parser<String> {
    if let (x, xs) = separate(str) {
        return char(x) >>- ({ _ in
            string(xs) >>- ({ _ in
                return pure(str)
            })
        })
//        return bind(char(x)) { (_) -> Parser<String> in
//            bind(string(xs), { (_) -> Parser<String> in
//                return pure(str)
//            })
//        }
    } else {
        return pure("")
    }
}

public func many<A>(_ p: Parser<A>) -> Parser<[A]> {
    let r = p >>- ({ (x) in
        many(p) >>- ({ (xs) in
            return pure([x] + xs)
        })
    })
    return r <|> pure([])
//    let r = bind(p, { (x) -> Parser<[A]> in
//        bind(many(p), { (xs) -> Parser<[A]> in
//            return pure([x] + xs)
//        })
//    })
//    return plus(r, pure([]))
}

public func ident() -> Parser<String> {
    return lower() >>- ({ (x) in
        many(alphanum()) >>- ({ (xs) in
            return pure(String(x) + String(xs))
        })
    })
//    return bind(lower(), { (x) -> Parser<String> in
//        bind(many(alphanum()), { (xs) -> Parser<String> in
//            return pure(String(x) + String(xs))
//        })
//    })
}

public func many1<A>(_ p: Parser<A>) -> Parser<[A]> {
    return p >>- ({ (x) in
        many(p) >>- ({ (xs) in
            return pure([x] + xs)
        })
    })
//    return bind(p, { (x) -> Parser<[A]> in
//        bind(many(p), { (xs) -> Parser<[A]> in
//            return pure([x] + xs)
//        })
//    })
}

public func nat() -> Parser<Int> {
    return many1(digit()) >>- ({ (xs) in
        if let r = Int(String(xs)) {
            return pure(r)
        } else {
            return zero()
        }
    })
//    return bind(many1(digit()), { (xs) -> Parser<Int> in
//        if let r = Int(String(xs)) {
//            return pure(r)
//        } else {
//            return zero()
//        }
//    })
}

public func int() -> Parser<Int> {
    let r = char("-") >>- ({ _ in
        nat() >>- ({ n in
            return pure(-n)
        })
    })
    return r <|> nat()
//    return plus(bind(char("-"), { (_) -> Parser<Int> in
//        bind(nat(), { (n) -> Parser<Int> in
//            return pure(-n)
//        })
//    }), nat())
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
//    return bind(char("["), { (_) -> Parser<[Int]> in
//        bind(int(), { (n) -> Parser<[Int]> in
//            bind(many(bind(char(","), { (_) -> Parser<Int> in
//                return int()
//            })), { (ns) -> Parser<[Int]> in
//                bind(char("]"), { (_) -> Parser<[Int]> in
//                    return pure([n] + ns)
//                })
//            })
//        })
//    })
}

public func sepby1<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return p >>- ({ x in
        many(sep >>- ({ _ in
            p >>- ({ y in
                pure(y)
            })
        })) >>- ({ xs in
            pure([x] + xs)
        })
    })
//    return bind(p, { (x) -> Parser<[A]> in
//        bind(many(bind(sep, { (_) -> Parser<A> in
//            return p
//        })), { (xs) -> Parser<[A]> in
//            return pure([x] + xs)
//        })
//    })
}

public func bracket<A, B, C>(_ open: Parser<A>, _ p: Parser<B>, _ close: Parser<C>) -> Parser<B> {
    return open >>- ({ _ in
        p >>- ({ (x) in
            close >>- ({ _ in
                return pure(x)
            })
        })
    })
//    return bind(open, { (_) -> Parser<B> in
//        bind(p, { (x) -> Parser<B> in
//            bind(close, { (_) -> Parser<B> in
//                return pure(x)
//            })
//        })
//    })
}

public func sepby<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return sepby1(p, sep) <|> pure([])
//    return plus(, pure([]))
}

public func chainl1<A>(_ p: Parser<A>, _ op: Parser<((A, A) -> A)>) -> Parser<A> {
    return p >>- ({ x in
        fix { rest in
            { x in
                (op >>- ({ f in
                    p >>- ({ y in
                        rest(f(x, y))
                    })
                })) <|> pure(x)
            }
        }(x)
    })
}

public func chainr1<A>(_ p: Parser<A>, _ op: Parser<((A, A) -> A)>) -> Parser<A> {
    return p >>- ({ x in
        op >>- ({ f in
            chainr1(p, op) >>- ({ y in
                return pure(f(x, y))
            })
        })
    })
}

public func chainl<A>(_ p: Parser<A>, _ op: Parser<(A, A) -> A>, _ v: A) -> Parser<A> {
    return chainl1(p, op) <|> pure(v)
}

public func chainr<A>(_ p: Parser<A>, _ op: Parser<(A, A) -> A>, _ v: A) -> Parser<A> {
    return chainr1(p, op) <|> pure(v)
}

public func number() -> Parser<Int> {
    return nat() <|> pure(0)
}

public func spaces() -> Parser<()> {
    return many1(sat({
        return $0 == " " || $0 == "\n" || $0 == "\t"
    })) >>- ({ _ in pure(()) })
}

//public func zero<A>() -> Parser<A> {
//    return
//}
//
//public func item() -> Parser<Character> {
//    return Parser {
//        return separate($0)
//    }
//}
//
//public func seq<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<(A, B)> {
//    return Parser {
//    }
//}
//
//public func satisfy(_ condition: @escaping (Character) -> Bool) -> Parser<Character> {
//    return Parser(parse: { (xs) -> (Character, String)? in
//        if let result = separate(xs), condition(result.0) {
//            return result
//        } else {
//            return nil
//        }
//    })
//}
//
//public func char(_ c: Character) -> Parser<Character> {
//    return satisfy({
//        return c == $0
//    })
//}
//
//public func string(_ str: String) -> Parser<String> {
//    if let (x, xs) = separate(str) {
//        return seqLeft(seqLeft(char(x), string(xs)), pure(str))
//    } else {
//        return pure("")
//    }
//}
//
//public func sepby<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<[A]> {
//}
