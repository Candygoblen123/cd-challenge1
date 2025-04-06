import Foundation
import CSDL2_Image

struct Pixabay {
    let images: ImageList

    /// Create a new Pixabay API instance
    init(apiKey: String) async throws {
        images = try await Pixabay.getImageList(apiKey: apiKey)
    }

    /// Grabs a new image list
    static func getImageList(apiKey: String) async throws -> ImageList {
        let url = URL(string: "https://pixabay.com/api?key=\(apiKey)&safesearch=true&image-type=photo&category=nature&per_page=100")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let imageList = try decoder.decode(ImageList.self, from: data)
        return imageList
    }

    /// Gets a new random image from the ImageList
    func getImage() async throws -> SDL_Surface? {
        let idx = Int.random(in: 0..<images.hits.count)
        let (fileUrl, _) = try await URLSession.shared.download(from: images.hits[idx].largeImageURL)
        let img = IMG_Load(fileUrl.path)
        return img?.pointee
    }
}

// Json decoding stuff
struct ImageList: Decodable {
    let total: Int
    let totalHits: Int
    let hits: [ImageHits]
}

struct ImageHits: Decodable {
    let id: Int
    let pageURL: URL
    let previewURL: URL
    let webformatURL: URL
    let largeImageURL: URL
    let views: Int
    let downloads: Int
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: URL
}
