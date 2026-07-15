import Testing
@testable import ChemEToolkit

@Suite("Parallel Reactions Engine")
struct ParallelReactionsEngineTests {
    private let engine =
        ParallelReactionsEngine()

    @Test("Calculates competing first-order products")
    func calculatesProductSplit() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 2,
                desiredFirstOrderRateConstant: 0.2,
                undesiredFirstOrderRateConstant: 0.1,
                reactionTime: 5
            )
        )

        #expect(
            abs(
                result.finalConcentrationA
                - 0.44626032029685964
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredProductConcentration
                - 1.0358264531354271
            ) < 1e-12
        )
        #expect(
            abs(
                result.undesiredProductConcentration
                - 0.51791322656771355
            ) < 1e-12
        )
        #expect(
            abs(
                result.reactantConversionFraction
                - 0.77686983985157021
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredYieldOnConsumedFraction
                - 2.0 / 3.0
            ) < 1e-12
        )
        #expect(
            result.desiredToUndesiredSelectivityRatio
            == 2
        )
    }

    @Test("Zero undesired pathway gives complete desired selectivity")
    func noUndesiredPath() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 2,
                desiredFirstOrderRateConstant: 0.2,
                undesiredFirstOrderRateConstant: 0,
                reactionTime: 5
            )
        )

        #expect(
            result.desiredSelectivityFraction
            == 1
        )
        #expect(
            result
                .desiredToUndesiredSelectivityRatio
                .isInfinite
        )
        #expect(
            result.undesiredProductConcentration
            == 0
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                ParallelReactionsError
                    .negativeUndesiredRateConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 2,
                    desiredFirstOrderRateConstant: 0.2,
                    undesiredFirstOrderRateConstant: -0.1,
                    reactionTime: 5
                )
            )
        }

        #expect(
            throws:
                ParallelReactionsError
                    .negativeReactionTime
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 2,
                    desiredFirstOrderRateConstant: 0.2,
                    undesiredFirstOrderRateConstant: 0.1,
                    reactionTime: -1
                )
            )
        }

        #expect(
            throws:
                ParallelReactionsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    desiredFirstOrderRateConstant: 0.2,
                    undesiredFirstOrderRateConstant: 0.1,
                    reactionTime: 5
                )
            )
        }
    }
}
