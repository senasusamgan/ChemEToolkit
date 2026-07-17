import Testing
@testable import ChemEToolkit

@Suite("BLEVE Fireball Screening Engine")
struct BLEVEFireballScreeningEngineTests {
    private let engine =
        BLEVEFireballScreeningEngine()

    @Test("Calculates fireball size duration and radiation")
    func fireball() throws {
        let result = try engine.calculate(
            .init(
                flammableMass: 10_000,
                heatOfCombustion: 46_000_000,
                radiantFraction: 0.3,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 200
            )
        )

        #expect(
            abs(
                result.fireballDiameter
                - 129.29299800998342
            ) < 1e-10
        )

        #expect(
            abs(
                result.fireballDuration
                - 9.3419942311399371
            ) < 1e-10
        )

        #expect(
            result.totalCombustionEnergy
            == 460000000000
        )

        #expect(
            result.radiatedEnergy
            == 138000000000
        )

        #expect(
            abs(
                result.averageRadiationFlux
                - 26449.175950734571
            ) < 1e-8
        )
    }

    @Test("Larger inventory produces larger fireball")
    func inventoryEffect() throws {
        let small = try engine.calculate(
            .init(
                flammableMass: 1_000,
                heatOfCombustion: 46_000_000,
                radiantFraction: 0.3,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 200
            )
        )

        let large = try engine.calculate(
            .init(
                flammableMass: 10_000,
                heatOfCombustion: 46_000_000,
                radiantFraction: 0.3,
                atmosphericTransmissivity: 0.9,
                receptorDistance: 200
            )
        )

        #expect(
            large.fireballDiameter
            > small.fireballDiameter
        )
    }

    @Test("Rejects nonpositive mass")
    func validation() {
        #expect(
            throws:
                BLEVEFireballScreeningError
                    .nonPositiveMass
        ) {
            try engine.calculate(
                .init(
                    flammableMass: 0,
                    heatOfCombustion: 46_000_000,
                    radiantFraction: 0.3,
                    atmosphericTransmissivity: 0.9,
                    receptorDistance: 200
                )
            )
        }
    }
}
