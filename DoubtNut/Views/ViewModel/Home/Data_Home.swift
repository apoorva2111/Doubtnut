

import Foundation
struct Data_Home : Codable {
	let feeddata : [Feeddata]?
	let offsetCursor : String?

	enum CodingKeys: String, CodingKey {

		case feeddata = "feeddata"
		case offsetCursor = "offsetCursor"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		feeddata = try values.decodeIfPresent([Feeddata].self, forKey: .feeddata)
		offsetCursor = try values.decodeIfPresent(String.self, forKey: .offsetCursor)
	}

}
