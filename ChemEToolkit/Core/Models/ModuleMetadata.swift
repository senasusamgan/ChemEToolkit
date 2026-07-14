import Foundation

struct ModuleMetadata: Identifiable, Codable, Hashable {
    let id: ModuleID
    let title: String
    let subtitle: String
    let category: ModuleCategory
    let symbolName: String
    let keywords: [String]
    let isFeatured: Bool

    init(
        id: ModuleID,
        title: String,
        subtitle: String,
        category: ModuleCategory,
        symbolName: String,
        keywords: [String] = [],
        isFeatured: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.category = category
        self.symbolName = symbolName
        self.keywords = keywords
        self.isFeatured = isFeatured
    }

    var searchableText: String {
        (
            [
                title,
                subtitle,
                category.title
            ] + keywords
        )
        .joined(separator: " ")
        .lowercased()
    }

    func matches(searchText: String) -> Bool {
        let normalizedSearchText = searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !normalizedSearchText.isEmpty else {
            return true
        }

        return searchableText.contains(normalizedSearchText)
    }
}
