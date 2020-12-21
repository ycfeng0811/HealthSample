//
//  User.swift
//  HealthSample
//
//  Created by Feng Yangching on 2020/12/16.
//


class User {
    var name: String
    var birthday: String
    var id: Int?
    init(id: Int? = nil, name: String, birthday: String) {
        self.id = id
        self.name =  name
        self.birthday = birthday
    }
}
