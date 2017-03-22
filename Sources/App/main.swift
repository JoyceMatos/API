import Vapor
import VaporPostgreSQL

let drop = Droplet(
    preparations: [Person.self],
    providers: [VaporPostgreSQL.Provider.self]
)


let basic = BasicController()
basic.addRoutes(drop: drop)

let people = PeopleController()
drop.resource("people", people)

drop.get { req in
    return try drop.view.make("welcome", [
    	"message": drop.localization[req.lang, "welcome", "title"]
    ])
}

drop.resource("posts", PostController())

drop.run()
