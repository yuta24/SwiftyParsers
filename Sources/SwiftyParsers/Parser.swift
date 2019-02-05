import Foundation

public func id<T>(_ t: T) -> T {
    return t
}

public struct Parser<A> {
    let parse: (String) -> (A, String)?
}

// MARK: - Functor
extension Parser {
    func fmap<B>(_ f: @escaping (A) -> B) -> Parser<B> {
        return Parser<B> {
            if let r = self.parse($0) {
                return (f(r.0), r.1)
            } else {
                return nil
            }
        }
    }
}

// MARK: - Applicative
extension Parser {
    static func pure(_ a: A) -> Parser<A> {
        return Parser {
            return (a, $0)
        }
    }

    func seq<B>(_ p: Parser<(A) -> B>) -> Parser<B> {
        return Parser<B> {
            if let (x, xs) = p.parse($0) {
                if let r = self.parse(xs) {
                    return (x(r.0), r.1)
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }

    func seqDiscardRight<B>(_ q: Parser<B>) -> Parser<A> {
        return Parser<A> {
            if let r1 = self.parse($0), let r2 = q.parse(r1.1) {
                return (r1.0, r2.1)
            } else {
                return nil
            }
        }
    }

    func seqDiscardLeft<B>(_ q: Parser<B>) -> Parser<B> {
        return Parser<B> {
            if let r1 = self.parse($0), let r2 = q.parse(r1.1) {
                return r2
            } else {
                return nil
            }
        }
    }
}

// MARK: - Monad
extension Parser {
    func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
        return Parser<B> {
            if let r = self.parse($0) {
                return f(r.0).parse(r.1)
            } else {
                return nil
            }
        }
    }
}

// MARK: - Alternative
extension Parser {
    static func choice(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
        return Parser {
            return p.parse($0) ?? q.parse($0)
        }
    }

    static func some(_ p: Parser<A>) -> Parser<[A]> {
        return p.flatMap({ (xs) -> Parser<[A]> in
            return many(p)
        })
    }

    static func many(_ p: Parser<A>) -> Parser<[A]> {
        return Parser<[A]>.choice(
            Parser<A>.some(p),
            Parser<[A]>.pure([]))
    }
}
