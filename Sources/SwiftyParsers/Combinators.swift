import Foundation

public func satisfy(_ condition: @escaping (Character) -> Bool) -> Parser<Character> {
    return Parser(parse: { (xs) -> (Character, String)? in
        if let result = separate(xs), condition(result.0) {
            return result
        } else {
            return nil
        }
    })
}
