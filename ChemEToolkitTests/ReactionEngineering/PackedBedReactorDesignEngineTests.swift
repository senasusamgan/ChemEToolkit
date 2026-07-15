import Testing
@testable import ChemEToolkit

@Suite("Packed-Bed Reactor Design Engine")
struct PackedBedReactorDesignEngineTests {
    private let engine =
        PackedBedReactorDesignEngine()

    @Test("Calculates catalyst weight for target conversion")
    func calculatesWeight() throws {
        let result = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                massSpecificFirstOrderRateConstant:
                    0.002,
                targetConversion: 0.8
            )
        )

        #expect(
            abs(
                result.requiredCatalystWeight
                - 8.047189562170502
            ) < 1e-12
        )
        #expect(result.inletMolarFlowRateA == 1)
        #expect(
            abs(
                result.outletMolarFlowRateA
                - 0.2
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationA
                - 20
            ) < 1e-12
        )
        #expect(
            abs(
                result.firstOrderExposure
                - 1.6094379124341003
            ) < 1e-12
        )
    }

    @Test("Higher conversion requires more catalyst")
    func conversionScaling() throws {
        let lower = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                massSpecificFirstOrderRateConstant:
                    0.002,
                targetConversion: 0.5
            )
        )

        let higher = try engine.calculate(
            .init(
                inletConcentrationA: 100,
                inletVolumetricFlowRate: 0.01,
                massSpecificFirstOrderRateConstant:
                    0.002,
                targetConversion: 0.9
            )
        )

        #expect(
            higher.requiredCatalystWeight
            > lower.requiredCatalystWeight
        )
    }

    @Test("Rejects invalid feed, rate and conversion")
    func validation() {
        #expect(
            throws:
                PackedBedReactorDesignError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    massSpecificFirstOrderRateConstant:
                        0.002,
                    targetConversion: 1
                )
            )
        }

        #expect(
            throws:
                PackedBedReactorDesignError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: 100,
                    inletVolumetricFlowRate: 0.01,
                    massSpecificFirstOrderRateConstant:
                        0,
                    targetConversion: 0.8
                )
            )
        }

        #expect(
            throws:
                PackedBedReactorDesignError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    inletConcentrationA: .nan,
                    inletVolumetricFlowRate: 0.01,
                    massSpecificFirstOrderRateConstant:
                        0.002,
                    targetConversion: 0.8
                )
            )
        }
    }
}
