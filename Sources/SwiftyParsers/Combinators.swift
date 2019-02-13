import Foundation

public func seq<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<(A, B)> {
    return p >>- ({ (x) -> Parser<(A, B)> in
        q >>- ({ (y) -> Parser<(A, B)> in
            return pure((x, y))
        })
    })
}

public func many<A>(_ p: Parser<A>) -> Parser<[A]> {
    let r = p >>- ({ (x) in
        many(p) >>- ({ (xs) in
            return pure([x] + xs)
        })
    })
    return r <|> pure([])
}

public func many1<A>(_ p: Parser<A>) -> Parser<[A]> {
    return p >>- ({ (x) in
        many(p) >>- ({ (xs) in
            return pure([x] + xs)
        })
    })
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
}

public func bracket<A, B, C>(_ open: Parser<A>, _ p: Parser<B>, _ close: Parser<C>) -> Parser<B> {
    return open >>- ({ _ in
        p >>- ({ (x) in
            close >>- ({ _ in
                return pure(x)
            })
        })
    })
}

public func sepby<A, B>(_ p: Parser<A>, _ sep: Parser<B>) -> Parser<[A]> {
    return sepby1(p, sep) <|> pure([])
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
