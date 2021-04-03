/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class _source {
	public var ocr_text : String?
	public var is_answered : Int?
	public var is_text_answered : Int?
	public var subject : String?
	public var chapter : String?
	public var chapter_alias : String?
	public var student_id : Int?
	public var classs : String?
	public var video_language : String?
	public var package_language : String?
	public var exact_match : Bool?
	public var views : Int?
	public var likes : Int?
	public var share : Int?
	public var duration : String?
	public var share_message : String?
	public var bg_color : String?
	public var isLiked : Bool?
	public var katex_ocr_text : String?
	public var render_katex : Bool?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let _source_list = _source.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of _source Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [_source]
    {
        var models:[_source] = []
        for item in array
        {
            models.append(_source(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let _source = _source(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: _source Instance.
*/
	required public init?(dictionary: NSDictionary) {

		ocr_text = dictionary["ocr_text"] as? String
		is_answered = dictionary["is_answered"] as? Int
		is_text_answered = dictionary["is_text_answered"] as? Int
		subject = dictionary["subject"] as? String
		chapter = dictionary["chapter"] as? String
		chapter_alias = dictionary["chapter_alias"] as? String
		student_id = dictionary["student_id"] as? Int
		classs = dictionary["class"] as? String
		video_language = dictionary["video_language"] as? String
		package_language = dictionary["package_language"] as? String
		exact_match = dictionary["exact_match"] as? Bool
		views = dictionary["views"] as? Int
		likes = dictionary["likes"] as? Int
		share = dictionary["share"] as? Int
		duration = dictionary["duration"] as? String
		share_message = dictionary["share_message"] as? String
		bg_color = dictionary["bg_color"] as? String
		isLiked = dictionary["isLiked"] as? Bool
		katex_ocr_text = dictionary["katex_ocr_text"] as? String
		render_katex = dictionary["render_katex"] as? Bool
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.ocr_text, forKey: "ocr_text")
		dictionary.setValue(self.is_answered, forKey: "is_answered")
		dictionary.setValue(self.is_text_answered, forKey: "is_text_answered")
		dictionary.setValue(self.subject, forKey: "subject")
		dictionary.setValue(self.chapter, forKey: "chapter")
		dictionary.setValue(self.chapter_alias, forKey: "chapter_alias")
		dictionary.setValue(self.student_id, forKey: "student_id")
		dictionary.setValue(self.classs, forKey: "class")
		dictionary.setValue(self.video_language, forKey: "video_language")
		dictionary.setValue(self.package_language, forKey: "package_language")
		dictionary.setValue(self.exact_match, forKey: "exact_match")
		dictionary.setValue(self.views, forKey: "views")
		dictionary.setValue(self.likes, forKey: "likes")
		dictionary.setValue(self.share, forKey: "share")
		dictionary.setValue(self.duration, forKey: "duration")
		dictionary.setValue(self.share_message, forKey: "share_message")
		dictionary.setValue(self.bg_color, forKey: "bg_color")
		dictionary.setValue(self.isLiked, forKey: "isLiked")
		dictionary.setValue(self.katex_ocr_text, forKey: "katex_ocr_text")
		dictionary.setValue(self.render_katex, forKey: "render_katex")

		return dictionary
	}

}
