struct MIMODecouplingControlEngine:
    Sendable {

    private let singularTolerance =
        1e-12

    func calculate(
        _ input:
            MIMODecouplingControlInput
    ) throws
        -> MIMODecouplingControlResult {

        let values = [
            input.gain11,
            input.gain12,
            input.gain21,
            input.gain22
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw MIMODecouplingControlError
                .nonFiniteInput
        }

        let determinant =
            input.gain11
            * input.gain22
            - input.gain12
            * input.gain21

        let matrixScale =
            max(
                1,
                abs(input.gain11),
                abs(input.gain12),
                abs(input.gain21),
                abs(input.gain22)
            )

        guard
            abs(determinant)
            > singularTolerance
                * matrixScale
                * matrixScale
        else {
            throw MIMODecouplingControlError
                .singularGainMatrix
        }

        let relativeGain11 =
            input.gain11
            * input.gain22
            / determinant

        let relativeGain12 =
            -input.gain12
            * input.gain21
            / determinant

        let relativeGain21 =
            relativeGain12

        let relativeGain22 =
            relativeGain11

        let inverse11 =
            input.gain22
            / determinant

        let inverse12 =
            -input.gain12
            / determinant

        let inverse21 =
            -input.gain21
            / determinant

        let inverse22 =
            input.gain11
            / determinant

        let directScore =
            abs(
                relativeGain11 - 1
            )
            + abs(
                relativeGain22 - 1
            )

        let crossedScore =
            abs(
                relativeGain12 - 1
            )
            + abs(
                relativeGain21 - 1
            )

        let pairing: String

        if directScore < crossedScore {
            pairing =
                "Recommended pairing: y₁↔u₁ and y₂↔u₂."
        } else if crossedScore < directScore {
            pairing =
                "Recommended pairing: y₁↔u₂ and y₂↔u₁."
        } else {
            pairing =
                "Both pairings have equal steady-state RGA distance; use dynamic information to decide."
        }

        let interactionIndex =
            abs(relativeGain12)
            + abs(relativeGain21)

        let determinantRatio =
            abs(determinant)
            / (
                matrixScale
                * matrixScale
            )

        let conditioning: String

        if determinantRatio > 0.25 {
            conditioning =
                "Well separated steady-state gain directions."
        } else if determinantRatio > 0.05 {
            conditioning =
                "Moderate matrix conditioning; validate decoupler sensitivity."
        } else {
            conditioning =
                "Poorly conditioned gain matrix; static decoupling may amplify modeling error."
        }

        let results = [
            determinant,
            relativeGain11,
            relativeGain12,
            relativeGain21,
            relativeGain22,
            inverse11,
            inverse12,
            inverse21,
            inverse22,
            interactionIndex
        ]

        guard
            results.allSatisfy(\.isFinite),
            interactionIndex >= 0
        else {
            throw MIMODecouplingControlError
                .numericalFailure
        }

        return .init(
            determinant:
                determinant,
            relativeGain11:
                relativeGain11,
            relativeGain12:
                relativeGain12,
            relativeGain21:
                relativeGain21,
            relativeGain22:
                relativeGain22,
            inverseGain11:
                inverse11,
            inverseGain12:
                inverse12,
            inverseGain21:
                inverse21,
            inverseGain22:
                inverse22,
            interactionIndex:
                interactionIndex,
            pairingRecommendation:
                pairing,
            conditioningDescription:
                conditioning,
            modelName:
                "2×2 steady-state Relative Gain Array and inverse-gain decoupler",
            limitationDescription:
                "Uses only steady-state gains. Dynamic decoupling also requires transfer-function delays, time constants, nonminimum-phase behavior and robustness constraints."
        )
    }
}
