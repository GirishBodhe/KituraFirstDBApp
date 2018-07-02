import Foundation
import Kitura
import LoggerAPI
import HeliumLogger
import Application
import SwiftKuery
import SwiftKueryPostgreSQL

do {
   
    let pool = PostgreSQLConnection.createPool(host: "localhost", port: 5432, options: [.databaseName("school")], poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
//    Database.default = Database(pool)
    
    
    HeliumLogger.use(LoggerMessageType.info)

    class Grades: Table {
        let tableName = "grades"
        let id = Column("id", Int32.self, primaryKey: true)
        let course = Column("course", String.self)
        let grade = Column("grade", Int32.self)
    }
    let grades = Grades()
//    let pool = PostgreSQLConnection.createPool(host: "localhost", port: 8080, options: [.databaseName("school")], poolOptions: ConnectionPoolOptions(initialCapacity: 10, maxCapacity: 50, timeout: 10000))
    let students: [[Any]] = [[0, "computing", 921], [1, "physics", 751], [2, "history", 813]]
    
    if let connection = pool.getConnection() {
        let insertQuery = Insert(into: grades, rows: students)
        connection.execute(query: insertQuery) { insertResult in
            connection.execute(query: Select(from: grades)) { selectResult in
                if let resultSet = selectResult.asResultSet {
                    for row in resultSet.rows {
                        print("Student \(row[0] ?? ""), studying \(row[1] ?? ""), scored \(row[2] ?? "")")
                    }
                }
            }
        }
    }
    let app = try App()
    try app.run()

} catch let error {
    Log.error(error.localizedDescription)
}
