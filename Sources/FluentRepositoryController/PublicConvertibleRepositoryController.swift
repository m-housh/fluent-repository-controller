//
//  PublicConvertibleRepositoryController.swift
//  FluentRepository
//
//  Created by Michael Housh on 6/17/19.
//

import Vapor
import FluentRepository


public class PublicConvertibleRepositoryController<R>: FluentRepositoryController where R: FluentRepository, R.DBModel: Content, R.DBModel: Parameter, R.DBModel.ResolvedParameter == Future<R.DBModel>, R: Service, R.DBModel: PublicConvertible {
    
    public typealias Repository = R
    public typealias ReturnType = R.DBModel.PublicType
    
    public let repository: R
    public let path: String
    
    public required init(_ path: String = "/", on worker: Container) throws {
        self.path = path
        self.repository = try worker.make(R.self)
    }
    
    public func all(_ request: Request) throws -> EventLoopFuture<[ReturnType]> {
        
        let pageQuery = try request.query.decode(DefaultPaginationQuery.self)
        
        /// check if they specified a paginated page.
        guard let page = pageQuery.page else {
            return try repository.all().public()
        }
        
        return try repository.all(page: page).public()
        
    }
    
    public func save(_ request: Request, model: Repository.DBModel) throws -> EventLoopFuture<ReturnType> {
        return try repository.save(model).public()
    }
    
    public func find(_ request: Request) throws -> EventLoopFuture<ReturnType> {
        return try request.parameters.next(Repository.DBModel.self).public()
    }
    
    public func delete(_ request: Request) throws -> EventLoopFuture<HTTPStatus> {
        return try request.parameters.next(Repository.DBModel.self).flatMap { model in
            return self.repository.delete(id: try model.requireID())
            }
            .transform(to: .ok)
    }
}

extension PublicConvertibleRepositoryController: Service where R: Service { }


