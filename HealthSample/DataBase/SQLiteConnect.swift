//
//  DBService.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/14.
//

import Foundation
import SQLite

class DBService {
    static var path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
    static let db = try! Connection("\(DBService.path).sqlite3")
    
    class UserTable {
        static let users = Table("Users")
        static let id = Expression<Int64>("id")
        static let name = Expression<String>("name")
        static let birthday = Expression<String>("birthday")

        init() {
            do {
                try db.run(DBService.UserTable.users.create { t in
                    t.column(DBService.UserTable.id, primaryKey: true)
                    t.column(DBService.UserTable.name)
                    t.column(DBService.UserTable.birthday, unique: true)
                })
            } catch {
                
            }
        }
        
        static func getAllUsers() -> [User] {
            var _users: [User] = []
            do {
                guard let queryResults = try? db.prepare(users) else {
                        return []
                    }
                _users = try queryResults.map{ row in
                    let _name = try row.get(name)
                    let _birthday = try row.get(birthday)
                    let _id = try row.get(id)
                    return User.init(id: Int(_id), name: _name, birthday: _birthday)
                }
               
            } catch {
                
            }
            return _users
        }
        
        static func insert(name: String, birthday: String) {
            do {
                let insert = DBService
                    .UserTable
                    .users
                    .insert(DBService.UserTable.name <- name,
                            DBService.UserTable.birthday <- birthday)
                try db.run(insert)
            } catch {
        
            }
        }
        
        static func delete(user: User) {
            do {

                let _user = users.filter(id == Int64(user.id))
                try db.run(_user.delete())
          
            } catch {
                
            }
        }
    }
    
    class StepRecordTable {
        
        static let stepRecords = Table("StepRecord")
        static let id = Expression<Int64>("id")
        static let users = Table("users")
        static let userID = Expression<Int64>("userID")
        static let count = Expression<Int64>("count")
        static let date = Expression<String>("date")
        
        init() {
            do {
                try db.run(DBService.StepRecordTable.stepRecords.create { t in
                    t.column(DBService.StepRecordTable.id, primaryKey: true)
                    t.column(DBService.StepRecordTable.userID,
                             references: DBService.StepRecordTable.users,
                                         DBService.StepRecordTable.id)
                    t.column(DBService.StepRecordTable.count)
                    t.column(DBService.StepRecordTable.date)
                })
            } catch {
                print("create stepRecord Table fail")
            }

        }
        
        static func getAllStepRecords() -> [StepRecord] {
            var _stepRecords: [StepRecord] = []
            do {
                guard let queryResults = try? db.prepare(stepRecords) else {
                        return []
                    }
                _stepRecords = try queryResults.map{ row in
                    let _count = try row.get(count)
                    let _date = try row.get(date)
                    let _userID = try row.get(userID)
                    return StepRecord.init(userID: Int64(_userID),
                                           count: Int64(_count),
                                           date: _date)
                }
               
            } catch {
                
            }
            return _stepRecords
        }
        
        static func insert(stepRecord: StepRecord) {
            do {
                let insert = stepRecords.insert(userID <- stepRecord.userID ,
                                                count <- stepRecord.count,
                                                date <- stepRecord.date)
                try db.run(insert)
            } catch {
                print("insert steprecord fail")
            }
        }
        
        static func update(userID _userID: Int64, stepRecord: StepRecord) {
            do {
                let item = stepRecords.filter(_userID == userID)
                if try db.run(item.update(userID <- stepRecord.userID,
                                          count <- stepRecord.count,
                                          date <- stepRecord.date)) > 0 {
                  print("update event")
                }
            } catch {
                print("update steprecord fail")
            }
            
        }
        
        func delete() {
            
        }
        
        func get() {
            
        }
    }
    
    init() {
          _ = UserTable.init()
          _ = StepRecordTable.init()
    }

}
