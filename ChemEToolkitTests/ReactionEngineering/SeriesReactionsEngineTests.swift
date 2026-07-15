import Foundation
import Testing
@testable import ChemEToolkit

@Suite("Series Reactions Engine")
struct SeriesReactionsEngineTests {
    private let engine =
        SeriesReactionsEngine()

    @Test("Calculates A to B to C concentrations")
    func calculatesSeriesReaction() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                firstStepRateConstant: 0.5,
                secondStepRateConstant: 0.2,
                reactionTime: 4
            )
        )

        #expect(
            abs(
                result.concentrationA
                - 0.1353352832366127
            ) < 1e-12
        )
        #expect(
            abs(
                result.intermediateConcentrationB
                - 0.52332280146768151
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalProductConcentrationC
                - 0.34134191529570579
            ) < 1e-12
        )
        #expect(
            abs(
                result.timeOfMaximumIntermediate
                - 3.0543024395805167
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumIntermediateConcentration
                - 0.54288352331898126
            ) < 1e-12
        )
    }

    @Test("Handles equal rate constants")
    func equalRateConstants() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                firstStepRateConstant: 0.5,
                secondStepRateConstant: 0.5,
                reactionTime: 2
            )
        )

        #expect(
            abs(
                result.intermediateConcentrationB
                - 1 / Foundation.exp(1)
            ) < 1e-12
        )
        #expect(
            abs(
                result.timeOfMaximumIntermediate
                - 2
            ) < 1e-12
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                SeriesReactionsError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    firstStepRateConstant: 0,
                    secondStepRateConstant: 0.2,
                    reactionTime: 4
                )
            )
        }

        #expect(
            throws:
                SeriesReactionsError
                    .negativeReactionTime
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    firstStepRateConstant: 0.5,
                    secondStepRateConstant: 0.2,
                    reactionTime: -1
                )
            )
        }

        #expect(
            throws:
                SeriesReactionsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    firstStepRateConstant: 0.5,
                    secondStepRateConstant: 0.2,
                    reactionTime: 4
                )
            )
        }
    }
}
