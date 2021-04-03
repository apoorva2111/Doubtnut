/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class VideoListModel {
	public var question_id : String?
	public var ocr_text : String?
	public var question_image : String?
	public var matched_questions : Array<Matched_questions>?
	public var matched_count : Int?
	public var handwritten : Int?
	public var is_only_equation : Bool?
	public var is_exact_match : Bool?
	public var tab : Array<String>?
	public var notification : Array<String>?
	public var feedback : Feedback?
	public var platform_tabs : Array<Platform_tabs>?
	public var is_subscribed : Int?
	public var auto_play : Bool?
	public var auto_play_initiation : Int?
	public var auto_play_duration : Int?
	public var user_language_video_heading : String?
	public var other_language_video_heading : String?
	public var more_user_language_videos_text : String?
	public var cdn_video_base_url : String?
	public var is_blur : String?
	public var is_image_blur : Bool?
	public var is_image_handwritten : Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let json4Swift_Base_list = Json4Swift_Base.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Json4Swift_Base Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [VideoListModel]
    {
        var models:[VideoListModel] = []
        for item in array
        {
            models.append(VideoListModel(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let json4Swift_Base = Json4Swift_Base(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		question_id = dictionary["question_id"] as? String
		ocr_text = dictionary["ocr_text"] as? String
		question_image = dictionary["question_image"] as? String
        if (dictionary["matched_questions"] != nil) { matched_questions = Matched_questions.modelsFromDictionaryArray(array: dictionary["matched_questions"] as! NSArray) }
		matched_count = dictionary["matched_count"] as? Int
		handwritten = dictionary["handwritten"] as? Int
		is_only_equation = dictionary["is_only_equation"] as? Bool
		is_exact_match = dictionary["is_exact_match"] as? Bool
		//if (dictionary["tab"] != nil) { tab = tab.modelsFromDictionaryArray(dictionary["tab"] as! NSArray) }
		//if (dictionary["notification"] != nil) { notification = Notification.modelsFromDictionaryArray(dictionary["notification"] as! NSArray) }
		if (dictionary["feedback"] != nil) { feedback = Feedback(dictionary: dictionary["feedback"] as! NSDictionary) }
        if (dictionary["platform_tabs"] != nil) { platform_tabs = Platform_tabs.modelsFromDictionaryArray(array: dictionary["platform_tabs"] as! NSArray) }
		is_subscribed = dictionary["is_subscribed"] as? Int
		auto_play = dictionary["auto_play"] as? Bool
		auto_play_initiation = dictionary["auto_play_initiation"] as? Int
		auto_play_duration = dictionary["auto_play_duration"] as? Int
		user_language_video_heading = dictionary["user_language_video_heading"] as? String
		other_language_video_heading = dictionary["other_language_video_heading"] as? String
		more_user_language_videos_text = dictionary["more_user_language_videos_text"] as? String
		cdn_video_base_url = dictionary["cdn_video_base_url"] as? String
		is_blur = dictionary["is_blur"] as? String
		is_image_blur = dictionary["is_image_blur"] as? Bool
		is_image_handwritten = dictionary["is_image_handwritten"] as? Bool
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.question_id, forKey: "question_id")
		dictionary.setValue(self.ocr_text, forKey: "ocr_text")
		dictionary.setValue(self.question_image, forKey: "question_image")
		dictionary.setValue(self.matched_count, forKey: "matched_count")
		dictionary.setValue(self.handwritten, forKey: "handwritten")
		dictionary.setValue(self.is_only_equation, forKey: "is_only_equation")
		dictionary.setValue(self.is_exact_match, forKey: "is_exact_match")
		dictionary.setValue(self.feedback?.dictionaryRepresentation(), forKey: "feedback")
		dictionary.setValue(self.is_subscribed, forKey: "is_subscribed")
		dictionary.setValue(self.auto_play, forKey: "auto_play")
		dictionary.setValue(self.auto_play_initiation, forKey: "auto_play_initiation")
		dictionary.setValue(self.auto_play_duration, forKey: "auto_play_duration")
		dictionary.setValue(self.user_language_video_heading, forKey: "user_language_video_heading")
		dictionary.setValue(self.other_language_video_heading, forKey: "other_language_video_heading")
		dictionary.setValue(self.more_user_language_videos_text, forKey: "more_user_language_videos_text")
		dictionary.setValue(self.cdn_video_base_url, forKey: "cdn_video_base_url")
		dictionary.setValue(self.is_blur, forKey: "is_blur")
		dictionary.setValue(self.is_image_blur, forKey: "is_image_blur")
		dictionary.setValue(self.is_image_handwritten, forKey: "is_image_handwritten")

		return dictionary
	}

}
