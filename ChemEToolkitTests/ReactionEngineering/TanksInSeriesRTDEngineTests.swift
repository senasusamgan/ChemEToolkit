import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Tanks-in-Series RTD Engine")
struct TanksInSeriesRTDEngineTests {
    private let engine = TanksInSeriesRTDEngine()
    @Test("Evaluates four tanks") func four() throws {
        let r = try engine.calculate(.init(meanResidenceTime:10, numberOfTanks:4, evaluationTime:8))
        #expect(r.numberOfTanks == 4)
        #expect(abs(r.dimensionlessVariance - 0.25) < 1e-12)
        #expect(abs(r.variance - 25) < 1e-12)
        #expect(abs(r.peakTime - 7.5) < 1e-12)
    }
    @Test("One tank is exponential") func one() throws {
        let r = try engine.calculate(.init(meanResidenceTime:10, numberOfTanks:1, evaluationTime:10))
        #expect(abs(r.eValue - exp(-1)/10) < 1e-12)
    }
    @Test("Rejects fractional count") func invalid() {
        #expect(throws: TanksInSeriesRTDError.invalidTankCount) {
            try engine.calculate(.init(meanResidenceTime:10, numberOfTanks:2.5, evaluationTime:8))
        }
    }
}
