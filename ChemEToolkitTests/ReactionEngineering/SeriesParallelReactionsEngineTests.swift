import Testing
@testable import ChemEToolkit

@Suite("Series-Parallel Reactions Engine")
struct SeriesParallelReactionsEngineTests {
    private let engine =
        SeriesParallelReactionsEngine()

    @Test("Calculates the combined reaction network")
    func calculatesNetwork() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                rateConstantAToB: 0.4,
                rateConstantBToC: 0.15,
                rateConstantAToD: 0.1,
                reactionTime: 3
            )
        )

        #expect(
            abs(
                result.concentrationA
                - 0.22313016014842982
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredIntermediateB
                - 0.47371199025524985
            ) < 1e-12
        )
        #expect(
            abs(
                result.seriesProductC
                - 0.14778388162600631
            ) < 1e-12
        )
        #expect(
            abs(
                result.parallelByproductD
                - 0.15537396797031405
            ) < 1e-12
        )
        #expect(
            abs(
                result.timeOfMaximumB
                - 3.4399222980741033
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumConcentrationB
                - 0.47752827983710361
            ) < 1e-12
        )
    }

    @Test("Mass balance closes")
    func massBalance() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                rateConstantAToB: 0.4,
                rateConstantBToC: 0.15,
                rateConstantAToD: 0.1,
                reactionTime: 3
            )
        )

        #expect(
            abs(
                result.concentrationA
                + result.desiredIntermediateB
                + result.seriesProductC
                + result.parallelByproductD
                - 1
            ) < 1e-12
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                SeriesParallelReactionsError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    rateConstantAToB: 0.4,
                    rateConstantBToC: 0,
                    rateConstantAToD: 0.1,
                    reactionTime: 3
                )
            )
        }

        #expect(
            throws:
                SeriesParallelReactionsError
                    .negativeReactionTime
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    rateConstantAToB: 0.4,
                    rateConstantBToC: 0.15,
                    rateConstantAToD: 0.1,
                    reactionTime: -1
                )
            )
        }

        #expect(
            throws:
                SeriesParallelReactionsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    rateConstantAToB: 0.4,
                    rateConstantBToC: 0.15,
                    rateConstantAToD: 0.1,
                    reactionTime: 3
                )
            )
        }
    }
}
