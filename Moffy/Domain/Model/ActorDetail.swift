import Foundation

struct ActorDetail: Codable {
  var adult: Bool?
  var alsoKnownAs: [String]
  var biography: String?
  var birthday: String?
  var deathday: String?
  var id: Int?
  var knownForDepartment: String?
  var name: String?
  var placeOfBirth: String?
  var profilePath: String?
  var movieCredits: Cast?
  var listImage: ImageResponse?
  
  private enum CodingKeys: String, CodingKey {
    case adult
    case alsoKnownAs = "also_known_as"
    case biography
    case birthday
    case deathday
    case id
    case knownForDepartment = "known_for_department"
    case name
    case placeOfBirth = "place_of_birth"
    case profilePath = "profile_path"
    case movieCredits = "movie_credits"
    case listImage = "images"
  }
}

struct Cast: Codable {
  var cast: [Result]
}

struct ImageResponse: Codable {
  var profiles: [ProfilesResponse]
}

struct ProfilesResponse: Codable {
  var filePath: String?
  
  private enum CodingKeys: String, CodingKey {
    case filePath = "file_path"
  }
}
