import Testing
@testable import ChemEToolkit

@Suite("Cyclone Cut Diameter Engine")
struct CycloneCutDiameterEngineTests {
    private let engine = CycloneCutDiameterEngine()

    @Test("Calculates positive cut diameter")
    func diameter() throws {
        let r = try engine.calculate(.init(gasViscosity: 0.000018, inletWidth: 0.20, effectiveTurns: 5, particleDensity: 2500, gasDensity: 1.2, inletVelocity: 15))
        #expect(r.cutDiameter > 0)
        #expect(r.densityDifference > 0)
    }

    @Test("Higher velocity lowers cut diameter")
    func trend() throws {
        let a = try engine.calculate(.init(gasViscosity: 0.000018, inletWidth: 0.20, effectiveTurns: 5, particleDensity: 2500, gasDensity: 1.2, inletVelocity: 10))
        let b = try engine.calculate(.init(gasViscosity: 0.000018, inletWidth: 0.20, effectiveTurns: 5, particleDensity: 2500, gasDensity: 1.2, inletVelocity: 20))
        #expect(b.cutDiameter < a.cutDiameter)
    }

    @Test("Rejects particle density below gas density")
    func validation() {
        #expect(throws: CycloneCutDiameterError.invalidDensityDifference) {
            try engine.calculate(.init(gasViscosity: 0.000018, inletWidth: 0.20, effectiveTurns: 5, particleDensity: 1, gasDensity: 1.2, inletVelocity: 15))
        }
    }
}
