import Testing
@testable import ChemEToolkit

@Suite("Reverse Osmosis Performance Engine")
struct ReverseOsmosisPerformanceEngineTests {
    private let engine =
        ReverseOsmosisPerformanceEngine()

    @Test("Calculates RO flux, recovery and rejection")
    func calculatesPerformance() throws {
        let result = try engine.calculate(
            .init(
                feedVolumetricFlowRate: 10,
                membraneArea: 100,
                waterPermeabilityLMHPerBar: 1.5,
                appliedPressureDifferenceBar: 15,
                osmoticPressureDifferenceBar: 5,
                solutePermeabilityMetersPerHour: 0.001,
                feedSoluteConcentration: 2
            )
        )

        #expect(
            abs(result.waterFluxLMH - 15)
            < 1e-12
        )
        #expect(
            abs(result.permeateFlowRate - 1.5)
            < 1e-12
        )
        #expect(
            abs(result.waterRecoveryFraction - 0.15)
            < 1e-12
        )
        #expect(
            abs(result.permeateSoluteConcentration - 0.125)
            < 1e-12
        )
        #expect(
            abs(result.observedSoluteRejection - 0.9375)
            < 1e-12
        )
        #expect(
            abs(
                result.concentrateSoluteConcentration
                - 2.3308823529411766
            ) < 1e-12
        )
    }

    @Test("Handles the low-recovery boundary")
    func recoveryBoundary() throws {
        let result = try engine.calculate(
            .init(
                feedVolumetricFlowRate: 10,
                membraneArea: 100,
                waterPermeabilityLMHPerBar: 2.5,
                appliedPressureDifferenceBar: 15,
                osmoticPressureDifferenceBar: 5,
                solutePermeabilityMetersPerHour: 0.001,
                feedSoluteConcentration: 2
            )
        )

        #expect(
            abs(result.waterRecoveryFraction - 0.25)
            < 1e-12
        )
    }

    @Test("Rejects invalid driving force, recovery and nonfinite input")
    func validation() {
        #expect(
            throws:
                ReverseOsmosisPerformanceError
                    .insufficientNetDrivingPressure
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: 10,
                    membraneArea: 100,
                    waterPermeabilityLMHPerBar: 1.5,
                    appliedPressureDifferenceBar: 5,
                    osmoticPressureDifferenceBar: 5,
                    solutePermeabilityMetersPerHour: 0.001,
                    feedSoluteConcentration: 2
                )
            )
        }

        #expect(
            throws:
                ReverseOsmosisPerformanceError
                    .recoveryOutsideLowRecoveryModel
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: 10,
                    membraneArea: 300,
                    waterPermeabilityLMHPerBar: 1.5,
                    appliedPressureDifferenceBar: 15,
                    osmoticPressureDifferenceBar: 5,
                    solutePermeabilityMetersPerHour: 0.001,
                    feedSoluteConcentration: 2
                )
            )
        }

        #expect(
            throws:
                ReverseOsmosisPerformanceError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    feedVolumetricFlowRate: .nan,
                    membraneArea: 100,
                    waterPermeabilityLMHPerBar: 1.5,
                    appliedPressureDifferenceBar: 15,
                    osmoticPressureDifferenceBar: 5,
                    solutePermeabilityMetersPerHour: 0.001,
                    feedSoluteConcentration: 2
                )
            )
        }
    }
}
