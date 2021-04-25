

import Foundation
struct Meta : Codable {
	let code : Int?
	let success : Bool?
	let message : String?

	enum CodingKeys: String, CodingKey {

		case code = "code"
		case success = "success"
		case message = "message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		code = try values.decodeIfPresent(Int.self, forKey: .code)
		success = try values.decodeIfPresent(Bool.self, forKey: .success)
		message = try values.decodeIfPresent(String.self, forKey: .message)
	}

}
