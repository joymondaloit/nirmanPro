//
//  AddressViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 07/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import DropDown
import CountryPickerView
import SVProgressHUD

class AddressViewController: UIViewController {
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var companyTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var address1TF: UITextField!
    @IBOutlet weak var address2TF: UITextField!
    @IBOutlet weak var postalCodeTF: UITextField!
    @IBOutlet weak var saveBtn: UIButtonX!
    var commingFrom :String?
    var stateNameArr = [String]()
    var countryPickerView : CountryPickerView?
    var countryArr : [CountryAllcountry]?
    var stateArr :[StateData]?
    var stateID : String?
    var countryID : String?
    var addressData : AddressListResponseData!
    var isDefaultAddress = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        countryPickerView = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 14))
        countryPickerView!.delegate = self
        countryPickerView!.dataSource = self
        setup()
        getCountryList()
        if commingFrom == "update"{
            showData()
        }else{
            self.saveBtn.setTitle("SAVE", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    func setup(){
        firstNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your first name",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        lastNameTF.attributedPlaceholder = NSAttributedString(string: "Enter your last name",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        companyTF.attributedPlaceholder = NSAttributedString(string: "Enter your company name",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        countryTF.attributedPlaceholder = NSAttributedString(string: "Enter your country",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        cityTF.attributedPlaceholder = NSAttributedString(string: "Enter your city",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        stateTF.attributedPlaceholder = NSAttributedString(string: "Enter your state",
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        address1TF.attributedPlaceholder = NSAttributedString(string: "Enter your address line 1",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        address2TF.attributedPlaceholder = NSAttributedString(string: "Enter your address line 2",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        postalCodeTF.attributedPlaceholder = NSAttributedString(string: "Enter your postal code",
                                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func showData(){
        if let firstName = addressData.firstname {
            self.firstNameTF.text = firstName
        }
       if  let lastName = addressData.lastname{
        self.lastNameTF.text = lastName
        }
        if let address = addressData.address1{
            self.address1TF.text = address
        }
       if let address2 = addressData.address2{
         self.address2TF.text = address2
        }
        if let companyName = addressData.company{
            self.companyTF.text = companyName
        }
        if let city = addressData.city{
            self.cityTF.text = city
        }
        if let state = addressData.zone{
            self.stateTF.text = state
        }
        if let country = addressData.country{
            self.countryTF.text = country
        }
        if let postalCode = addressData.postcode{
            self.postalCodeTF.text = postalCode
        }
        if let defaultAddress = addressData.defaultAddress{
            self.isDefaultAddress = defaultAddress
        }
        self.saveBtn.setTitle("UPDATE", for: .normal)
        if let countryID = addressData.countryId{
            self.countryID = countryID
            self.stateArr?.removeAll()
            self.getStateList(countryID: countryID)
            
        }
        if let stateID = addressData.zoneId{
            self.stateID = stateID
        }
    }
    /**
     Method for DropDown Listing And selection:-
     */
    func showDropDownWithCallback(itemArr:[String],anchorView : UIView, completion :@escaping(String?,Int?)->()){
        let dropDown = DropDown()
        dropDown.backgroundColor = .white
        dropDown.textColor = .black
        dropDown.direction = .bottom
        dropDown.anchorView = anchorView // UIView or UIBarButtonItem
        dropDown.dataSource = itemArr
        dropDown.show()
        dropDown.selectionAction = {(index: Int, item: String) in
            completion(item,index)
        }
    }
    @IBAction func saveBtnAction(_ sender: Any) {
        let trimmedFirstName = firstNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastNameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCompanyName = companyTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = address1TF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCity = cityTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedState = stateTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCountry = countryTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPostalCode = postalCodeTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
           if trimmedFirstName.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your first name", vc: self)
           }
           else if trimmedLastName.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your last name", vc: self)
           }
           else if trimmedAddress.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your address", vc: self)
           }
           else if trimmedCompanyName.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your company name", vc: self)
           }
          
           else if trimmedCity.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your city", vc: self)
           }
           else if trimmedState.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your state", vc: self)
               
           }
           else if trimmedCountry.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your country name", vc: self)
           }
           else if trimmedPostalCode.count == 0{
               Utils.showAlert(alert: "", message: "Please enter your postal code", vc: self)
           }
           else if trimmedPostalCode.count < 6 {
               Utils.showAlert(alert: "", message: "Please enter a valid postal code", vc: self)
           }
           else{
               /**
                Save Address Api Call
                */
            if commingFrom == "update"{
                let apiName = DEV_BASE_URL+"address/addressUpdate"
                guard let addressID = addressData.addressId else {
                    return
                }
                let param:[String:Any] = ["address_id" :addressID,
                                          "customer_id": Utils.getUserID(),
                                          "firstname":firstNameTF.text!,
                                          "lastname":lastNameTF.text!,
                                          "address_1":address1TF.text!,
                                          "address_2":address2TF.text!,
                                          "company":companyTF.text!,
                                          "city":cityTF.text!,
                                          "postcode":postalCodeTF.text!,
                                          "country_id":self.countryID!,
                                          "state_id":self.stateID!,
                                          "default_address": self.isDefaultAddress]
                self.saveAddress(apiName: apiName, param: param)
            }else{
                 let apiName = DEV_BASE_URL+"address/addressAdd"
                let param:[String:Any] = ["customer_id": Utils.getUserID(),
                                          "firstname":firstNameTF.text!,
                                          "lastname":lastNameTF.text!,
                                          "address_1":address1TF.text!,
                                          "address_2":address2TF.text!,
                                          "company":companyTF.text!,
                                          "city":cityTF.text!,
                                          "postcode":postalCodeTF.text!,
                                          "country_id":self.countryID!,
                                          "state_id":self.stateID!,
                                          "default_address": self.isDefaultAddress]
                self.saveAddress(apiName: apiName, param: param)

            }
               
           }
        
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
       }
    @IBAction func stateSelectBtnAction(_ sender: Any) {
        if let stateArr = stateArr{
            self.showDropDownWithCallback(itemArr: self.stateNameArr, anchorView: sender as! UIButton) { (item, index) in
                self.stateID = stateArr[index!].id
                print("Selected State \(stateArr[index!].name!) with ID \(stateArr[index!].id!)")
                self.stateTF.text = stateArr[index!].name!
            }
        }else{
            Utils.showAlert(alert: "", message: "Please select country first", vc: self)
        }
    }
    
    @IBAction func countrySelectBtnAction(_ sender: Any) {
        //countryPickerView?.showCountriesList(from: self)
        let countryVC = STORYBOARD.instantiateViewController(withIdentifier: "CountryViewController") as! CountryViewController
        if let countryArr = self.countryArr{
            countryVC.countryDataArr = countryArr
            countryVC.delegate = self
            self.navigationController?.pushViewController(countryVC, animated: true)
        }else{
            Utils.showAlert(alert: "", message: "No country list found please try again", vc: self)
        }
    }
}
//MARK: Country Picker Delegate;-
extension AddressViewController : CountryPickerViewDelegate,CountryPickerViewDataSource{
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        let countryName = country.name.lowercased()
        if let index = countryArr?.firstIndex(where: {$0.name?.lowercased() == countryName}){
            self.countryID = countryArr![index].id
            self.countryTF.text = countryName.uppercased()
            print("Selected Country \(countryName) with ID \(self.countryID!)")
            self.stateArr?.removeAll()
            self.getStateList(countryID: self.countryID!)
        }
        
        
    }
    
    
}

extension AddressViewController : CountryCallbackDelegate{
    func didTapCountry(data: CountryAllcountry) {
        self.countryID = data.id
        self.countryTF.text = data.name?.uppercased()
        print("Selected Country \(data.name!.uppercased()) with ID \(self.countryID!)")
        self.stateArr?.removeAll()
        self.stateTF.text = ""
        self.getStateList(countryID: self.countryID!)
    }
    
    
}
//MARK:- Api Call:-
extension AddressViewController{
    func getCountryList(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/countryList"
        let param : [String:Any] = ["customer_id" : Utils.getUserID()]
        AddressViewModel.shared.getCountryList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        if response.allcountry!.count > 0{
                            self.countryArr = response.allcountry!
                            
                        }else{
                            self.countryArr = []
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func getStateList(countryID : String){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/stateList"
        let param:[String:Any] = ["country_id" : countryID]
        AddressViewModel.shared.getStateList(apiName: apiName, param: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response.responseCode == 1{
                        self.stateNameArr.removeAll()
                        if response.data!.count > 0{
                            self.stateArr = response.data!
                            for item in self.stateArr!{
                                self.stateNameArr.append(item.name!)
                            }
                            
                        }else{
                            
                        }
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
            
        }
    }
    
    func saveAddress(apiName : String, param: [String:Any]){
        SVProgressHUD.show()
        AlamofireManager.sharedInstance.postRequest(apiname: apiName, params: param, vc: self) { (response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                        Utils.showAlertWithCallbackOneAction(alert: "", message: response["responseText"] as! String, vc: self, completion: {
                            self.navigationController?.popViewController(animated: true)
                           })
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }
        }
    }
}
