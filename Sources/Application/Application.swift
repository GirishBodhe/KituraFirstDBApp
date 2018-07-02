import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
        router.all(middleware: BodyParser())
    }

    func postInit() throws {
        // Endpoints
        initializeHealthRoutes(app: self)
        
        // Handle HTTP GET requests to "/"
        router.get("/") { request, response, next in
            response.send("PrideVel..!!")
            next()
        }
        
        // Handle HTTP Post requests to "/"
        router.post("/getPost") { request, response, next in
            
            guard let postData = request.body else {next();return}
            
            switch (postData){
            case .json(let jsonData):
                let marke : String =  jsonData["marke"] as! String
                if marke == "VM" {
                    response.send("Vvvvvvvvvvvvv")
                    
                }else {
                    
                    response.send("Hoooooooooooo")
                }
            case .urlEncoded(_): break
                
            case .urlEncodedMultiValue(_): break
                
            case .text(_): break
                
            case .raw(_): break
                
            case .multipart(_): break
                
            }
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
