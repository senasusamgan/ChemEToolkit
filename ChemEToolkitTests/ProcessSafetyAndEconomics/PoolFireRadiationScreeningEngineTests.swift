import Testing
@testable import ChemEToolkit

@Suite("Pool Fire Radiation Screening Engine")
struct PoolFireRadiationScreeningEngineTests {
    private let engine =
        PoolFireRadiationScreeningEngine()

    @Test("Calculates point-source pool-fire radiation")
    func radiation() throws {
        let result = try engine.calculate(
            .init(
                burningMassRate: 5,
                heatOfCombustion: 44_000_000,
                radiantFraction: 0.2,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 50
            )
        )

        #expect(
            result.totalHeatReleaseRate
            == 220000000
        )

        #expect(
            result.radiatedHeatRate
            == 44000000
        )

        #expect(
            result.transmittedRadiatedHeatRate
            == 39600000
        )

        #expect(
            abs(
                result.thermalRadiationFlux
                - 1260.507149287811
            ) < 1e-9
        )
    }

    @Test("Radiation decreases with squared distance")
    func distanceEffect() throws {
        let near = try engine.calculate(
            .init(
                burningMassRate: 5,
                heatOfCombustion: 44_000_000,
                radiantFraction: 0.2,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 25
            )
        )

        let far = try engine.calculate(
            .init(
                burningMassRate: 5,
                heatOfCombustion: 44_000_000,
                radiantFraction: 0.2,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 50
            )
        )

        #expect(
            abs(
                near.thermalRadiationFlux
                / far.thermalRadiationFlux
                - 4
            ) < 1e-12
        )
    }

    @Test("Rejects invalid radiant fraction")
    func validation() {
        #expect(
            throws:
                PoolFireRadiationScreeningError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    burningMassRate: 5,
                    heatOfCombustion: 44_000_000,
                    radiantFraction: 1.2,
                    atmosphericTransmissivity: 0.9,
                    receptorDistance: 50
                )
            )
        }
    }
}
