import Foundation

public struct Parser<A> {
    let parse: (String) -> (A, String)?
}

public func parse<A>(_ p: Parser<A>, _ str: String) -> (A, String)? {
    return p.parse(str)
}

// Applicative
public func pure<A>(_ a: A) -> Parser<A> {
    return Parser {
        return (a, $0)
    }
}

public func item() -> Parser<Character> {
    return Parser {
        return separate($0)
    }
}

public func apply<A, B>(_ p: Parser<(A) -> B>, _ q: Parser<A>) -> Parser<B> {
    return Parser {
        if let (f, str) = p.parse($0) {
            if let (x, xs) = q.parse(str) {
                return (f(x), xs)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

// Alternative
public func some<A>(_ p: Parser<A>) -> Parser<[A]> {
    return p >>= ({ (x) in
        many(p) >>= ({ (xs) in
            return pure([x] + xs)
        })
    })
}

public func many<A>(_ p: Parser<A>) -> Parser<[A]> {
    let r = p >>= ({ (x) in
        many(p) >>= ({ (xs) in
            return pure([x] + xs)
        })
    })
    return r <|> pure([])
}

public func empty<A>() -> Parser<A> {
    return Parser { _ in
        return nil
    }
}

// Monad
public func bind<A, B>(_ p: Parser<A>, _ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return Parser {
        if let r = p.parse($0) {
            return f(r.0).parse(r.1)
        } else {
            return nil
        }
    }
}

public func plus<A>(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
    return Parser {
        return p.parse($0) ?? q.parse($0)
    }
}

public func some1<A>(_ p: Parser<A>) -> Parser<NonEmptyArray<A>> {
    return pure({NonEmptyArray($0.first!, Array($0.dropFirst()))}) <*> some(p)
}

public func <^> <A, B>(_ f: @escaping (A) -> B, _ p: Parser<A>) -> Parser<B> {
    return Parser {
        if let (x, xs) = p.parse($0) {
            return (f(x), xs)
        } else {
            return nil
        }
    }
}

public func <^ <A, B>(_ a: A, _ p: Parser<B>) -> Parser<A> {
    return pure(a)
}

public func ^> <A, B>(_ p: Parser<A>, b: B) -> Parser<B> {
    return pure(b)
}

public func <&> <A, B>(_ p: Parser<A>, _ f: @escaping (A) -> B) -> Parser<B> {
    return f <^> p
}

public func <*> <A, B>(_ p: Parser<(A) -> B>, _ q: Parser<A>) -> Parser<B> {
    return apply(p, q)
}

public func *> <A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<B> {
    return Parser {
        if let (_, str) = p.parse($0) {
            return q.parse(str)
        } else {
            return nil
        }
    }
}

public func <* <A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<A> {
    return Parser {
        if let (f, str) = p.parse($0) {
            if let (_, xs) = q.parse(str) {
                return (f, xs)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

public func >>= <A, B>(_ p: Parser<A>, _ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return bind(p, f)
}

public func <|> <A>(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
    return plus(p, q)
}
