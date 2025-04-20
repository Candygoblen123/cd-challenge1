import Foundation
import CSDL2
import CSDL2_ttf
import CSDL2_Image

@main
struct Challenge {
    static func main() async throws {
        // Get Pixabay key from env var
        guard let apiKey = ProcessInfo.processInfo.environment["PIXABAY_KEY"] else {
            fatalError("Could not find env var PIXABAY_KEY")
        }
        // Init SDL libs
        guard SDL_Init(SDL_INIT_VIDEO) == 0 else {
            fatalError("SDL could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
        }
        guard TTF_Init() == 0 else {
            fatalError("SDL-ttf could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
        }
        guard IMG_Init(0x3f) == 0x3f else {
            fatalError("SDL-ttf could not initialize! SDL_Error: \(String(cString: SDL_GetError()))")
        }

        // Download image
        let pics = try await Pixabay(apiKey: apiKey)
        var bgSur = try await pics.getImage()!

        // Get verse text and verse number
        var verseSur = Bible.getVerseSur(width: bgSur.w / 2)

        // Create a window and get it's renderer
        let window = SDL_CreateWindow(
            "SwiftNES",
            Int32(SDL_WINDOWPOS_CENTERED_MASK), Int32(SDL_WINDOWPOS_CENTERED_MASK),
            bgSur.w / 2, bgSur.h / 2,
            SDL_WINDOW_SHOWN.rawValue
        )
        let renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_PRESENTVSYNC.rawValue)

        // Convert the background and verse text into a texture
        let bgTex = SDL_CreateTextureFromSurface(renderer, &bgSur)
        let verseTex = SDL_CreateTextureFromSurface(renderer, &verseSur!)

        // Figure out where we're gonna put the verse texture
        var verseRect = SDL_Rect(
            x: (bgSur.w / 2) / 2 - (verseSur!.w / 2),
            y: (bgSur.h / 2) / 2 - (verseSur!.h / 2),
            w: verseSur!.w,
            h: verseSur!.h
        )

        // Start event loop
        var event = SDL_Event()
        while true {
            // Clear last frame
            SDL_RenderClear(renderer)
            // copy the textures to the frame
            SDL_RenderCopy(renderer, bgTex, nil, nil)
            SDL_RenderCopy(renderer, verseTex, nil, &verseRect)
            // Present the frame
            SDL_RenderPresent(renderer)
            // Process events
            while SDL_PollEvent(&event) > 0 {
                if event.type == SDL_QUIT.rawValue {
                     SDL_DestroyWindow(window)
                     SDL_Quit()
                     exit(0)
                }
            }
        }
    }
}

// Screw it, make Surfaces sendable
extension SDL_Surface: @unchecked @retroactive Sendable {}
