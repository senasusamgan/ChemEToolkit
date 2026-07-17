import Foundation

struct HAZOPGuideWordAssistantEngine:
    Sendable {

    func calculate(
        _ input:
            HAZOPGuideWordAssistantInput
    ) throws
        -> HAZOPGuideWordAssistantResult {

        let parameter =
            input.processParameter
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        let designIntent =
            input.designIntent
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        let context =
            input.nodeContext
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        guard !parameter.isEmpty else {
            throw HAZOPGuideWordAssistantError
                .emptyProcessParameter
        }

        guard !designIntent.isEmpty else {
            throw HAZOPGuideWordAssistantError
                .emptyDesignIntent
        }

        guard input.guideWordCode.isFinite else {
            throw HAZOPGuideWordAssistantError
                .invalidGuideWordCode
        }

        let roundedCode =
            input.guideWordCode.rounded()

        guard
            abs(
                input.guideWordCode
                - roundedCode
            ) < 1e-12,
            roundedCode >= 1,
            roundedCode <= 7
        else {
            throw HAZOPGuideWordAssistantError
                .invalidGuideWordCode
        }

        let guideWord: String
        let deviationQualifier: String
        let causeFocus: String
        let consequenceFocus: String

        switch Int(roundedCode) {
        case 1:
            guideWord = "No / Not"
            deviationQualifier =
                "No \(parameter)"
            causeFocus =
                "total loss, isolation, blockage, equipment trip or unavailable utility"
            consequenceFocus =
                "loss of intended function, accumulation, starvation, shutdown or secondary upset"

        case 2:
            guideWord = "More"
            deviationQualifier =
                "More \(parameter) than intended"
            causeFocus =
                "controller failure, valve opening, excessive feed, utility excess or upstream pressure increase"
            consequenceFocus =
                "overpressure, overflow, overheating, excessive reaction rate or downstream overload"

        case 3:
            guideWord = "Less"
            deviationQualifier =
                "Less \(parameter) than intended"
            causeFocus =
                "restriction, fouling, partial blockage, low utility supply, leakage or control-valve closure"
            consequenceFocus =
                "poor conversion, inadequate cooling, unstable operation, off-spec product or equipment damage"

        case 4:
            guideWord = "As Well As"
            deviationQualifier =
                "\(parameter) plus an additional material or condition"
            causeFocus =
                "cross-connection, contamination, valve lineup error, ingress or unintended simultaneous operation"
            consequenceFocus =
                "incompatible reaction, phase change, corrosion, toxicity, flammability or product contamination"

        case 5:
            guideWord = "Part Of"
            deviationQualifier =
                "Only part of the intended \(parameter) condition"
            causeFocus =
                "incomplete composition, missing component, partial sequence, blocked branch or failed unit operation"
            consequenceFocus =
                "incorrect composition, poor reaction performance, separation failure or latent hazardous inventory"

        case 6:
            guideWord = "Reverse"
            deviationQualifier =
                "Reverse \(parameter) or opposite direction"
            causeFocus =
                "pressure reversal, siphoning, check-valve failure, wrong connection or shutdown transient"
            consequenceFocus =
                "backflow, contamination, vessel overfill, incompatible mixing or upstream equipment exposure"

        default:
            guideWord = "Other Than"
            deviationQualifier =
                "A different \(parameter) condition than intended"
            causeFocus =
                "wrong material, wrong operating mode, incorrect set point, maintenance error or abnormal procedure"
            consequenceFocus =
                "unexpected chemistry, unsuitable equipment conditions, quality loss or hazardous release"
        }

        let contextPhrase =
            context.isEmpty
            ? "the selected HAZOP node"
            : context

        let deviation =
            "\(deviationQualifier) while the design intent is: \(designIntent)."

        let causePrompt =
            "For \(contextPhrase), examine \(causeFocus)."

        let consequencePrompt =
            "Evaluate whether the deviation could cause \(consequenceFocus)."

        let safeguardPrompt =
            "Record existing prevention, detection and mitigation safeguards; verify independence, availability and proof-test assumptions."

        let recommendationPrompt =
            "Where residual risk is unacceptable, assign a specific engineering or procedural action with an owner and due date."

        let summary =
            "\(guideWord) + \(parameter): \(deviationQualifier)"

        return .init(
            guideWord:
                guideWord,
            deviationPhrase:
                deviation,
            causePrompt:
                causePrompt,
            consequencePrompt:
                consequencePrompt,
            safeguardPrompt:
                safeguardPrompt,
            recommendationPrompt:
                recommendationPrompt,
            worksheetSummary:
                summary,
            modelName:
                "Structured HAZOP guide-word prompt generator",
            limitationDescription:
                "This tool only structures brainstorming. It does not perform a HAZOP, determine risk acceptance or replace a multidisciplinary team, node drawings, operating knowledge and documented follow-up."
        )
    }
}
