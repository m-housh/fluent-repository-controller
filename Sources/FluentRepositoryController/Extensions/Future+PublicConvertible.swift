//
//  Future+PublicConvertible.swift
//  FluentRepository
//
//  Created by Michael Housh on 6/17/19.
//

import Vapor
import FluentRepository

extension Future where T: PublicConvertible {
    
    public func `public`() throws -> Future<T.PublicType> {
        return map { model in return model.public }
    }
}


