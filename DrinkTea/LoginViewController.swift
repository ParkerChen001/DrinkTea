//
//  LoginViewController.swift
//  DrinkTea
//
//  Created by Parker Chen on 2021/4/29.
//

import UIKit

var userInfo = UserInfo(userName: "", userGroup: "", editCode: "")

class LoginViewController: UIViewController {

    @IBOutlet weak var lbOrdererName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let _ = segue.destination as? MenuViewController
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        if lbOrdererName.text?.isEmpty == true {
           let controller = UIAlertController(title: "名字未輸入", message: "請用英文名字輸入", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
           present(controller, animated: true, completion: nil)
        } else {
            userInfo.userName = lbOrdererName.text!
            performSegue(withIdentifier: "ToMenuVC", sender: sender)
        }
    }
}
