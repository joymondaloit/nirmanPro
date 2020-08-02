//
//	Wishlist.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Wishlist : NSObject, NSCoding, Mappable{

	var productDescription : String?
	var productImage : String?
	var productName : String?
	var productPrice : String?
	var productRating : String?
	var productReview : String?
	var productSpecialPrice : String?
    var productID : String?

	class func newInstance(map: Map) -> Mappable?{
		return Wishlist()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		productDescription <- map["product_description"]
		productImage <- map["product_image"]
		productName <- map["product_name"]
		productPrice <- map["product_price"]
		productRating <- map["product_rating"]
		productReview <- map["product_review"]
		productSpecialPrice <- map["product_special_price"]
		productID <- map["product_id"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         productDescription = aDecoder.decodeObject(forKey: "product_description") as? String
         productImage = aDecoder.decodeObject(forKey: "product_image") as? String
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
         productRating = aDecoder.decodeObject(forKey: "product_rating") as? String
         productReview = aDecoder.decodeObject(forKey: "product_review") as? String
         productSpecialPrice = aDecoder.decodeObject(forKey: "product_special_price") as? String
        productID = aDecoder.decodeObject(forKey: "product_id") as? String
	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if productDescription != nil{
			aCoder.encode(productDescription, forKey: "product_description")
		}
		if productImage != nil{
			aCoder.encode(productImage, forKey: "product_image")
		}
		if productName != nil{
			aCoder.encode(productName, forKey: "product_name")
		}
		if productPrice != nil{
			aCoder.encode(productPrice, forKey: "product_price")
		}
		if productRating != nil{
			aCoder.encode(productRating, forKey: "product_rating")
		}
		if productReview != nil{
			aCoder.encode(productReview, forKey: "product_review")
		}
		if productSpecialPrice != nil{
			aCoder.encode(productSpecialPrice, forKey: "product_special_price")
		}
        if productID != nil{
            aCoder.encode(productID, forKey: "product_id")
        }
	}

}
