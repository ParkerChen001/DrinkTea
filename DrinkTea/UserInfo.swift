//
//  UserInfo.swift
//  drink-order-app
//
//  Created by Parker Chen on 2021/4/28.
//

import Foundation

class UserInfo {
    var userName: String
    var userGroup: String
    var editCode: String
    
    init(userName: String,
         userGroup: String,
         editCode: String) {
        self.userName = userName
        self.userGroup = userGroup
        self.editCode = editCode
    }
    
    func reset() {
        userName = ""
        userGroup = ""
        editCode = ""
    }
}
