struct HAZOPGuideWordAssistantInput:
    Equatable,
    Sendable {

    let processParameter: String
    let designIntent: String
    let guideWordCode: Double
    let nodeContext: String
}
