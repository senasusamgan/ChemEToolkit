import Foundation

enum HAZOPGuideWordAssistantError:
    Error,
    Equatable,
    LocalizedError {

    case emptyProcessParameter
    case emptyDesignIntent
    case invalidGuideWordCode

    var errorDescription: String? {
        switch self {
        case .emptyProcessParameter:
            return "Process parameter cannot be empty."
        case .emptyDesignIntent:
            return "Design intent cannot be empty."
        case .invalidGuideWordCode:
            return "Guide-word code must be a whole number from 1 through 7."
        }
    }
}
