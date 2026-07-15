import Testing
@testable import ChemEToolkit

@Suite("Reversible Reactions Engine")
struct ReversibleReactionsEngineTests {
    private let engine =
        ReversibleReactionsEngine()

    @Test("Approaches equilibrium from pure A")
    func approachesEquilibrium() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                initialConcentrationB: 0,
                forwardFirstOrderRateConstant: 0.4,
                reverseFirstOrderRateConstant: 0.1,
                reactionTime: 5
            )
        )

        #expect(result.equilibriumConstant == 4)
        #expect(
            abs(
                result.equilibriumConcentrationA
                - 0.20000000000000001
            ) < 1e-12
        )
        #expect(
            abs(
                result.equilibriumConcentrationB
                - 0.80000000000000004
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalConcentrationA
                - 0.26566799889911907
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalConcentrationB
                - 0.73433200110088093
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalNetRate
                - 0.032833999449559545
            ) < 1e-12
        )
        #expect(
            abs(
                result.approachToEquilibriumFraction
                - 0.91791500137610116
            ) < 1e-12
        )
    }

    @Test("Preserves reverse direction")
    func reverseDirection() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 0,
                initialConcentrationB: 1,
                forwardFirstOrderRateConstant: 0.4,
                reverseFirstOrderRateConstant: 0.1,
                reactionTime: 5
            )
        )

        #expect(
            result.signedExtentConcentration
            < 0
        )
        #expect(
            result.finalConcentrationA
            > 0
        )
        #expect(
            result.directionDescription
            == "Net reaction proceeds from B toward A."
        )
    }

    @Test("Rejects invalid inputs")
    func validation() {
        #expect(
            throws:
                ReversibleReactionsError
                    .zeroTotalConcentration
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 0,
                    initialConcentrationB: 0,
                    forwardFirstOrderRateConstant: 0.4,
                    reverseFirstOrderRateConstant: 0.1,
                    reactionTime: 5
                )
            )
        }

        #expect(
            throws:
                ReversibleReactionsError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    initialConcentrationB: 0,
                    forwardFirstOrderRateConstant: 0,
                    reverseFirstOrderRateConstant: 0.1,
                    reactionTime: 5
                )
            )
        }

        #expect(
            throws:
                ReversibleReactionsError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: .nan,
                    initialConcentrationB: 0,
                    forwardFirstOrderRateConstant: 0.4,
                    reverseFirstOrderRateConstant: 0.1,
                    reactionTime: 5
                )
            )
        }
    }
}
