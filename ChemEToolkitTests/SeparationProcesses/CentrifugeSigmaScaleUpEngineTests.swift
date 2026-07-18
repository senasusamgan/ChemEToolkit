import Testing
@testable import ChemEToolkit

@Suite("Centrifuge Sigma Scale Up Engine")
struct CentrifugeSigmaScaleUpEngineTests {
    private let engine = CentrifugeSigmaScaleUpEngine()

    @Test("Scales throughput by sigma ratio")
    func scaleUp() throws {
        let r = try engine.calculate(.init(referenceThroughput: 10, referenceSigmaFactor: 5000, targetSigmaFactor: 12000, efficiencyCorrection: 0.85))
        #expect(abs(r.sigmaRatio - 2.4) < 1e-12)
        #expect(abs(r.correctedTargetThroughput - 20.4) < 1e-12)
    }

    @Test("Higher target sigma increases throughput")
    func trend() throws {
        let a = try engine.calculate(.init(referenceThroughput: 10, referenceSigmaFactor: 5000, targetSigmaFactor: 8000, efficiencyCorrection: 0.85))
        let b = try engine.calculate(.init(referenceThroughput: 10, referenceSigmaFactor: 5000, targetSigmaFactor: 12000, efficiencyCorrection: 0.85))
        #expect(b.correctedTargetThroughput > a.correctedTargetThroughput)
    }

    @Test("Rejects correction above one")
    func validation() {
        #expect(throws: CentrifugeSigmaScaleUpError.invalidCorrection) {
            try engine.calculate(.init(referenceThroughput: 10, referenceSigmaFactor: 5000, targetSigmaFactor: 12000, efficiencyCorrection: 1.2))
        }
    }
}
