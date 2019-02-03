import Foundation

public func id<T>(_ t: T) -> T {
    return t
}

public struct Parser<A> {
    let parse: (String) -> (A, String)?
}

public extension Parser {
    static func fmap<B>(_ p: Parser<A>, _ f: @escaping (A) -> B) -> Parser<B> {
        return Parser<B> {
            if let r = p.parse($0) {
                return (f(r.0), r.1)
            } else {
                return nil
            }
        }
    }
}

public extension Parser {
    static func pure(_ a: A) -> Parser<A> {
        return Parser {
            return (a, $0)
        }
    }

    static func apply<B>(_ p: Parser<(A) -> B>, _ q: Parser<A>) -> Parser<B> {
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
}
