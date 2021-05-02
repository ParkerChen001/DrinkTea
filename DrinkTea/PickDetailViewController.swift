//
//  PickDetailViewController.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/27.
//

import UIKit

class PickDetailViewController: UIViewController {

    private var sizeCup:Dropdown3!
    private var sugarLevel:Dropdown3!
    private var temperature:Dropdown3!

    @IBOutlet weak var lbDrinkName: UILabel!
    @IBOutlet weak var lbDrinkEngName: UILabel!
    @IBOutlet weak var lbDrinkBrief: UILabel!
    
    @IBOutlet weak var vwSizeCup: UIView!
    @IBOutlet weak var lbSizeCup: UILabel!
    @IBOutlet weak var vwSweetLevel: UIView!
    @IBOutlet weak var lbSugarLevel: UILabel!
    @IBOutlet weak var vwTemperature: UIView!
    @IBOutlet weak var lbTemperature: UILabel!
    @IBOutlet weak var AddWhiteBall: UIButton!
    @IBOutlet weak var AddBlackBall: UIButton!

    @IBOutlet weak var lbDrinkPrice: UILabel!
    @IBOutlet weak var lbDrinkPicks: UILabel!
    @IBOutlet weak var orderDrinkButton: UIButton!

    let urlStr = "https://api.airtable.com/v0/appxguA4PpPvT0drU/OrderRecords"
    
    var addonCheck = Array(repeating: false, count: 2)
    let addonPrice = [10, 15]
    var ordererName: String = ""
    var drinkName: String = ""
    var drinkSize: String = ""
    var drinkSugar: String = ""
    var drinkTemp: String = ""
    var drinkAddon: String = ""
    var drinkImgURL: String = ""
    var mediumPrice: Int = 0
    var largePrice: Int?
    var drinkPrice: Int = 0
    var drinkQty: Int = 0
    let drinkSizeSet: [[String]] = [["中杯", "大杯"], ["中杯"]]
    var drinkSizeOption = Array<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        //set order button action disable
        OrderBtnState(false)
        getDrinkData()
        //setup pick option
        setupLayout()
        setupDropDown()
    }

    // 取得對應飲料的資料
    func getDrinkData() {
        if let drinkRecord = selectedDrinkRecord {
            let field = drinkRecord.fields

            //check selected drink has all size or only middle size?
            if let _ = field.largePrice {
                drinkSizeOption = drinkSizeSet[0]
            } else {
                drinkSizeOption = drinkSizeSet[1]
            }

            self.lbDrinkName.text = field.drinkName
            self.lbDrinkEngName.text = field.engName
            self.lbDrinkBrief.text = field.brief
            
            self.drinkName = field.drinkName
            self.drinkImgURL = field.imageURL
            self.mediumPrice = field.mediumPrice
            if let largePrice = field.largePrice{
                self.largePrice = largePrice
            }
        }
    }


    fileprivate func setupLayout() {
        vwSizeCup.layer.cornerRadius = 5
        vwSizeCup.layer.masksToBounds = true

        vwSweetLevel.layer.cornerRadius = 5
        vwSweetLevel.layer.masksToBounds = true

        vwTemperature.layer.cornerRadius = 5
        vwTemperature.layer.masksToBounds = true
    }

    fileprivate func setupDropDown() {
        sizeCup = Dropdown3.instance()
            .bind(drinkSizeOption)
            .setLayoutCell(normal: .white, highlight: .init(named: "DeepBlueColor"), height: 45)
            .setLayoutTitle(normal: .init(named: "DeepBlueColor"), highlight: .white, font: UIFont.systemFont(ofSize: 17))
            .setPadding(leading: 20, trailing: 20)
            .setDidSelectRowAt({ (_, item, dropDown) in
                self.lbSizeCup.text = item.title
                self.drinkSize = item.title
                self.showDrinkPicks()
                dropDown.hide()
            })

        sugarLevel = Dropdown3.instance()
            .bind(["正常糖", "少糖", "半糖", "微糖", "二分糖", "一分糖", "無糖"])
            .setLayoutCell(normal: .white, highlight: .init(named: "DeepBlueColor"), height: 45)
            .setLayoutTitle(normal: .init(named: "DeepBlueColor"), highlight: .white, font: UIFont.systemFont(ofSize: 17))
            .setPadding(leading: 20, trailing: 20)
            .setDidSelectRowAt({ (_, item, dropDown) in
                self.lbSugarLevel.text = item.title
                self.drinkSugar = item.title
                self.showDrinkPicks()
                dropDown.hide()
            })

        temperature = Dropdown3.instance()
            .bind(["正常冰", "少冰", "微冰", "去冰", "完全去冰", "常溫", "溫", "熱"])
            .setLayoutCell(normal: .white, highlight: .init(named: "DeepBlueColor"),height: 45)
            .setLayoutTitle(normal: .init(named: "DeepBlueColor"), highlight: .white, font: UIFont.systemFont(ofSize: 17))
            .setPadding(leading: 20, trailing: 20)
            .setDidSelectRowAt({ (_, item, dropDown) in
                self.lbTemperature.text = item.title
                self.drinkTemp = item.title
                self.showDrinkPicks()
                dropDown.hide()
            })
    }

    @IBAction func pickDetailButton(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sizeCup
                .setLayoutCell(width:sender.frame.width - 10)
                .show(self, targetView: sender)
        case 1:
            sugarLevel
                .setLayoutCell(width:sender.frame.width - 10)
                .show(self, targetView: sender)
        case 2:
            temperature
                .setLayoutCell(width:sender.frame.width - 10)
                .show(self, targetView: sender)
        default:
            print("error button")
        }
    }

    @IBAction func addOnButton(_ sender: UIButton) {
        switch sender.tag {
        case 0: //white ball
            if addonCheck[sender.tag] {
                AddWhiteBall.setImage(UIImage(named: "radio_off_2"), for: .normal)
            } else {
                AddWhiteBall.setImage(UIImage(named: "radio_on_2"), for: .normal)
            }
        case 1: //black ball
            if addonCheck[sender.tag] {
                AddBlackBall.setImage(UIImage(named: "radio_off_2"), for: .normal)
            } else {
                AddBlackBall.setImage(UIImage(named: "radio_on_2"), for: .normal)
            }
        default:
            print("WHAT Ball ???")
        }
        addonCheck[sender.tag] = !addonCheck[sender.tag]
        self.showDrinkPicks()
    }
    
    func OrderBtnState(_ isEnabled: Bool) {
        if isEnabled {
            orderDrinkButton.isEnabled = true
            orderDrinkButton.backgroundColor = UIColor(named: "LightYellowColor")
        } else {
            orderDrinkButton.isEnabled = false
            orderDrinkButton.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        }
    }

    func showDrinkPicks() {
        
        var showPicks: String = ""
        drinkPrice = self.mediumPrice

        if self.drinkSize != "" {
            showPicks += self.drinkSize
            switch self.drinkSize {
            case "中杯":
                drinkPrice = self.mediumPrice
            case "大杯":
                drinkPrice = self.largePrice!
            default:
                drinkPrice = self.mediumPrice
            }
        }

        if self.drinkSugar != "" {
            showPicks += "、" + self.drinkSugar
        }

        if self.drinkTemp != "" {
            showPicks += "、" + self.drinkTemp
        }
        
        if (self.drinkSize != "" && self.drinkSugar != "" && self.drinkTemp != "") {
            //enable the order button action
            OrderBtnState(true)
        }

        if addonCheck[0] == true {
            showPicks += "、加白玉"
            drinkPrice += addonPrice[0]
            self.drinkAddon = "加白玉"
        }
        if addonCheck[1] == true {
            showPicks += "、加墨玉"
            drinkPrice += addonPrice[1]
            if addonCheck[0] == true {
                self.drinkAddon += "、加墨玉"
            } else {
                self.drinkAddon = "加墨玉"
            }
        }
        lbDrinkPrice.text = "$" + "\(drinkPrice)" + ".00"
        lbDrinkPicks.text = showPicks
    }

    // MARK: POST / UPDATE DATA
    func sentOrderRequest() {
        // 建立drinkOrder物件
        self.ordererName = userInfo.userName
        self.drinkQty = 1

        let orderData = OrderItem(ordererName: self.ordererName, drinkName: self.drinkName, drinkSize: self.drinkSize, drinkSugar: self.drinkSugar, drinkTemp: self.drinkTemp,  drinkAddon: self.drinkAddon, drinkQty: 1, drinkPrice: self.drinkPrice, drinkImgURL: self.drinkImgURL)
        
        let drinkOrder = PostRecord(fields: orderData)

        //tempoaray using
        let url: URL?
        url = URL(string: urlStr)!
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // set HTTPHeaderField
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 搭配jsonEncoder將自訂型別變成JSON格式的Data
        let jsonEncoder = JSONEncoder()
        print("bulid jsonEncoder")
        if let data = try? jsonEncoder.encode(drinkOrder) {
            let _ = String(data: data, encoding: .utf8)
            URLSession.shared.uploadTask(with: urlRequest, from: data) { (retData, res, err) in
                // 檢查是否上傳成功
                if let response = res as? HTTPURLResponse,
                   response.statusCode == 200,
                   err == nil {
                    print("success")
                    DispatchQueue.main.async {
                        
                        //回上一頁
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                } else {
                    print("failed")
                    print(err!)
                }
            }.resume()
        }
    }
    
    @IBAction func pressOrderButton(_ sender: UIButton) {
        sentOrderRequest()
    }
}
