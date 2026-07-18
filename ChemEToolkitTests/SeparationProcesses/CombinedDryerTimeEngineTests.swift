import Testing
@testable import ChemEToolkit

@Suite("Combined Dryer Time Engine")
struct CombinedDryerTimeEngineTests {
    private let engine =
        CombinedDryerTimeEngine()

    @Test("Combines both drying periods")
    func totalTime() throws {
        let result =
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 10,
                    initialMoistureDryBasis: 0.50,
                    criticalMoistureDryBasis: 0.20,
                    finalMoistureDryBasis: 0.08,
                    equilibriumMoistureDryBasis: 0.05,
                    constantDryingFlux: 2
                )
            )

        #expect(
            abs(
                result.totalDryingTime
                - (
                    result.constantRateTime
                    + result.fallingRateTime
                )
            ) < 1e-12
        )

        #expect(
            abs(
                result.totalMoistureRemoved
                - 42
            ) < 1e-12
        )
    }

    @Test("Larger area reduces total time")
    func areaTrend() throws {
        let small =
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 5,
                    initialMoistureDryBasis: 0.50,
                    criticalMoistureDryBasis: 0.20,
                    finalMoistureDryBasis: 0.08,
                    equilibriumMoistureDryBasis: 0.05,
                    constantDryingFlux: 2
                )
            )

        let large =
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 10,
                    initialMoistureDryBasis: 0.50,
                    criticalMoistureDryBasis: 0.20,
                    finalMoistureDryBasis: 0.08,
                    equilibriumMoistureDryBasis: 0.05,
                    constantDryingFlux: 2
                )
            )

        #expect(
            large.totalDryingTime
            < small.totalDryingTime
        )
    }

    @Test("Rejects invalid moisture ordering")
    func validation() {
        #expect(
            throws:
                CombinedDryerTimeError
                    .invalidMoistureOrdering
        ) {
            try engine.calculate(
                .init(
                    drySolidMass: 100,
                    dryingArea: 10,
                    initialMoistureDryBasis: 0.20,
                    criticalMoistureDryBasis: 0.30,
                    finalMoistureDryBasis: 0.08,
                    equilibriumMoistureDryBasis: 0.05,
                    constantDryingFlux: 2
                )
            )
        }
    }
}
