import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import SwiftKuery
import SwiftKueryPostgreSQL

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

class Grades: Table {
    let tableName = "grades"
    let id = Column("id", Int32.self, primaryKey: true)
    let course = Column("course", String.self)
    let grade = Column("grade", Int32.self)
}

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    let grades = Grades()
    
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
        router.get("/insert") { request, response, next in
            
            let targetURL = URL(string: "postgres://ddmerwmzfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1")
            let pool = PostgreSQLConnection.createPool(url:targetURL!, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
            
//            let randomNum = Int(arc4random_uniform(100)) // range is 0 to 99
           
            let query = Select(from: self.grades)
            .order(by: .DESC(self.grades.id))
     
            if let connection = pool.getConnection() {
            
                connection.execute(query: query) { selectResult in
                    if let resultSet = selectResult.asResultSet {
                        var dataOne = true
                         for row in resultSet.rows {
                            if (dataOne){
                               dataOne = false
                                let nextId = row[0] as! Int32 + 1
                                let students: [[Any]] = [[nextId , "computing\(nextId)", nextId + 30]]
                                let insertQuery = Insert(into: self.grades, rows: students)
                                connection.execute(query: insertQuery) { insertResult in
                                    
                                    print("success insert..!")
                                    response.send("Added..!")
                                }
                            
                            }
                        }
                    }
                }
            }
                
//                let insertQuery = Insert(into: self.grades, rows: students)
//                connection.execute(query: insertQuery) { insertResult in
//                    connection.execute(query: Select(from: self.grades)) { selectResult in
//                        if let resultSet = selectResult.asResultSet {
//                            for row in resultSet.rows {
//                                response.send("Student: \(row[0] ?? ""), studying: \(row[1] ?? ""), scored: \(row[2] ?? "")\n")
//                                print("Student: \(row[0] ?? ""), studying: \(row[1] ?? ""), scored: \(row[2] ?? "")\n")
//                            }
//                        }
//                    }
//                }
//            }
//            response.send("PrideVel..!!")
            next()
        }
        router.get("/all") { request, response, next in
            
            let targetURL = URL(string: "postgres://ddmerwmzfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1")
            let pool = PostgreSQLConnection.createPool(url:targetURL!, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
            
            //            let randomNum = Int(arc4random_uniform(100)) // range is 0 to 99
            
            
//            let students: [[Any]] = [[3, "computing", 78], [4, "physics", 98], [5, "history", 99]]
            
            if let connection = pool.getConnection() {
//                let insertQuery = Insert(into: self.grades, rows: students)
//                connection.execute(query: insertQuery) { insertResult in
                    connection.execute(query: Select(from: self.grades)) { selectResult in
                        if let resultSet = selectResult.asResultSet {
                            for row in resultSet.rows {
                                response.send("Student: \(row[0] ?? ""), studying: \(row[1] ?? ""), scored: \(row[2] ?? "")\n")
                            }
                        }
//                    }
                }
            }
            //            response.send("PrideVel..!!")
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
