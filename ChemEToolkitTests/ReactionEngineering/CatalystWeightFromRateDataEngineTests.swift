import Testing
@testable import ChemEToolkit

@Suite("Catalyst Weight from Rate Data Engine")
struct CatalystWeightFromRateDataEngineTests {
    private let engine =
        CatalystWeightFromRateDataEngine()

    @Test("Integrates catalyst weight with Simpson's rule")
    func calculatesWeight() throws {
        let result = try engine.calculate(
            .init(
                inletMolarFlowRateA: 2,
                initialConversion: 0,
                finalConversion: 0.8,
                inverseRateAtInitialConversion: 1,
                inverseRateAtMidpointConversion: 2,
                inverseRateAtFinalConversion: 5
            )
        )

        #expect(
            abs(
                result.catalystLevenspielArea
                - 1.8666666666666667
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredCatalystWeight
                - 3.7333333333333334
            ) < 1e-12
        )
        #expect(
            abs(
                result.averageInverseRate
                - 2.3333333333333335
            ) < 1e-12
        )
        #expect(
            abs(
                result.averageMassSpecificRate
                - 0.42857142857142855
            ) < 1e-12
        )
    }

    @Test("Constant inverse rate gives rectangular area")
    func constantRate() throws {
        let result = try engine.calculate(
            .init(
                inletMolarFlowRateA: 2,
                initialConversion: 0.2,
                finalConversion: 0.8,
                inverseRateAtInitialConversion: 3,
                inverseRateAtMidpointConversion: 3,
                inverseRateAtFinalConversion: 3
            )
        )

        #expect(
            abs(
                result.catalystLevenspielArea
                - 1.8
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredCatalystWeight
                - 3.6
            ) < 1e-12
        )
    }

    @Test("Rejects invalid conversion and rate data")
    func validation() {
        #expect(
            throws:
                CatalystWeightFromRateDataError
                    .invalidConversionInterval
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: 2,
                    initialConversion: 0.8,
                    finalConversion: 0.2,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 2,
                    inverseRateAtFinalConversion: 5
                )
            )
        }

        #expect(
            throws:
                CatalystWeightFromRateDataError
                    .nonPositiveInverseRate
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: 2,
                    initialConversion: 0,
                    finalConversion: 0.8,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 0,
                    inverseRateAtFinalConversion: 5
                )
            )
        }

        #expect(
            throws:
                CatalystWeightFromRateDataError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    inletMolarFlowRateA: .nan,
                    initialConversion: 0,
                    finalConversion: 0.8,
                    inverseRateAtInitialConversion: 1,
                    inverseRateAtMidpointConversion: 2,
                    inverseRateAtFinalConversion: 5
                )
            )
        }
    }
}
