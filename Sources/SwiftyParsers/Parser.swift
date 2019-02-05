import Foundation

public struct Parser<A> {
    let parse: (String) -> (A, String)?
}

public func parse<A>(_ p: Parser<A>, _ str: String) -> (A, String)? {
    return p.parse(str)
}

// MARK: Monad
func pure<A>(_ a: A) -> Parser<A> {
    return Parser {
        return (a, $0)
    }
}

extension Parser {
    func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
        return Parser<B> {
            if let (x, xs) = self.parse($0) {
                return f(x).parse(xs)
            } else {
                return nil
            }
        }
    }
}

// MARK: Functor
extension Parser {
    func fmap<B>(_ f: @escaping (A) -> B) -> Parser<B> {
        return Parser<B> {
            if let (x, xs) = self.parse($0) {
                return (f(x), xs)
            } else {
                return nil
            }
        }
    }
}

// MARK: - Applicative
func seq<A, B>(_ p: Parser<(A) -> B>, _ q: Parser<A>) -> Parser<B> {
    return Parser<B> {
        if let (x, xs) = p.parse($0) {
            if let r = q.parse(xs) {
                return (x(r.0), r.1)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}

func seqRight<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<A> {
    return Parser<A> {
        if let r1 = p.parse($0), let r2 = q.parse(r1.1) {
            return (r1.0, r2.1)
        } else {
            return nil
        }
    }
}

func seqLeft<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<B> {
    return Parser<B> {
        if let r1 = p.parse($0), let r2 = q.parse(r1.1) {
            return r2
        } else {
            return nil
        }
    }
}

// MARK: - Alternative
func choice<A>(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
    return Parser {
        return p.parse($0) ?? q.parse($0)
    }
}

func some<A>(_ p: Parser<A>) -> Parser<[A]> {
    return p.flatMap({ (xs) -> Parser<[A]> in
        return many(p)
    })
}

func many<A>(_ p: Parser<A>) -> Parser<[A]> {
    return choice(some(p), pure([]))
}
