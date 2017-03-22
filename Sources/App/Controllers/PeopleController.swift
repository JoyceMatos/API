import Vapor
import HTTP

final class PeopleController: ResourceRepresentable {
    
    // Show all
    func index(request: Request) throws -> ResponseRepresentable {
        
        return try JSON(node: Person.all().makeNode())
    }
    
    // Create new
    func create(request: Request) throws -> ResponseRepresentable {
        var person =  try request.person()
        try person.save()
        return person
    }
    
    // Retrieve item
    func show(request: Request, person: Person) throws -> ResponseRepresentable {
        
        return person
    }
    
    // Update existing person
    func update(request: Request, person: Person) throws -> ResponseRepresentable {
        let new = try request.person()
        var person = person
        person.name = new.name
        person.favoriteCity = new.favoriteCity
        try person.save()
        return person
    }
    
    // Delete person
    func delete(request: Request, person: Person) throws -> ResponseRepresentable {
        try person.delete()
        return JSON([:])
    }

    
    func makeResource() -> Resource<Person> {
    return Resource(
        index: index,
        store: create,
        show: show,
        replace: update,
        destroy: delete
        )
    }
    
}

extension Request {
    
    func person() throws -> Person {
        guard let json = json else { throw Abort.badRequest }
        return try Person(node: json)
        
    }
    
}
