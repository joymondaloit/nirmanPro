//
//	HomeFeaturedProductResponseModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class HomeFeaturedProductResponseModel : NSObject, NSCoding, Mappable{

	var responseCode : Int?
	var responseData : [HomeFeaturedProductResponseData]?
	var responseText : String?
    var notificationCount : String?

	class func newInstance(map: Map) -> Mappable?{
		return HomeFeaturedProductResponseModel()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		responseCode <- map["responseCode"]
		responseData <- map["responseData"]
		responseText <- map["responseText"]
		notificationCount <- map["notificationCount"]
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         responseCode = aDecoder.decodeObject(forKey: "responseCode") as? Int
         responseData = aDecoder.decodeObject(forKey: "responseData") as? [HomeFeaturedProductResponseData]
         responseText = aDecoder.decodeObject(forKey: "responseText") as? String
        notificationCount = aDecoder.decodeObject(forKey: "notificationCount") as? String
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
		if responseData != nil{
			aCoder.encode(responseData, forKey: "responseData")
		}
		if responseText != nil{
			aCoder.encode(responseText, forKey: "responseText")
		}
        if notificationCount != nil{
            aCoder.encode(notificationCount, forKey: "notificationCount")
        }

	}

}
