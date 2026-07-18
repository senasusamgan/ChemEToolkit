import Testing
@testable import ChemEToolkit

@Suite("Hydrocyclone Separation Number Engine")
struct HydrocycloneSeparationNumberEngineTests {
    private let engine = HydrocycloneSeparationNumberEngine()

    @Test("Calculates positive separation index")
    func index() throws {
        let r = try engine.calculate(.init(particleDiameter: 0.00005, particleDensity: 2500, liquidDensity: 1000, liquidViscosity: 0.001, tangentialVelocity: 10, cycloneRadius: 0.10))
        #expect(r.radialSettlingVelocity > 0)
        #expect(r.centrifugalGForce > 1)
    }

    @Test("Larger particles increase radial settling")
    func trend() throws {
        let a = try engine.calculate(.init(particleDiameter: 0.00003, particleDensity: 2500, liquidDensity: 1000, liquidViscosity: 0.001, tangentialVelocity: 10, cycloneRadius: 0.10))
        let b = try engine.calculate(.init(particleDiameter: 0.00006, particleDensity: 2500, liquidDensity: 1000, liquidViscosity: 0.001, tangentialVelocity: 10, cycloneRadius: 0.10))
        #expect(b.radialSettlingVelocity > a.radialSettlingVelocity)
    }

    @Test("Rejects particle density below liquid density")
    func validation() {
        #expect(throws: HydrocycloneSeparationNumberError.invalidDensityDifference) {
            try engine.calculate(.init(particleDiameter: 0.00005, particleDensity: 900, liquidDensity: 1000, liquidViscosity: 0.001, tangentialVelocity: 10, cycloneRadius: 0.10))
        }
    }
}
