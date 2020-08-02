//
//	CartItemsResponseData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CartItemsResponseData : NSObject, NSCoding, Mappable{

	var cartId : String?
	var productDescription : String?
	var productImage : String?
	var productName : String?
	var productPrice : String?
	var productQuantity : String?
	var productSpecialPrice : String?


	class func newInstance(map: Map) -> Mappable?{
		return CartItemsResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		cartId <- map["cart_id"]
		productDescription <- map["product_description"]
		productImage <- map["product_image"]
		productName <- map["product_name"]
		productPrice <- map["product_price"]
		productQuantity <- map["product_quantity"]
		productSpecialPrice <- map["product_special_price"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cartId = aDecoder.decodeObject(forKey: "cart_id") as? String
         productDescription = aDecoder.decodeObject(forKey: "product_description") as? String
         productImage = aDecoder.decodeObject(forKey: "product_image") as? String
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
         productQuantity = aDecoder.decodeObject(forKey: "product_quantity") as? String
         productSpecialPrice = aDecoder.decodeObject(forKey: "product_special_price") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cartId != nil{
			aCoder.encode(cartId, forKey: "cart_id")
		}
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
		if productQuantity != nil{
			aCoder.encode(productQuantity, forKey: "product_quantity")
		}
		if productSpecialPrice != nil{
			aCoder.encode(productSpecialPrice, forKey: "product_special_price")
		}

	}

}