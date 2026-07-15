import Testing
@testable import ChemEToolkit

@Suite("Conversion Yield Selectivity Engine")
struct ConversionYieldSelectivityEngineTests {
    private let engine =
        ConversionYieldSelectivityEngine()

    @Test("Calculates conversion, yields and selectivity")
    func calculatesPerformance() throws {
        let result = try engine.calculate(
            .init(
                initialReactantMoles: 100,
                finalReactantMoles: 20,
                desiredProductMoles: 60,
                undesiredProductMoles: 10,
                desiredProductStoichiometricYield: 1,
                undesiredProductStoichiometricYield: 0.5
            )
        )

        #expect(
            abs(
                result.reactantConversionFraction
                - 0.8
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredYieldOnFeedFraction
                - 0.6
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredYieldOnConsumedFraction
                - 0.75
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredSelectivityFraction
                - 0.75
            ) < 1e-12
        )
        #expect(
            abs(
                result.desiredToUndesiredSelectivityRatio
                - 3
            ) < 1e-12
        )
        #expect(
            result.unaccountedReactantConsumption
            == 0
        )
    }

    @Test("Handles no undesired product")
    func completeDesiredSelectivity() throws {
        let result = try engine.calculate(
            .init(
                initialReactantMoles: 100,
                finalReactantMoles: 40,
                desiredProductMoles: 60,
                undesiredProductMoles: 0,
                desiredProductStoichiometricYield: 1,
                undesiredProductStoichiometricYield: 1
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
            result.accountingClosureFraction
            == 1
        )
    }

    @Test("Rejects inconsistent and invalid accounting")
    func validation() {
        #expect(
            throws:
                ConversionYieldSelectivityError
                    .productsExceedReactantConsumption
        ) {
            try engine.calculate(
                .init(
                    initialReactantMoles: 100,
                    finalReactantMoles: 50,
                    desiredProductMoles: 60,
                    undesiredProductMoles: 0,
                    desiredProductStoichiometricYield: 1,
                    undesiredProductStoichiometricYield: 1
                )
            )
        }

        #expect(
            throws:
                ConversionYieldSelectivityError
                    .noReactantConsumption
        ) {
            try engine.calculate(
                .init(
                    initialReactantMoles: 100,
                    finalReactantMoles: 100,
                    desiredProductMoles: 0,
                    undesiredProductMoles: 0,
                    desiredProductStoichiometricYield: 1,
                    undesiredProductStoichiometricYield: 1
                )
            )
        }

        #expect(
            throws:
                ConversionYieldSelectivityError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    initialReactantMoles: .nan,
                    finalReactantMoles: 20,
                    desiredProductMoles: 60,
                    undesiredProductMoles: 10,
                    desiredProductStoichiometricYield: 1,
                    undesiredProductStoichiometricYield: 0.5
                )
            )
        }
    }
}
