//
//  RepositoryRouteController.swift
//  FluentRepository
//
//  Created by Michael Housh on 5/10/19.
//

import Vapor
import FluentRepository


/**
 # RepositoryRouteController
 ------
 
 Handles api routes using a `FluentRepository`.
 
*/
public protocol FluentRepositoryController {
    
    /// The `FluentRepository` type used for database queries.
    associatedtype Repository: FluentRepository
    
    /// The return type, this is typically the database model.
    associatedtype ReturnType: Content
    
    /// The concrete `FluentRepository`.
    var repository: Repository { get }
    
    /// A path to register the api routes.
    var path: String { get }
    
    /// Get all the database models.
    func all(_ request: Request) throws -> Future<[ReturnType]>
    
    /// Get a database model by `id`.
    func find(_ request: Request) throws -> Future<ReturnType>
    
    /// Create or Update a database model.
    func save(_ request: Request, model: Repository.DBModel) throws -> Future<ReturnType>
    
    /// Delete a database model.
    func delete(_ request: Request) throws -> Future<HTTPStatus>
}

extension FluentRepositoryController where Self: RouteCollection, Repository.DBModel: Parameter, Repository.DBModel: RequestDecodable {
    
    /// - seealso: `RouteCollection`
    public func boot(router: Router) {
        router.get(path, use: all)
        router.post(Repository.DBModel.self, at: path, use: save)
        router.get(path, Repository.DBModel.parameter, use: find)
        router.delete(path, Repository.DBModel.parameter, use: delete)
    }
}
