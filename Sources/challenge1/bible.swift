import Foundation
import CSDL2
import CSDL2_ttf

struct Bible {
    /// Get a random bible verse
    static func getVerse() -> (String, String) {
        let books = try! FileManager.default.contentsOfDirectory(atPath: "bible")

        let bookRng = Int.random(in: 0..<books.count)
        let bookJson = FileManager.default.contents(atPath: "bible/\(books[bookRng])")
        let dec = JSONDecoder()
        let book = try! dec.decode(BibleBook.self, from: bookJson!)

        let chaptRng = Int.random(in: 0..<book.chapters.count)
        let verseRng = Int.random(in: 0..<book.chapters[chaptRng].verses.count)
        let verse = book.chapters[chaptRng].verses[verseRng].text
        return (verse, "\(book.book) \(chaptRng):\(verseRng)")
    }

    /// Render a random bible verse to a Surface
    static func getVerseSur(width: Int32) -> SDL_Surface? {
        let (verseText, verse) = Bible.getVerse()
        let font = TTF_OpenFont("Roboto.ttf", 24)
        guard font != nil else { print("Font not found"); exit(-1) }
        let fontOutline = TTF_OpenFont("Roboto.ttf", 24)
        TTF_SetFontOutline(fontOutline, 2)
        let verseSurBg = TTF_RenderText_Blended_Wrapped(fontOutline,
            "\(verseText)\n - \(verse)",
            SDL_Color.init(r: 0, g: 0, b: 0, a: 0),
            Uint32(width)
        )
        let verseSur = TTF_RenderText_Blended_Wrapped(font,
            "\(verseText)\n - \(verse)",
            SDL_Color.init(r: 255, g: 255, b: 255, a: 0),
            Uint32(width)
        )
        var rect = SDL_Rect(x: 2, y: 2, w: verseSur!.pointee.w, h: verseSur!.pointee.h)
        SDL_SetSurfaceBlendMode(verseSur, SDL_BLENDMODE_BLEND)
        SDL_UpperBlit(verseSur, nil, verseSurBg, &rect)

        return verseSurBg?.pointee
    }
}

// Json Parsing stuff
struct BibleBook: Decodable {
    let book: String
    let chapters: [BibleChapt]
}

struct BibleChapt: Decodable {
    let chapter: String
    let verses: [BibleVerse]
}

struct BibleVerse: Decodable {
    let verse: String
    let text: String
}
