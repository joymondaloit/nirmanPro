//
//  EditProfileViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 20/07/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
class ProfileViewController: UIViewController {

    
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var profileImg: UIImageViewX!
    var profileImgPicker : UIImagePickerController!
    var imageArr = [UIImage]()
    var userData : FetchUserResponseData?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goToSelectedVC), name: Notification.Name(GoToVCNotificationKey), object: nil)
         
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchUserData()
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

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func editImageAction(_ sender: Any) {
        self.openImagePickerForSelection()
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        let changePasswordVC = STORYBOARD.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        self.navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    @IBAction func editProfileAction(_ sender: Any) {
        let editProfileVC = STORYBOARD.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        editProfileVC.userData = userData!
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        Utils.showAlertWithCallback(alert: "Logout", message: "Are you sure you want to logout?", vc: self) {
            UserDefaults.standard.set(nil, forKey: USERID_KEY)
            UserDefaults.standard.set(nil, forKey: USERNAME_KEY)
            UserDefaults.standard.set(nil, forKey: PROFILEIMAGE_KEY)
            Utils.goToTheDestinationVC(identifier: "HomeViewController")
        }
    }
}

//MARK:-Api Call:-
extension ProfileViewController{
    func fetchUserData(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/fetch_data"
        let param :[String: Any] = ["user_id" : Utils.getUserID()]
        ProfileViewModel.shared.fetchUserData(apiName: apiName, param: param, vc: self) { (response, error) in
            if let error = error{
                SVProgressHUD.dismiss()
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                SVProgressHUD.dismiss()
                if let response = response{
                    if response.responseCode == 1{
                        self.userData = response.responseData!
                        self.showUserData(data: response.responseData!)
                    }else{
                        Utils.showAlert(alert: "", message: response.responseText!, vc: self)
                    }
                }
            }
        }
    }
    func showUserData(data : FetchUserResponseData){
        if let firstName = data.firstname{
            self.firstNameLbl.text = firstName
        }
        if let lastname = data.lastname{
            self.lastNameLbl.text = lastname
        }
        if let phoneNumber = data.telephone{
            self.phoneNumberLbl.text = phoneNumber
        }
        if let email = data.email{
            self.emailLbl.text = email
        }
        if let profileImg = data.image{
            UserDefaults.standard.set(profileImg, forKey: PROFILEIMAGE_KEY)
            self.profileImg.sd_setImage(with: URL(string: profileImg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage.init(named: "userPlaceholderImg"), options: .refreshCached) { (image, error, catcheType, imgURL) in
                
            }
        }else{
            profileImg.image = UIImage.init(named: "userPlaceholderImg")
        }
    }
    func uploadImage(){
        SVProgressHUD.show()
        let apiName = DEV_BASE_URL+"customer/update_profile_image"
        let param :[String: Any] = ["user_id" : Utils.getUserID()]
        AlamofireManager.sharedInstance.uploadFile(imageArr: self.imageArr, to: apiName, params: param, withName: "image", filename: "NirmanProProfileImage.png") {(response, error) in
            SVProgressHUD.dismiss()
            if let error = error{
                Utils.showAlert(alert: "", message: error.localizedDescription, vc: self)
            }else{
                if let response = response{
                    if response["responseCode"] as! Int == 1{
                      
                    }else{
                        Utils.showAlert(alert: "", message: response["responseText"] as! String, vc: self)
                    }
                }
            }}
    }
}

// MARK:- Image Picker Delegate Extension
extension ProfileViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    func openImagePickerForSelection() -> Void
    {
        let selectPhoto : UIAlertController = UIAlertController(title: "Update Your Profile Picture", message: "This will be displayed to all the customers", preferredStyle: UIAlertController.Style.actionSheet)
        if !UIImagePickerController.isSourceTypeAvailable(.camera) // Not A Real Device
        {
            print("Camera Not Availble for the Simulator")
        }
        else // Real Device
        {
            let cameraPicker : UIAlertAction = UIAlertAction(title: "Take a Snap", style: UIAlertAction.Style.default, handler: {
                (alert: UIAlertAction!) in
                self.openCamera()
            })
            selectPhoto.addAction(cameraPicker)
        }
        let chooseFromGallery : UIAlertAction = UIAlertAction(title: "Choose From Gallery", style: UIAlertAction.Style.default, handler: {
            (alert: UIAlertAction!) in
            self.openGallery()
        })
        
        let cancel : UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            (alert: UIAlertAction!) in
            // Nothing Just it will Automatically dismiss the Action Sheet
        })
        
        selectPhoto.addAction(chooseFromGallery)
        selectPhoto.addAction(cancel)
        self.present(selectPhoto, animated:true, completion: nil)
    }
    
    func openGallery()
    {
        // Setting Up The Profile Image Picker Delegate
        profileImgPicker = UIImagePickerController()
        profileImgPicker.delegate = self
        profileImgPicker.sourceType = .photoLibrary
        profileImgPicker.allowsEditing = true
        self.present(profileImgPicker, animated: true, completion: nil)
    }
    func openCamera()
    {
        profileImgPicker = UIImagePickerController()
        profileImgPicker.delegate = self
        profileImgPicker.sourceType = .camera
        profileImgPicker.allowsEditing = true
        self.present(profileImgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        self.imageArr.removeAll()
        if let image = info[.originalImage] as? UIImage // Original Image
        {
            self.profileImg.image = image
            self.imageArr.append(image)
            self.uploadImage()
        }
       
        
        self.profileImgPicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.profileImgPicker.dismiss(animated: true, completion: nil)
    }
}
