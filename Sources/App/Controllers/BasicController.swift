import Vapor
import HTTP
import VaporPostgreSQL

final class BasicController {
    
    func addRoutes(drop: Droplet) {
        drop.get("version", handler: version)
        drop.get("model", handler: model)
        drop.get("test", handler: test)
        
        drop.post("new", handler: new)
        drop.get("all", handler: all)
        drop.get("joy", handler: joy)
        drop.get("notJoy", handler: notJoy)
        drop.get("update", handler: update)
        drop.get("deleteJoy", handler: deleteJoy)
        
    }
    
    func version(request: Request) throws -> ResponseRepresentable {
        if let db = drop.database?.driver as? PostgreSQLDriver {
            let version = try db.raw("SELECT version()")
            return try JSON(node: version)
        } else {
            return "No db connection"
        }
    }
    
    func model(request: Request) throws -> ResponseRepresentable {
        let person = Person(name: "Sean", favoriteCity: "New York")
        return try person.makeJSON()
    }
    
    func test(request: Request) throws -> ResponseRepresentable {
        var person = Person(name: "Sean", favoriteCity: "New York")
        try person.save()
        return try JSON(node: Person.all().makeNode())
    }
    
    func new(request: Request) throws -> ResponseRepresentable { // post
        var person = try Person(node: request.json)
        try person.save()
        return person
    }
    
    func all(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Person.all().makeNode())
        
    }
    
    func first(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Person.query().first()?.makeNode())
        
    }
    
    func joy(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Person.query().filter("name", "Joyce").all().makeNode())
        
    }
    
    func notJoy(request: Request) throws -> ResponseRepresentable {
        return try JSON(node: Person.query().filter("name", .notEquals, "Joyce").all().makeNode())
        
    }
    
    func update(request: Request) throws -> ResponseRepresentable {
        guard var first = try Person.query().first(),
            let name = request.data["name"]?.string else {
                throw Abort.badRequest
        }
        
        first.name = name
        try first.save()
        return first
    }
    
    func deleteJoy(request: Request) throws -> ResponseRepresentable {
        let query = try Person.query().filter("name", "Joyce")
        try query.delete()
        return try JSON(node: Person.all().makeNode())
        
    }
    
    
    
}
