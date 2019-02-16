import Foundation

// TODO: choice

public func option<A>(_ a: A, _ p: Parser<A>) -> Parser<A> {
    return p <|> pure(a)
}

public func skipOptional<A>(_ p: Parser<A>) -> Parser<()> {
    return (() <^ p) <|> pure(())
}

public func between<A, B, C>(_ bra: Parser<A>, _ ket: Parser<B>, _ p: Parser<C>) -> Parser<C> {
    return bra *> p <* ket
}

public func surroundedBy<A, B>(_ p: Parser<A>, _ bound: Parser<B>) -> Parser<A> {
    return between(bound, bound, p)
}

public func sepBy<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return sepBy1(p, sep) <|> pure([])
}

public func sepBy1<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return { [$0.head] + $0.tail } <^> sepByNonEmpty(p, sep)
}

public func sepByNonEmpty<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<NonEmptyArray<A>> {
    return { a in { NonEmptyArray(a, $0) } } <^> p <*> many(sep *> p)
}

public func sepEndBy1<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return { [$0.head] + $0.tail } <^> sepEndByNonEmpty(p, sep)
}

public func sepEndByNonEmpty<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<NonEmptyArray<A>> {
    return { a in { NonEmptyArray(a, $0) } } <^> p <*> ((sep *> sepEndBy(p, sep)) <|> pure([]))
}

public func sepEndBy<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return sepEndBy1(p, sep) <|> pure([])
}

public func endBy1<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return some(p <* sep)
}

public func endByNonEmpty<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<NonEmptyArray<A>> {
    return some1(p <* sep)
}

public func endBy<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return many(p <* sep)
}

// TODO: count

public func chainr<A>(_ p: Parser<A>, _ op: Parser<(A, A) -> A>, _ x: A) -> Parser<A> {
    return chainr1(p, op) <|> pure(x)
}

public func chainl<A>(_ p: Parser<A>, _ op: Parser<(A, A) -> A>, _ x: A) -> Parser<A> {
    return chainl1(p, op) <|> pure(x)
}

public func chainl1<A>(_ p: Parser<A>, _ op: Parser<((A, A) -> A)>) -> Parser<A> {
    return p >>= ({ x in
        fix { rest in
            { x in
                (op >>= ({ f in
                    p >>= ({ y in
                        rest(f(x, y))
                    })
                })) <|> pure(x)
            }
            }(x)
    })
}

public func chainr1<A>(_ p: Parser<A>, _ op: Parser<((A, A) -> A)>) -> Parser<A> {
    return p >>= ({ x in
        op >>= ({ f in
            chainr1(p, op) >>= ({ y in
                return pure(f(x, y))
            })
        })
    })
}

// TODO: manyTill

public func seq<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<(A, B)> {
    return p >>= ({ (x) -> Parser<(A, B)> in
        q >>= ({ (y) -> Parser<(A, B)> in
            return pure((x, y))
        })
    })
}

public func bracket<A, B, C>(_ open: Parser<A>, _ p: Parser<B>, _ close: Parser<C>) -> Parser<B> {
    return open >>= ({ _ in
        p >>= ({ (x) in
            close >>= ({ _ in
                return pure(x)
            })
        })
    })
}

public func skipMany<A>(_ p: Parser<A>) -> Parser<()> {
    return skipMany1(p) <|> pure(())
}

public func skipMany1<A>(_ p: Parser<A>) -> Parser<()> {
    return p *> skipMany(p)
}
