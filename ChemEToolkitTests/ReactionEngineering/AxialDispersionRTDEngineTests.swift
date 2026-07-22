import Testing
@testable import ChemEToolkit
@Suite("Axial-Dispersion RTD Engine")
struct AxialDispersionRTDEngineTests {
    private let engine = AxialDispersionRTDEngine()
    @Test("Evaluates mean time") func mean() throws {
        let r = try engine.calculate(.init(meanResidenceTime:10, pecletNumber:20, evaluationTime:10))
        #expect(abs(r.dimensionlessTime - 1) < 1e-12)
        #expect(abs(r.dimensionlessVariance - 0.1) < 1e-12)
        #expect(abs(r.equivalentTanksInSeries - 10) < 1e-12)
    }
    @Test("Higher Peclet narrows RTD") func effect() throws {
        let a = try engine.calculate(.init(meanResidenceTime:10, pecletNumber:10, evaluationTime:10))
        let b = try engine.calculate(.init(meanResidenceTime:10, pecletNumber:100, evaluationTime:10))
        #expect(b.variance < a.variance)
    }
    @Test("Rejects invalid Peclet") func invalid() {
        #expect(throws: AxialDispersionRTDError.pecletOutOfRange) {
            try engine.calculate(.init(meanResidenceTime:10, pecletNumber:0.01, evaluationTime:10))
        }
    }
}
