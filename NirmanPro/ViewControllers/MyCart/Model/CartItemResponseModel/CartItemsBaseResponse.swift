//
//	CartItemsBaseResponse.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CartItemsBaseResponse : NSObject, NSCoding, Mappable{

	var cartTotalAmount : String?
	var responseCode : Int?
	var responseData : [CartItemsResponseData]?
	var responseText : String?
	var shippingCharge : String?


	class func newInstance(map: Map) -> Mappable?{
		return CartItemsBaseResponse()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		cartTotalAmount <- map["cart_total_amount"]
		responseCode <- map["responseCode"]
		responseData <- map["responseData"]
		responseText <- map["responseText"]
		shippingCharge <- map["shipping_charge"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         cartTotalAmount = aDecoder.decodeObject(forKey: "cart_total_amount") as? String
         responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
         responseData = aDecoder.decodeObject(forKey: "responseData") as? [CartItemsResponseData]
         responseText = aDecoder.decodeObject(forKey: "responseText") as? String
         shippingCharge = aDecoder.decodeObject(forKey: "shipping_charge") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if cartTotalAmount != nil{
			aCoder.encode(cartTotalAmount, forKey: "cart_total_amount")
		}
		if responseCode != nil{
			aCoder.encode(responseCode, forKey: "responseCode")
		}
		if responseData != nil{
			aCoder.encode(responseData, forKey: "responseData")
		}
		if responseText != nil{
			aCoder.encode(responseText, forKey: "responseText")
		}
		if shippingCharge != nil{
			aCoder.encode(shippingCharge, forKey: "shipping_charge")
		}

	}

}