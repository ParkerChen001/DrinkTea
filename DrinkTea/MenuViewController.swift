//
//  ViewController.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/26.
//

import UIKit

//    .KEY :   Authorization
//    .VALUE : Bearer keyJwOeIJCiHwYAjg
public let apiKey = "keyJwOeIJCiHwYAjg"

var selectedDrinkRecord: Record?

class MenuViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var drinkSelect: UIScrollView!
    @IBOutlet weak var lbWelcome: UILabel!
    @IBOutlet weak var lbIntroDrinkName: UILabel!
    @IBOutlet weak var lbIntroDrinkDesc: UILabel!
    var loadingActivityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var btnImgSelectDrink: [UIButton]!{
        didSet {
            btnImgSelectDrink.sort { $0.tag < $1.tag }
        }
    }
        
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    var menuData = Array<Record>()
    let urlStr = "https://api.airtable.com/v0/appxguA4PpPvT0drU/DrinkMenu"
    
    var picSection: [Int] = [205, 405, 605, 805, 1005, 1205, 1405, 1605, 1805, 2005,
                             2205, 2405, 2605, 2805, 9999]

    let defaultIntroDrinkName = "熟成紅茶"
    let defaultIntroDrinkDesc = "木質帶熟果香調的風味，流露熟齡男子的沈穩氣息，低調而迷人。嚴選自斯里蘭卡產區之茶葉，帶有濃郁果香及醇厚桂圓香氣；與肉類料理一同品嚐，得以化解舌尖上所殘留的油膩感。"
    let defaultDrinkImageArray: [String] = ["list01熟成紅茶", "list02麗春紅茶"]
    var IntroDrinkNameStr = Array<String>()
    var IntroDrinkDescStr = Array<String>()

    var selectDrink = 0
    var selectTemp = 0
    var picShow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //預設資料
        selectDrink = 0
        drinkSelect.delegate = self
        //pre-load the menu text and picture for avoid the waiting internet data
        lbIntroDrinkName.text = defaultIntroDrinkName
        lbIntroDrinkDesc.text = defaultIntroDrinkDesc
        btnImgSelectDrink[0].setBackgroundImage(UIImage(named: defaultDrinkImageArray[0]), for: .normal)
        btnImgSelectDrink[1].setBackgroundImage(UIImage(named: defaultDrinkImageArray[1]), for: .normal)
    }
    
    func showDrinkIntroduction(updateDrink: Int) {
        lbIntroDrinkName.text = IntroDrinkNameStr[updateDrink]
        lbIntroDrinkDesc.text = IntroDrinkDescStr[updateDrink]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        lbWelcome.text = "Dear, " + userInfo.userName
        fetchMenuData(urlStr: urlStr) { (menuData) in
        }
        //when button change need to scroll view back to left (begin) side
        drinkSelect.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: 下載菜單
    func fetchMenuData(urlStr: String, completionHandler: @escaping ([Record]?) -> Void) {
        
        let url = URL(string: urlStr)
        //start indicator
        self.myActivityIndicator.startAnimating()
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "Get"
        urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let result = try decoder.decode(ResponseData.self, from: data)
                    
                    // 將 Menu資料陣列依 sort排序
                    let records = result.records.sorted {
                        $0.fields.sort < $1.fields.sort
                    }
                    self.menuData = records
                    
                    completionHandler(result.records)
                    DispatchQueue.main.async {
                        //stop indicator
                        self.myActivityIndicator.stopAnimating()
                        
                        //load the scroll view drink image
                        self.showScrollViewDrinkImage(picShow: self.picShow)
                        
                        //load the intro drink name into array
                        self.menuData.forEach { record in
                            self.IntroDrinkNameStr.append(record.fields.drinkName)
                            self.IntroDrinkDescStr.append(record.fields.drinkDesc)
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _ = segue.destination as? PickDetailViewController
        if let button = sender as? UIButton {
            selectedDrinkRecord = menuData[button.tag]
        }
    }
    
    @IBAction func selectButton(_ sender: UIButton) {
        performSegue(withIdentifier: "ToPickDetailVC", sender: sender)
    }
    
    func showScrollViewDrinkImage(picShow: Int) {
        var i = 0
        for btnImg in btnImgSelectDrink {

            if let urlStr = URL(string: menuData[i].fields.imageURL) {
                URLSession.shared.dataTask(with: urlStr) { (data, response, error) in
                    if let data = data {
                        DispatchQueue.main.async {
                            // 得到圖片
                            if let image = UIImage(data: data){
                                btnImg.setBackgroundImage(image, for: .normal)
                            }
                        }
                    }
                }.resume()
            }
            i += 1
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectTemp = 0
        for i in 0..<picSection.count {
            if Int(scrollView.contentOffset.x) <= picSection[i] {
                selectTemp = i
                break
            }
        }
        if selectDrink != selectTemp {
            selectDrink = selectTemp
            showDrinkIntroduction(updateDrink: selectDrink)
        }
    }
}

