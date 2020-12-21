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
        static let users = Table("users")
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
        
        static func insert(user: User) {
            do {
                let insert = DBService
                    .UserTable
                    .users
                    .insert(DBService.UserTable.name <- user.name,
                            DBService.UserTable.birthday <- user.birthday)
                try db.run(insert)
            } catch {
        
            }
        }
        
        static func delete(user: User) {
            do {
                guard let _id = user.id else {
                    return
                }
                let _user = users.filter(id == Int64(_id))
                try db.run(_user.delete())
          
            } catch {
                
            }
        }
    }
    
    class StepRecordTable {
        
        let stepRecords = Table("StepRecord")
        let id = Expression<Int64>("id")
        let users = Table("users")
        let userID = Expression<Int64>("userID")
        let count = Expression<Int64>("count")
        let date = Expression<String>("date")
        
        init() {
            do {
                try db.run(stepRecords.create { t in
                        t.column(id, primaryKey: true)
                        t.column(userID, references: users, id)
                        t.column(count)
                        t.column(date)
                })
            } catch {
                print("create stepRecord Table fail")
            }

        }
        
        func insert(stepRecord: StepRecord) {
            do {
                let insert = stepRecords.insert(userID <- stepRecord.userID ,count <- stepRecord.count, date <- stepRecord.date)
                try db.run(insert)
            } catch {
                print("insert steprecord fail")
            }
        }
        
        func update(userID _userID: Int64, stepRecord: StepRecord) {
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
