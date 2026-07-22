import Testing
@testable import ChemEToolkit

@Suite("Reactive Material Balance Engine")
struct ReactiveMaterialBalanceEngineTests {
    private let engine =
        ReactiveMaterialBalanceEngine()

    @Test("Calculates product formation from conversion")
    func reactiveBalance() throws {
        let result = try engine.calculate(
            .init(
                reactantFeedMolarFlow: 100,
                reactantStoichiometricCoefficient: 2,
                productStoichiometricCoefficient: 3,
                reactantConversionFraction: 0.60
            )
        )

        #expect(result.reactantConsumedFlow == 60)
        #expect(result.reactantOutletFlow == 40)
        #expect(result.reactionExtentRate == 30)
        #expect(result.productFormationFlow == 90)
        #expect(result.totalOutletMolarFlow == 130)

        #expect(
            abs(
                result.outletProductMoleFraction
                - 90.0 / 130.0
            ) < 1e-12
        )
    }

    @Test("Zero conversion preserves reactant")
    func noReaction() throws {
        let result = try engine.calculate(
            .init(
                reactantFeedMolarFlow: 100,
                reactantStoichiometricCoefficient: 2,
                productStoichiometricCoefficient: 3,
                reactantConversionFraction: 0
            )
        )

        #expect(result.reactantOutletFlow == 100)
        #expect(result.productFormationFlow == 0)
    }

    @Test("Rejects conversion above one")
    func validation() {
        #expect(
            throws:
                ReactiveMaterialBalanceError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    reactantFeedMolarFlow: 100,
                    reactantStoichiometricCoefficient: 2,
                    productStoichiometricCoefficient: 3,
                    reactantConversionFraction: 1.1
                )
            )
        }
    }
}
