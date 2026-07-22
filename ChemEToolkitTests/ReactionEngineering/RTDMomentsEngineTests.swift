import Testing
@testable import ChemEToolkit
@Suite("RTD Moments Engine")
struct RTDMomentsEngineTests {
    private let engine = RTDMomentsEngine()
    @Test("Calculates moments") func moments() throws {
        let r = try engine.calculate(.init(times:[0,2,4,6,8], concentrations:[0,1,3,1,0]))
        #expect(abs(r.tracerArea - 10) < 1e-12)
        #expect(abs(r.meanResidenceTime - 4) < 1e-12)
        #expect(abs(r.variance - 1.6) < 1e-12)
    }
    @Test("Rejects mismatch") func mismatch() {
        #expect(throws: RTDMomentsError.mismatchedArrays) {
            try engine.calculate(.init(times:[0,1], concentrations:[1]))
        }
    }
    @Test("Rejects negative concentration") func negative() {
        #expect(throws: RTDMomentsError.negativeConcentration) {
            try engine.calculate(.init(times:[0,1], concentrations:[1,-1]))
        }
    }
}
