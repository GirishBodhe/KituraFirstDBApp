import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Application
import SwiftKuery
import SwiftKueryPostgreSQL

do {
   

    HeliumLogger.use(LoggerMessageType.info)

//    class Grades: Table {
//        let tableName = "grades"
//        let id = Column("id", Int32.self, primaryKey: true)
//        let course = Column("course", String.self)
//        let grade = Column("grade", Int32.self)
//    }
//    let grades = Grades()
//
//    
//    //    let pool = PostgreSQLConnection.createPool(host: "localhost", port: 5432, options: [.databaseName("school")], poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
//    
//    let pool = PostgreSQLConnection.createPool(url:NSURL(fileURLWithPath:"zfdtmyn:9c4b553e93629efbfd8fc93cf2bf0b680a45f28bb7b776741d431b24bf456cc6@ec2-107-21-236-219.compute-1.amazonaws.com:5432/dajoh4aerlt4c1") as URL, poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
//    
//    let students: [[Any]] = [[0, "computing", 921], [1, "physics", 751], [2, "history", 813]]
//    
//    if let connection = pool.getConnection() {
//        let insertQuery = Insert(into: grades, rows: students)
//        connection.execute(query: insertQuery) { insertResult in
//            connection.execute(query: Select(from: grades)) { selectResult in
//                if let resultSet = selectResult.asResultSet {
//                    for row in resultSet.rows {
//                        print("Student \(row[0] ?? ""), studying \(row[1] ?? ""), scored \(row[2] ?? "")")
//                    }
//                }
//            }
//        }
//    }
    let app = try App()
    try app.run()

} catch let error {
    Log.error(error.localizedDescription)
}
