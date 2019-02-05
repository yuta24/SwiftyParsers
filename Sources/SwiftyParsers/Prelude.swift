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
