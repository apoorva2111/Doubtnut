

import Foundation
struct Items : Codable {
	let title : String?
	let subtitle : String?
	let show_whatsapp : Bool?
	let show_video : Bool?
	let image_url : String?
	let card_width : String?
	let aspect_ratio : String?
	let deeplink : String?
	let id : Int?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case subtitle = "subtitle"
		case show_whatsapp = "show_whatsapp"
		case show_video = "show_video"
		case image_url = "image_url"
		case card_width = "card_width"
		case aspect_ratio = "aspect_ratio"
		case deeplink = "deeplink"
		case id = "id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		subtitle = try values.decodeIfPresent(String.self, forKey: .subtitle)
		show_whatsapp = try values.decodeIfPresent(Bool.self, forKey: .show_whatsapp)
		show_video = try values.decodeIfPresent(Bool.self, forKey: .show_video)
		image_url = try values.decodeIfPresent(String.self, forKey: .image_url)
		card_width = try values.decodeIfPresent(String.self, forKey: .card_width)
		aspect_ratio = try values.decodeIfPresent(String.self, forKey: .aspect_ratio)
		deeplink = try values.decodeIfPresent(String.self, forKey: .deeplink)
		id = try values.decodeIfPresent(Int.self, forKey: .id)
	}

}
