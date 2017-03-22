import Vapor
import Foundation
import Fluent

final class Person: Model {
    
    var id: Node?
    var exists: Bool = false
    var name: String
    var favoriteCity: String     
    init(name: String, favoriteCity: String) {
        self.name = name
        self.favoriteCity = favoriteCity
    }
    
    init(node: Node, in context: Context) throws {
        id = try node.extract("id")
        name = try node.extract("name")
        favoriteCity = try node.extract("favoritecity") // This naming convention is not Swifty but postgres stores everything in lowercase

    }
    
    func makeNode(context: Context) throws -> Node {
        return try Node(node: [
            "id": id,
            "name": name,
            "favoritecity": favoriteCity // postgres requires node to be in lowercase
            ])
    }
    
    static func prepare(_ database: Database) throws {
        try database.create("persons") { users in
            users.id()
            users.string("name")
            users.string("favoritecity") // postgres requires node to be in lowercase

        }
    
    }
    
    static func revert(_ database: Database) throws {
        try database.delete("persons")
    }
    
}
