//
//	RegisterResponseData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class RegisterResponseData : NSObject, NSCoding, Mappable{

	var customerId : String?
	var email : String?
	var firstname : String?
	var lastname : String?
	var telephone : String?


	class func newInstance(map: Map) -> Mappable?{
		return RegisterResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		customerId <- map["customer_id"]
		email <- map["email"]
		firstname <- map["firstname"]
		lastname <- map["lastname"]
		telephone <- map["telephone"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         customerId = aDecoder.decodeObject(forKey: "customer_id") as? String
         email = aDecoder.decodeObject(forKey: "email") as? String
         firstname = aDecoder.decodeObject(forKey: "firstname") as? String
         lastname = aDecoder.decodeObject(forKey: "lastname") as? String
         telephone = aDecoder.decodeObject(forKey: "telephone") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if customerId != nil{
			aCoder.encode(customerId, forKey: "customer_id")
		}
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if firstname != nil{
			aCoder.encode(firstname, forKey: "firstname")
		}
		if lastname != nil{
			aCoder.encode(lastname, forKey: "lastname")
		}
		if telephone != nil{
			aCoder.encode(telephone, forKey: "telephone")
		}

	}

}