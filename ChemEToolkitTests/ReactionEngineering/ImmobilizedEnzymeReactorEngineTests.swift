import Testing
@testable import ChemEToolkit

@Suite("Immobilized Enzyme Reactor Engine")
struct ImmobilizedEnzymeReactorEngineTests {
    private let engine = ImmobilizedEnzymeReactorEngine()

    @Test("Calculates pellet effectiveness") func effectiveness() throws {
        let r = try engine.calculate(.init(
            sphericalPelletRadius: 0.001, effectiveDiffusivity: 1e-9,
            maximumVolumetricRate: 0.01, michaelisConstant: 10,
            bulkSubstrateConcentration: 2, totalPelletVolume: 0.5
        ))
        #expect(abs(r.thieleModulus - 1) < 1e-12)
        #expect(abs(r.effectivenessFactor - 0.93910585649799438) < 1e-12)
        #expect(abs(r.observedVolumetricRate - 0.0015651764274966574) < 1e-12)
    }

    @Test("Small pellet approaches unit effectiveness") func smallPellet() throws {
        let r = try engine.calculate(.init(
            sphericalPelletRadius: 1e-8, effectiveDiffusivity: 1e-9,
            maximumVolumetricRate: 0.01, michaelisConstant: 10,
            bulkSubstrateConcentration: 2, totalPelletVolume: 0.5
        ))
        #expect(abs(r.effectivenessFactor - 1) < 1e-8)
    }

    @Test("Rejects invalid radius") func validation() {
        #expect(throws: ImmobilizedEnzymeReactorError.nonPositivePelletProperty) {
            try engine.calculate(.init(
                sphericalPelletRadius: 0, effectiveDiffusivity: 1e-9,
                maximumVolumetricRate: 0.01, michaelisConstant: 10,
                bulkSubstrateConcentration: 2, totalPelletVolume: 0.5
            ))
        }
    }
}
