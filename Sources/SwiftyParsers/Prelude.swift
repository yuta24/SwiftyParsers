import Foundation

public func id<T>(_ t: T) -> T {
    return t
}

public func const<A, B>(_ a: A) -> (B) -> A {
    return { _ in
        return a
    }
}

public func flip<A, B, C>(_ f: @escaping (A) -> (B) -> C) -> (B) -> (A) -> C {
    return { b in
        return { a in
            return f(a)(b)
        }
    }
}

public func fix<A, B>(_ f: @escaping (@escaping (A) -> B) -> (A) -> B) -> (A) -> B {
    return { f(fix(f))($0) }
}

public func foldl<V>(_ f: (V, V) -> V, v: V, vs: [V]) -> V {
    return vs.reduce(v, { f($0, $1) })
}
