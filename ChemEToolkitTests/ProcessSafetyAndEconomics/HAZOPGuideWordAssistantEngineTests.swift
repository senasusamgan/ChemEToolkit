import Testing
@testable import ChemEToolkit

@Suite("HAZOP Guide Word Assistant Engine")
struct HAZOPGuideWordAssistantEngineTests {
    private let engine =
        HAZOPGuideWordAssistantEngine()

    @Test("Builds a More Flow deviation prompt")
    func moreFlow() throws {
        let result = try engine.calculate(
            .init(
                processParameter: "Flow",
                designIntent:
                    "Transfer feed at 20 m³/h",
                guideWordCode: 2,
                nodeContext:
                    "Feed line to reactor"
            )
        )

        #expect(result.guideWord == "More")

        #expect(
            result.deviationPhrase.contains(
                "More Flow than intended"
            )
        )

        #expect(
            result.causePrompt.contains(
                "Feed line to reactor"
            )
        )
    }

    @Test("Supports empty optional node context")
    func optionalContext() throws {
        let result = try engine.calculate(
            .init(
                processParameter: "Pressure",
                designIntent:
                    "Maintain 4 bar",
                guideWordCode: 1,
                nodeContext: "   "
            )
        )

        #expect(result.guideWord == "No / Not")

        #expect(
            result.causePrompt.contains(
                "the selected HAZOP node"
            )
        )
    }

    @Test("Rejects an invalid guide-word code")
    func validation() {
        #expect(
            throws:
                HAZOPGuideWordAssistantError
                    .invalidGuideWordCode
        ) {
            try engine.calculate(
                .init(
                    processParameter: "Flow",
                    designIntent: "Normal flow",
                    guideWordCode: 2.5,
                    nodeContext: ""
                )
            )
        }
    }
}
