//
//  CountryViewController.swift
//  NirmanPro
//
//  Created by Joy Mondal on 13/08/20.
//  Copyright © 2020 Joy Mondal. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countryTableView: UITableView!
    var countryDataArr = [CountryAllcountry]()
    var filterCountryData = [CountryAllcountry]()
    var delegate : CountryCallbackDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        filterCountryData = countryDataArr
        // Do any additional setup after loading the view.
    }
   
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CountryViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCountryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        if filterCountryData.count != 0
        {
            cell.countryName.text = filterCountryData[indexPath.row].name
        }
        else{
            cell.countryName.text = countryDataArr[indexPath.row].name
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapCountry(data: filterCountryData[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension CountryViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCountryData = searchText.isEmpty ? countryDataArr : countryDataArr.filter { $0.name!.contains(searchText) }
        countryTableView.reloadData()
    }
}

//MARK:-Protocol for country tap callback:-
protocol CountryCallbackDelegate {
    func didTapCountry(data : CountryAllcountry)
}
