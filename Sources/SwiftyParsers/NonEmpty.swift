//
//  NonEmpty.swift
//  SwiftyParsers
//
//  Created by Yu Tawata on 2019/02/16.
//

import Foundation

public struct NonEmpty<C> where C: Collection {
    public var head: C.Element
    public var tail: C

    public init(_ head: C.Element, _ tail: C) {
        self.head = head
        self.tail = tail
    }
}

extension NonEmpty: Equatable where C: Equatable, C.Element: Equatable {
}

extension NonEmpty: Hashable where C: Hashable, C.Element: Hashable {
}

public typealias NonEmptyArray<Element> = NonEmpty<[Element]>
