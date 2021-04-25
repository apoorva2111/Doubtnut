
import Foundation
struct Widget_data : Codable {
	let title : String?
	let _id : String?
	let show_view_all : Int?
	let caraousel_id : Int?
	let items : [Items]?
	let deeplink : String?
	let sharing_message : String?

	enum CodingKeys: String, CodingKey {

		case title = "title"
		case _id = "_id"
		case show_view_all = "show_view_all"
		case caraousel_id = "caraousel_id"
		case items = "items"
		case deeplink = "deeplink"
		case sharing_message = "sharing_message"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		_id = try values.decodeIfPresent(String.self, forKey: ._id)
		show_view_all = try values.decodeIfPresent(Int.self, forKey: .show_view_all)
		caraousel_id = try values.decodeIfPresent(Int.self, forKey: .caraousel_id)
		items = try values.decodeIfPresent([Items].self, forKey: .items)
		deeplink = try values.decodeIfPresent(String.self, forKey: .deeplink)
		sharing_message = try values.decodeIfPresent(String.self, forKey: .sharing_message)
	}

}
