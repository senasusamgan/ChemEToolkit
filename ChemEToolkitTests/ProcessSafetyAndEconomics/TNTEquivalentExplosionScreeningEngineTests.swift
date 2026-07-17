import Testing
@testable import ChemEToolkit

@Suite("TNT Equivalent Explosion Screening Engine")
struct TNTEquivalentExplosionScreeningEngineTests {
    private let engine =
        TNTEquivalentExplosionScreeningEngine()

    @Test("Calculates TNT equivalent and scaled distance")
    func tntEquivalent() throws {
        let result = try engine.calculate(
            .init(
                flammableMass: 1_000,
                heatOfCombustion: 46_000_000,
                explosionEfficiency: 0.1,
                receptorDistance: 100
            )
        )

        #expect(
            result.availableCombustionEnergy
            == 46000000000
        )

        #expect(
            result.explosionEnergy
            == 4600000000
        )

        #expect(
            abs(
                result.tntEquivalentMass
                - 1099.4263862332696
            ) < 1e-10
        )

        #expect(
            abs(
                result.cubeRootScaledDistance
                - 9.6889775152195234
            ) < 1e-12
        )
    }

    @Test("Scaled distance rises with receptor distance")
    func distanceEffect() throws {
        let near = try engine.calculate(
            .init(
                flammableMass: 1_000,
                heatOfCombustion: 46_000_000,
                explosionEfficiency: 0.1,
                receptorDistance: 50
            )
        )

        let far = try engine.calculate(
            .init(
                flammableMass: 1_000,
                heatOfCombustion: 46_000_000,
                explosionEfficiency: 0.1,
                receptorDistance: 100
            )
        )

        #expect(
            abs(
                far.cubeRootScaledDistance
                / near.cubeRootScaledDistance
                - 2
            ) < 1e-12
        )
    }

    @Test("Rejects invalid explosion efficiency")
    func validation() {
        #expect(
            throws:
                TNTEquivalentExplosionScreeningError
                    .invalidExplosionEfficiency
        ) {
            try engine.calculate(
                .init(
                    flammableMass: 1_000,
                    heatOfCombustion: 46_000_000,
                    explosionEfficiency: 0,
                    receptorDistance: 100
                )
            )
        }
    }
}
