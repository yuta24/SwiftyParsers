import Foundation

public struct Parser<A> {
    let parse: (String) -> (A, String)?
}

public func parse<A>(_ p: Parser<A>, _ str: String) -> (A, String)? {
    return p.parse(str)
}

public func pure<A>(_ a: A) -> Parser<A> {
    return Parser {
        return (a, $0)
    }
}

public func zero<A>() -> Parser<A> {
    return Parser { _ in
        return nil
    }
}

public func item() -> Parser<Character> {
    return Parser {
        return separate($0)
    }
}

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

public func >>- <A, B>(_ p: Parser<A>, _ f: @escaping (A) -> Parser<B>) -> Parser<B> {
    return bind(p, f)
}

public func <|> <A>(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
    return plus(p, q)
}

//// MARK: Monad
//public func pure<A>(_ a: A) -> Parser<A> {
//    return Parser {
//        return (a, $0)
//    }
//}
//
//extension Parser {
//    public func flatMap<B>(_ f: @escaping (A) -> Parser<B>) -> Parser<B> {
//        return Parser<B> {
//            if let (x, xs) = self.parse($0) {
//                return f(x).parse(xs)
//            } else {
//                return nil
//            }
//        }
//    }
//}
//
//// MARK: Functor
//extension Parser {
//    public func fmap<B>(_ f: @escaping (A) -> B) -> Parser<B> {
//        return Parser<B> {
//            if let (x, xs) = self.parse($0) {
//                return (f(x), xs)
//            } else {
//                return nil
//            }
//        }
//    }
//}
//
//// MARK: - Applicative
//public func seq<A, B>(_ p: Parser<(A) -> B>, _ q: Parser<A>) -> Parser<B> {
//    return Parser<B> {
//        if let (x, xs) = p.parse($0) {
//            if let r = q.parse(xs) {
//                return (x(r.0), r.1)
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//    }
//}
//
//public func seqRight<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<A> {
//    return Parser<A> {
//        if let r1 = p.parse($0), let r2 = q.parse(r1.1) {
//            return (r1.0, r2.1)
//        } else {
//            return nil
//        }
//    }
//}
//
//public func seqLeft<A, B>(_ p: Parser<A>, _ q: Parser<B>) -> Parser<B> {
//    return Parser<B> {
//        if let r1 = p.parse($0), let r2 = q.parse(r1.1) {
//            return r2
//        } else {
//            return nil
//        }
//    }
//}
//
//// MARK: - Alternative
//public func empty<A>() -> Parser<A> {
//    return Parser<A> { _ in
//        return nil
//    }
//}
//
//public func choice<A>(_ p: Parser<A>, _ q: Parser<A>) -> Parser<A> {
//    return Parser {
//        return p.parse($0) ?? q.parse($0)
//    }
//}
//
//public func some<A>(_ p: Parser<A>) -> Parser<[A]> {
//    return p.flatMap({ (xs) -> Parser<[A]> in
//        return many(p)
//    })
//}
//
//public func many<A>(_ p: Parser<A>) -> Parser<[A]> {
//    return choice(some(p), pure([]))
//}
