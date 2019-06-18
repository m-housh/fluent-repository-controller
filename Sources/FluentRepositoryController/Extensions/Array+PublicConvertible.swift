
//
//  Array+PublicConvertible.swift
//  FluentRepository
//
//  Created by Michael Housh on 6/17/19.
//

import Vapor
import FluentRepository


extension Array: PublicConvertible where Element: PublicConvertible {
    
    public var `public`: Array<Element.PublicType> {
        return map { u in return u.public }
    }
}


