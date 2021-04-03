/* 
Copyright (c) 2021 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Matched_questions {
	public var _index : String?
	public var _type : String?
	public var _id : String?
	public var _score : Double?
	public var _source : _source?
	public var partial_score : Int?
	public var string_diff_text : String?
	public var string_diff_text_bg_color : String?
	public var resource_type : String?
	public var answer_id : Int?
	public var answer_video : String?
	public var html : String?
	public var question_thumbnail : String?
	public var classs : String?
	public var chapter : String?
	public var difficulty_level : String?
	public var video_url : String?
	public var cdn_base_url : String?
	public var fallback_url : String?
	public var hls_timeout : Int?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let matched_questions_list = Matched_questions.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Matched_questions Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Matched_questions]
    {
        var models:[Matched_questions] = []
        for item in array
        {
            models.append(Matched_questions(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let matched_questions = Matched_questions(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Matched_questions Instance.
*/
	required public init?(dictionary: NSDictionary) {

		_index = dictionary["_index"] as? String
		_type = dictionary["_type"] as? String
		_id = dictionary["_id"] as? String
		_score = dictionary["_score"] as? Double
        if (dictionary["_source"] != nil) { _source = DoubtNut._source(dictionary: dictionary["_source"] as! NSDictionary) }
		partial_score = dictionary["partial_score"] as? Int
		string_diff_text = dictionary["string_diff_text"] as? String
		string_diff_text_bg_color = dictionary["string_diff_text_bg_color"] as? String
		resource_type = dictionary["resource_type"] as? String
		answer_id = dictionary["answer_id"] as? Int
		answer_video = dictionary["answer_video"] as? String
		html = dictionary["html"] as? String
		question_thumbnail = dictionary["question_thumbnail"] as? String
		classs = dictionary["class"] as? String
		chapter = dictionary["chapter"] as? String
		difficulty_level = dictionary["difficulty_level"] as? String
		video_url = dictionary["video_url"] as? String
		cdn_base_url = dictionary["cdn_base_url"] as? String
		fallback_url = dictionary["fallback_url"] as? String
		hls_timeout = dictionary["hls_timeout"] as? Int
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self._index, forKey: "_index")
		dictionary.setValue(self._type, forKey: "_type")
		dictionary.setValue(self._id, forKey: "_id")
		dictionary.setValue(self._score, forKey: "_score")
		dictionary.setValue(self._source?.dictionaryRepresentation(), forKey: "_source")
		dictionary.setValue(self.partial_score, forKey: "partial_score")
		dictionary.setValue(self.string_diff_text, forKey: "string_diff_text")
		dictionary.setValue(self.string_diff_text_bg_color, forKey: "string_diff_text_bg_color")
		dictionary.setValue(self.resource_type, forKey: "resource_type")
		dictionary.setValue(self.answer_id, forKey: "answer_id")
		dictionary.setValue(self.answer_video, forKey: "answer_video")
		dictionary.setValue(self.html, forKey: "html")
		dictionary.setValue(self.question_thumbnail, forKey: "question_thumbnail")
		dictionary.setValue(self.classs, forKey: "class")
		dictionary.setValue(self.chapter, forKey: "chapter")
		dictionary.setValue(self.difficulty_level, forKey: "difficulty_level")
		dictionary.setValue(self.video_url, forKey: "video_url")
		dictionary.setValue(self.cdn_base_url, forKey: "cdn_base_url")
		dictionary.setValue(self.fallback_url, forKey: "fallback_url")
		dictionary.setValue(self.hls_timeout, forKey: "hls_timeout")

		return dictionary
	}

}
