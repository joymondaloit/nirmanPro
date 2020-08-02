//
//  MyOrdersViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 17/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class MyOrdersViewController: UIViewController {

    @IBOutlet weak var ordersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ordersTableView.rowHeight = UITableView.automaticDimension
        ordersTableView.estimatedRowHeight = 2000
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectedVC), name: Notification.Name(GoToVCNotificationKey), object: nil)
      
        // Do any additional setup after loading the view.
    }
    
    @objc func goToSelectedVC(notification : Notification){
        if let controller = notification.userInfo?["controller"] as? UIViewController{
            if self.isViewLoaded && (self.view.window != nil)
            {
                self.navigationController?.pushViewController(controller, animated: true)
                // NotificationCenter.default.removeObserver(self, name: Notification.Name(GoToVCNotificationKey), object: nil)
            }
        }
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension MyOrdersViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrdersCell") as! MyOrdersCell
        return cell
    }
    
    
}
