//
//	HomeFeaturedProductResponseData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class HomeFeaturedProductResponseData : NSObject, NSCoding, Mappable{

	var productId : String?
	var productImage : String?
	var productName : String?
	var productPrice : String?
	var productRating : Int?
	var productSpecialPrice : String?
    var productWishlist : Int?

	class func newInstance(map: Map) -> Mappable?{
		return HomeFeaturedProductResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		productId <- map["product_id"]
		productImage <- map["product_image"]
		productName <- map["product_name"]
		productPrice <- map["product_price"]
		productRating <- map["product_rating"]
		productSpecialPrice <- map["product_special_price"]
		productWishlist <- map["product_wishlist"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         productId = aDecoder.decodeObject(forKey: "product_id") as? String
         productImage = aDecoder.decodeObject(forKey: "product_image") as? String
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
         productRating = aDecoder.decodeObject(forKey: "product_rating") as? Int
         productSpecialPrice = aDecoder.decodeObject(forKey: "product_special_price") as? String
        productWishlist = aDecoder.decodeObject(forKey: "product_wishlist") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
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
		if productSpecialPrice != nil{
			aCoder.encode(productSpecialPrice, forKey: "product_special_price")
		}
        if productWishlist != nil{
            aCoder.encode(productWishlist, forKey: "product_wishlist")
        }
	}

}
