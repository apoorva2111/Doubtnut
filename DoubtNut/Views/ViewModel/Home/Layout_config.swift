

import Foundation
struct Layout_config : Codable {
	let margin_top : Int?
	let bg_color : String?

	enum CodingKeys: String, CodingKey {

		case margin_top = "margin_top"
		case bg_color = "bg_color"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		margin_top = try values.decodeIfPresent(Int.self, forKey: .margin_top)
		bg_color = try values.decodeIfPresent(String.self, forKey: .bg_color)
	}

}
