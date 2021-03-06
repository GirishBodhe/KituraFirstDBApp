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
        
       
        router.get("/delete") { request, response, next in
            
            let targetURL = URL(string: "postgres://ddmerwmzfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1")
            let pool = PostgreSQLConnection.createPool(url:targetURL!, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
            
            //            let randomNum = Int(arc4random_uniform(100)) // range is 0 to 99
            
            
            if let connection = pool.getConnection() {
                
                let deleteQuery = Delete(from: self.grades).where(self.grades.id == 20);  connection.execute(query: deleteQuery) { insertResult in
                    
                    print("success Delete..!")
                    response.send("Delete..!")
                }
                
            }
            
        }
        
        
        router.get("/update") { request, response, next in
            
            let targetURL = URL(string: "postgres://ddmerwmzfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1")
            let pool = PostgreSQLConnection.createPool(url:targetURL!, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
            
            //            let randomNum = Int(arc4random_uniform(100)) // range is 0 to 99
            
            
            if let connection = pool.getConnection() {
                
                                let query = Update(self.grades, set: [(self.grades.course, "UpdatedValue English"), (self.grades.grade, 899)])
                                    .where(self.grades.id == 20)
                                connection.execute(query: query) { insertResult in
                                    
                                    print("success Updated..!")
                                    response.send("Updated..!")
                                }
                                
                            }
            
            }
        
        router.post("/insert") { request, response, next in
           
            
            guard let postData = request.body else {next();return}
            
            switch (postData){
            case .json(let jsonData):
                
                let targetURL = URL(string: "postgres://ddmerwmzfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1")
                let pool = PostgreSQLConnection.createPool(url:targetURL!, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
                
                //            let randomNum = Int(arc4random_uniform(100)) // range is 0 to 99
                print("Connected....!!")
                let query = Select(from: self.grades)
                    .order(by: .DESC(self.grades.id))
                
                if let connection = pool.getConnection() {
                    
                    connection.execute(query: query) { selectResult in
                        print("Query....!!")
                        if let resultSet = selectResult.asResultSet {
                            var dataOne = true
                            for row in resultSet.rows {
                                if (dataOne){
                                    dataOne = false
                                    
                                    print("Query_Result....!!")
                                    let nextId = row[0] as! Int32 + 1
                                    
//                                    let students: [[Any]] = [[nextId , "computing\(nextId)", nextId + 30]]
                                    let students: [[Any]] = [[nextId , jsonData["course"] as! String , jsonData["grade"] as! Int]]
                                    
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
            case .urlEncoded(_): break
                
            case .urlEncodedMultiValue(_): break
                
            case .text(_): break
                
            case .raw(_): break
                
            case .multipart(_): break
                
            }
            
            
           
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
                            var jsonData = [Any]()
                            for row in resultSet.rows {
                                
                                let jsonObject: [String: Any] = [
                                   
                                        "Student": row[0] ?? "" ,
                                        "studying": row[1] ?? "" ,
                                        "scored": row[2] ?? "" ,
                                    
                                ]
                                print("\(jsonObject.description)")
                                jsonData.append(jsonObject)
//                                response.send("Student: \(row[0] ?? ""), studying: \(row[1] ?? ""), scored: \(row[2] ?? "")\n")
                            }
                            response.send(json: jsonData)
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
