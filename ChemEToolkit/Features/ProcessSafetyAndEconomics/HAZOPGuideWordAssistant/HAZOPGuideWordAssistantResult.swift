struct HAZOPGuideWordAssistantResult:
    Equatable,
    Sendable {

    let guideWord: String
    let deviationPhrase: String

    let causePrompt: String
    let consequencePrompt: String
    let safeguardPrompt: String
    let recommendationPrompt: String

    let worksheetSummary: String

    let modelName: String
    let limitationDescription: String
}
