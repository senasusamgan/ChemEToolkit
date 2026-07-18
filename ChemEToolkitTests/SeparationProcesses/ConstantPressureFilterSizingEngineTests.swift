import Testing
@testable import ChemEToolkit

@Suite("Constant Pressure Filter Sizing Engine")
struct ConstantPressureFilterSizingEngineTests {
    private let engine = ConstantPressureFilterSizingEngine()

    @Test("Calculates filtration time contributions")
    func time() throws {
        let r = try engine.calculate(.init(
            filtrateVolume: 10, filterArea: 5, pressureDrop: 200000, liquidViscosity: 0.001,
            mediumResistance: 1e11, specificCakeResistance: 1e11, solidsPerFiltrateVolume: 20
        ))
        #expect(r.totalFiltrationTime > 0)
        #expect(abs(r.totalFiltrationTime - (r.mediumTimeContribution + r.cakeTimeContribution)) < 1e-9)
    }

    @Test("Larger filter area reduces time")
    func trend() throws {
        let a = try engine.calculate(.init(filtrateVolume: 10, filterArea: 5, pressureDrop: 200000, liquidViscosity: 0.001, mediumResistance: 1e11, specificCakeResistance: 1e11, solidsPerFiltrateVolume: 20))
        let b = try engine.calculate(.init(filtrateVolume: 10, filterArea: 10, pressureDrop: 200000, liquidViscosity: 0.001, mediumResistance: 1e11, specificCakeResistance: 1e11, solidsPerFiltrateVolume: 20))
        #expect(b.totalFiltrationTime < a.totalFiltrationTime)
    }

    @Test("Rejects negative resistance")
    func validation() {
        #expect(throws: ConstantPressureFilterSizingError.invalidResistance) {
            try engine.calculate(.init(filtrateVolume: 10, filterArea: 5, pressureDrop: 200000, liquidViscosity: 0.001, mediumResistance: -1, specificCakeResistance: 1e11, solidsPerFiltrateVolume: 20))
        }
    }
}
