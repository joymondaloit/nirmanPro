//
//	ProductDetailsProductImage.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ProductDetailsProductImage : NSObject, NSCoding, Mappable{

	var image : String?


	class func newInstance(map: Map) -> Mappable?{
		return ProductDetailsProductImage()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		image <- map["image"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         image = aDecoder.decodeObject(forKey: "image") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if image != nil{
			aCoder.encode(image, forKey: "image")
		}

	}

}