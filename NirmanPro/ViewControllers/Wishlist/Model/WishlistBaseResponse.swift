//
//	WishlistBaseResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class WishlistBaseResponse : NSObject, NSCoding, Mappable{

	var responseCode : Int?
	var responseText : String?
	var wishlist : [Wishlist]?


	class func newInstance(map: Map) -> Mappable?{
		return WishlistBaseResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		responseCode <- map["responseCode"]
		responseText <- map["responseText"]
		wishlist <- map["wishlist"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
         responseText = aDecoder.decodeObject(forKey: "responseText") as? String
         wishlist = aDecoder.decodeObject(forKey: "wishlist") as? [Wishlist]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if responseCode != nil{
			aCoder.encode(responseCode, forKey: "responseCode")
		}
		if responseText != nil{
			aCoder.encode(responseText, forKey: "responseText")
		}
		if wishlist != nil{
			aCoder.encode(wishlist, forKey: "wishlist")
		}

	}

}