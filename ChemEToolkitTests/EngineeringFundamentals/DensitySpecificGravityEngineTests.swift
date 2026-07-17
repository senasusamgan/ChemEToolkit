import Testing
@testable import ChemEToolkit

@Suite("Density and Specific Gravity Engine")
struct DensitySpecificGravityEngineTests {
    private let engine =
        DensitySpecificGravityEngine()

    @Test("Calculates density and specific gravity")
    func density() throws {
        let result = try engine.calculate(
            .init(
                mass: 1200,
                volume: 1.5,
                referenceDensity: 1000
            )
        )

        #expect(result.density == 800)
        #expect(result.specificGravity == 0.8)
        #expect(result.specificVolume == 0.00125)
    }

    @Test("Zero mass gives zero density")
    func zeroMass() throws {
        let result = try engine.calculate(
            .init(
                mass: 0,
                volume: 1,
                referenceDensity: 1000
            )
        )

        #expect(result.density == 0)
        #expect(result.specificVolume == .infinity)
    }

    @Test("Rejects zero volume")
    func validation() {
        #expect(
            throws:
                DensitySpecificGravityError
                    .nonPositiveVolume
        ) {
            try engine.calculate(
                .init(
                    mass: 1,
                    volume: 0,
                    referenceDensity: 1000
                )
            )
        }
    }
}
