//
//  DrinkMenu.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/27.
//

import Foundation

struct ResponseData: Codable {
    let records: [Record]
}

struct Record: Codable {
    let id: String
    let fields: Field
}

struct Field: Codable {
    let drinkName: String
    let engName: String
    let mediumPrice: Int
    let largePrice: Int?
    let sort: Int
    let brief: String?
    let imageURL: String
    let drinkDesc: String    //如果有些欄位沒有資料要用 String?才不會遇到 JSON decoder出現無法解碼的 error
}
