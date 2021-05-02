//
//  OrderListViewController.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/28.
//

import UIKit

class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderListTableView: UITableView!
    @IBOutlet weak var lbTotalCups: UILabel!
    @IBOutlet weak var lbTotalPrice: UILabel!
    @IBOutlet weak var orderListActivityIndicator: UIActivityIndicatorView!
    
    let urlStr = "https://api.airtable.com/v0/appxguA4PpPvT0drU/OrderRecords"
    var orderLists = [DrinkRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("enter viewWillAppear")
        updateUI()
    }
    
    func updateUI() {
        print("updateUI")

        // get drinkOrder Data
        fetchOrderListData(urlStr: urlStr) { (orderData) in
            print("fetch success")
            guard let orderData = orderData else { return }
            self.orderLists = orderData
            
            DispatchQueue.main.async {
                print("enter main queue")
                self.orderListActivityIndicator.stopAnimating()
                self.orderListTableView.reloadData()
                self.lbTotalCups.text = "共計 \(self.orderLists.count)杯"
                self.lbTotalPrice.text = "$\(self.computeTotal())"
            }
        }
    }
    
    func computeTotal() -> Int {
        var result: Int = 0
        self.orderLists.forEach { record in
            result += record.fields.drinkPrice
        }
        return result
    }
    
    // MARK: Fetch DrinkOrder Data
    func fetchOrderListData(urlStr: String, completionHandler: @escaping ([DrinkRecord]?) -> Void) {
        print("fetch data...")
        if let url = URL(string: urlStr) {
            self.orderListActivityIndicator.startAnimating()
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "Get"
            urlRequest.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                let decoder = JSONDecoder()
                if let data = data {
                    do {
                        let result = try decoder.decode(OrderRecords.self, from: data)

                        // 將訂單資料陣列依建立時間排序
                        let records = result.records.sorted {
                            $0.createdTime < $1.createdTime
                        }
                        print("decode success")
                        completionHandler(records)
                    } catch {
                        completionHandler(nil)
                        print(error)
                    }
                }
            }.resume()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemCell", for: indexPath) as? OrderItemCell else { return UITableViewCell() }
        let orderList = orderLists[indexPath.row].fields
        cell.ivDrinkThumb.image = UIImage(named: "list01熟成紅茶")
        cell.lbDrinkName.text = orderList.drinkName
        cell.lbDrinkOptions.text = orderList.drinkSize + "、" + orderList.drinkSugar + "、" + orderList.drinkTemp + "、" + orderList.drinkAddon
        cell.lbOrdererName.text = orderList.ordererName
        cell.lbDrinkPrice.text = "$" + String(orderList.drinkPrice)
        
        return cell
    }
}
