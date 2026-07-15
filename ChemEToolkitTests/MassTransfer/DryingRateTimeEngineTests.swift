import Testing
@testable import ChemEToolkit

@Suite("Drying Rate and Time Engine")
struct DryingRateTimeEngineTests {
    private let engine =
        DryingRateTimeEngine()

    @Test(
        "Calculates constant and falling drying periods"
    )
    func combinedPeriods() throws {
        let result = try engine.calculate(
            .init(
                drySolidMass: 100,
                dryingArea: 10,
                constantDryingFlux: 2,
                initialMoistureContent: 0.5,
                criticalMoistureContent: 0.2,
                equilibriumMoistureContent:
                    0.05,
                finalMoistureContent: 0.1
            )
        )

        #expect(
            abs(
                result.constantRateTime
                - 1.5
            ) < 1e-12
        )
        #expect(
            abs(
                result.fallingRateTime
                - 0.8239592165010825
            ) < 1e-12
        )
        #expect(
            abs(
                result.totalDryingTime
                - 2.3239592165010823
            ) < 1e-12
        )
        #expect(
            abs(
                result.averageDryingFlux
                - 1.7212006009392622
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalDryingFlux
                - 0.6666666666666666
            ) < 1e-12
        )
    }

    @Test(
        "Uses only the constant-rate period at the critical-moisture boundary"
    )
    func criticalBoundary() throws {
        let result = try engine.calculate(
            .init(
                drySolidMass: 100,
                dryingArea: 10,
                constantDryingFlux: 2,
                initialMoistureContent: 0.5,
                criticalMoistureContent: 0.2,
                equilibriumMoistureContent:
                    0.05,
                finalMoistureContent: 0.2
            )
        )

        #expect(
            abs(
                result.constantRateTime
                - 1.5
            ) < 1e-12
        )
        #expect(
            result.fallingRateTime == 0
        )
        #expect(
            result.finalDryingFlux == 2
        )
    }

    @Test(
        "Rejects invalid properties, moisture ordering and equilibrium target"
    )
    func validation() {
        #expect(
            throws:
                DryingRateTimeError
                    .nonPositiveProperty
        ) {
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 0,
                    constantDryingFlux: 2,
                    initialMoistureContent:
                        0.5,
                    criticalMoistureContent:
                        0.2,
                    equilibriumMoistureContent:
                        0.05,
                    finalMoistureContent:
                        0.1
                )
            )
        }

        #expect(
            throws:
                DryingRateTimeError
                    .invalidMoistureOrdering
        ) {
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 10,
                    constantDryingFlux: 2,
                    initialMoistureContent:
                        0.1,
                    criticalMoistureContent:
                        0.2,
                    equilibriumMoistureContent:
                        0.05,
                    finalMoistureContent:
                        0.2
                )
            )
        }

        #expect(
            throws:
                DryingRateTimeError
                    .finalAtOrBelowEquilibrium
        ) {
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 10,
                    constantDryingFlux: 2,
                    initialMoistureContent:
                        0.5,
                    criticalMoistureContent:
                        0.2,
                    equilibriumMoistureContent:
                        0.05,
                    finalMoistureContent:
                        0.05
                )
            )
        }

        #expect(
            throws:
                DryingRateTimeError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                .init(
                    drySolidMass: .nan,
                    dryingArea: 10,
                    constantDryingFlux: 2,
                    initialMoistureContent:
                        0.5,
                    criticalMoistureContent:
                        0.2,
                    equilibriumMoistureContent:
                        0.05,
                    finalMoistureContent:
                        0.1
                )
            )
        }
    }
}
