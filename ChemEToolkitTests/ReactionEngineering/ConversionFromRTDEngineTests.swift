import Testing
@testable import ChemEToolkit
@Suite("Conversion from RTD Engine")
struct ConversionFromRTDEngineTests {
    private let engine = ConversionFromRTDEngine()
    @Test("Calculates conversion") func conversion() throws {
        let r = try engine.calculate(.init(firstOrderRateConstant:0.2, times:[0,2,4,6,8], eValues:[0,0.125,0.375,0.125,0]))
        #expect(abs(r.rawRTDArea - 1.25) < 1e-12)
        #expect(abs(r.meanResidenceTime - 4) < 1e-12)
        #expect(r.conversionFraction > 0)
        #expect(r.conversionFraction < 1)
    }
    @Test("Scaling is irrelevant") func scaling() throws {
        let a = try engine.calculate(.init(firstOrderRateConstant:0.2, times:[0,2,4,6,8], eValues:[0,0.125,0.375,0.125,0]))
        let b = try engine.calculate(.init(firstOrderRateConstant:0.2, times:[0,2,4,6,8], eValues:[0,1.25,3.75,1.25,0]))
        #expect(abs(a.conversionFraction - b.conversionFraction) < 1e-12)
    }
    @Test("Rejects negative E") func invalid() {
        #expect(throws: ConversionFromRTDError.negativeEValue) {
            try engine.calculate(.init(firstOrderRateConstant:0.2, times:[0,1], eValues:[1,-1]))
        }
    }
}
