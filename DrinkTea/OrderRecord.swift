//
//  OrderRecord.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/27.
//

import Foundation


struct OrderRecords: Codable {
    var records: [DrinkRecord]
}

struct DrinkRecord: Codable {
    var id: String
    var fields: OrderItem
    var createdTime: String
}

struct OrderItem: Codable {
    var ordererName: String
    var drinkName: String
    var drinkSize: String
    var drinkSugar: String
    var drinkTemp: String   //Ice with Temperature
    var drinkAddon: String
    var drinkQty: Int
    var drinkPrice: Int
    var drinkImgURL: String
}

struct PostRecord: Codable {
    var fields: OrderItem
}

struct DeleteRecord: Codable {
    var deleted: Bool
}




//創建 enum for customer selection

enum SizeLevel: String, CaseIterable {
    case medium = "中杯"
    case big = "大杯"
}

enum SugarLevel: String, CaseIterable {
    case normalSugar = "正常"
    case seventySugar = "少糖"
    case halfSugar = "半糖"
    case thirtySugar = "微糖"
    case twentySugar = "二分糖"  //bipartite sugar
    case tenSugar = "一分糖"
    case zeroSugar = "無糖"
}

enum IceLevel: String, CaseIterable {
    case fullIce = "正常"
    case seventyIce = "少冰"
    case thirtyIce = "微冰"
    case zeroIce = "去冰"
    case deicingIce = "完全去冰"   //De-icing completely
    case normalTemp = "常溫"   //normal temperature
    case warmTemp = "溫飲"
    case hotTemp = "熱飲"
}

enum AddOn: String, CaseIterable {
    case whiteBubble = "白玉珍珠"   // White Tapioca
    case blackBubble = "墨玉珍珠"   // Tapioca
}


