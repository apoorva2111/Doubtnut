
import Foundation
struct HomeModel : Codable {
	let meta : Meta?
	let data : Data_Home?

	enum CodingKeys: String, CodingKey {

		case meta = "meta"
		case data = "data"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		meta = try values.decodeIfPresent(Meta.self, forKey: .meta)
		data = try values.decodeIfPresent(Data_Home.self, forKey: .data)
	}

}
