

import Foundation
struct Feeddata : Codable {
	let widget_data : Widget_data?
	let widget_type : String?
	let layout_config : Layout_config?
	let order : Int?

	enum CodingKeys: String, CodingKey {

		case widget_data = "widget_data"
		case widget_type = "widget_type"
		case layout_config = "layout_config"
		case order = "order"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		widget_data = try values.decodeIfPresent(Widget_data.self, forKey: .widget_data)
		widget_type = try values.decodeIfPresent(String.self, forKey: .widget_type)
		layout_config = try values.decodeIfPresent(Layout_config.self, forKey: .layout_config)
		order = try values.decodeIfPresent(Int.self, forKey: .order)
	}

}
