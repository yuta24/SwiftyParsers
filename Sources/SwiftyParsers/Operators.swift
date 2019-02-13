import Foundation

precedencegroup infixl0 {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup infixr0 {
    associativity: right
    higherThan: infixl0
}

precedencegroup infixl1 {
    associativity: left
    higherThan: infixr0
}

precedencegroup infixr1 {
    associativity: right
    higherThan: infixl1
}

infix operator >>-: infixl0
infix operator <|>: infixl1
