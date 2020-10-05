//
//  SideMenuVC.swift
//  NirmanPro
//
//  Created by Joy Mondal on 12/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import KYDrawerController
import SDWebImage
class SideMenuVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageViewX!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var tableview: UITableView!
    //MARK: - UINavigationController declarations
       var navController: UINavigationController? = nil
    var mainArr = [String]()
    var mainImgArr = [String]()
    let itemArrWithID = ["Home","Category","Orders","Wishlist","Return Items","Profile","Address","About Us","Customer Service","Contact Us","Terms and Conditions","Privacy Policy","Logout"]
    let imgArrWithID = ["home","category","orders","wishlist","return","profile","gps","aboutUs","headphones","contactUs","term","privacy-policy","logout"]
    var intialTitleArr = ["Home","Category","Login/Sign Up","About Us","Customer Service","Contact Us","Terms and Conditions","Privacy Policy"]
    var initialImgArr = ["home","category","logout","aboutUs","headphones","contactUs","term","privacy-policy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        tableview.delegate = self
        tableview.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if Utils.getUserID() == ""{
            self.mainArr = self.intialTitleArr
            self.mainImgArr = self.initialImgArr
            self.profileImage.image = UIImage.init(named: "userPlaceholderImg")
            self.nameLbl.text = "Hello,Guest"
        }else{
            self.mainArr = self.itemArrWithID
            self.mainImgArr = self.imgArrWithID
            self.nameLbl.text = Utils.getUserName()
            self.profileImage.sd_setImage(with: URL(string: Utils.getUserImage().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "userPlaceholderImg"), options: .refreshCached) { (image, error, catcheType, imgURL) in
                           
                       }
        }
        self.tableview.reloadData()
    }
   
    
    func passTheDestinationController(identifier : String){
        var vcMainToGo = UIViewController()
    
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
            vcMainToGo = vc
            DispatchQueue.main.asyncAfter(deadline: .now()){
            NotificationCenter.default.post(name: NSNotification.Name(GoToVCNotificationKey), object: nil, userInfo: ["controller":vcMainToGo])
        }
        
        drawerController.setDrawerState(.closed, animated: true)
               
    }
    
}
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell
        cell.img.image = UIImage.init(named: mainImgArr[indexPath.row])
        cell.nameLbl.text = mainArr[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        drawerController = (navigationController?.parent as? KYDrawerController)!
        
        //ViewControllers Object Declarations:-
        let loginVC = STORYBOARD.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let homeVC = STORYBOARD.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        let item = mainArr[indexPath.row]
        if item == "Category"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "CategoryViewController")
        }
        if item == "Orders"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "MyOrdersViewController")
        }
        else if item == "Profile"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "ProfileViewController")
        }
        else if item == "Address"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "AddressListViewController")
        }
        else if item == "Wishlist"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "WishlistViewController")
            
        }
        else if item == "Return Items"{
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "ReturnListViewController")
            
        }
        else if item == "About Us"  {
            staticPageName = "aboutUs"
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "StaticPageViewController")
            
        }
        else if item == "Terms and Conditions" {
            staticPageName = "terms"
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "StaticPageViewController")
        }
        else if item  == "Privacy Policy"{
            staticPageName = "privacyPolicy"
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "StaticPageViewController")
        }
        else if  item == "Contact Us"{
            staticPageName = "contactUs"
            drawerController.setDrawerState(.closed, animated: true)
            passTheDestinationController(identifier: "StaticPageViewController")
        }
        else if item == "Login/Sign Up"{
           navController = UINavigationController(rootViewController: loginVC)
            drawerController.mainViewController = navController
            drawerController.setDrawerState(.closed, animated: true)
            
        }
        else if item == "Logout"{
            UserDefaults.standard.set(nil, forKey: USERID_KEY)
            UserDefaults.standard.set(nil, forKey: USERNAME_KEY)
            UserDefaults.standard.set(nil, forKey: PROFILEIMAGE_KEY)
            navController = UINavigationController(rootViewController: homeVC)
            drawerController.mainViewController = navController
            drawerController.setDrawerState(.closed, animated: true)
            
        }
    }
}
