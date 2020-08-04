//
//	ProductDetailsResponseData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ProductDetailsResponseData : NSObject, NSCoding, Mappable{

	var productDescription : String?
	var productId : String?
	var productImage : String?
	var productImages : [ProductDetailsProductImage]?
	var productName : String?
	var productPrice : String?
	var productRating : Int?
	var productReview : Int?
	var productSize : String?
	var productSpecialPrice : String?
	var productWeight : String?
	var relatedProduct : [ProductDetailsRelatedProduct]?
    var productWishlist : Int?

	class func newInstance(map: Map) -> Mappable?{
		return ProductDetailsResponseData()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		productDescription <- map["product_description"]
		productId <- map["product_id"]
		productImage <- map["product_image"]
		productImages <- map["product_images"]
		productName <- map["product_name"]
		productPrice <- map["product_price"]
		productRating <- map["product_rating"]
		productReview <- map["product_review"]
		productSize <- map["product_size"]
		productSpecialPrice <- map["product_special_price"]
		productWeight <- map["product_weight"]
		relatedProduct <- map["related_product"]
        productWishlist <- map["product_wishlist"]
        
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         productDescription = aDecoder.decodeObject(forKey: "product_description") as? String
         productId = aDecoder.decodeObject(forKey: "product_id") as? String
         productImage = aDecoder.decodeObject(forKey: "product_image") as? String
         productImages = aDecoder.decodeObject(forKey: "product_images") as? [ProductDetailsProductImage]
         productName = aDecoder.decodeObject(forKey: "product_name") as? String
         productPrice = aDecoder.decodeObject(forKey: "product_price") as? String
         productRating = aDecoder.decodeObject(forKey: "product_rating") as? Int
         productReview = aDecoder.decodeObject(forKey: "product_review") as? Int
         productSize = aDecoder.decodeObject(forKey: "product_size") as? String
         productSpecialPrice = aDecoder.decodeObject(forKey: "product_special_price") as? String
         productWeight = aDecoder.decodeObject(forKey: "product_weight") as? String
         relatedProduct = aDecoder.decodeObject(forKey: "related_product") as? [ProductDetailsRelatedProduct]

        productWishlist = aDecoder.decodeObject(forKey: "product_wishlist") as? Int
     
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
		if productId != nil{
			aCoder.encode(productId, forKey: "product_id")
		}
		if productImage != nil{
			aCoder.encode(productImage, forKey: "product_image")
		}
		if productImages != nil{
			aCoder.encode(productImages, forKey: "product_images")
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
		if productSize != nil{
			aCoder.encode(productSize, forKey: "product_size")
		}
		if productSpecialPrice != nil{
			aCoder.encode(productSpecialPrice, forKey: "product_special_price")
		}
		if productWeight != nil{
			aCoder.encode(productWeight, forKey: "product_weight")
		}
		if relatedProduct != nil{
			aCoder.encode(relatedProduct, forKey: "related_product")
		}
        if productWishlist != nil{
            aCoder.encode(productWishlist, forKey: "product_wishlist")
        }

	}

}
