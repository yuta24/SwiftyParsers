import Foundation

public func satisfy(_ condition: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser(parse: { (xs) -> (Character, String)? in
        if let result = separete(xs), condition(result.0) {
            return result
        } else {
            return nil
        }
    })
}
