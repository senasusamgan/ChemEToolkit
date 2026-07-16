import Testing
@testable import ChemEToolkit

@Suite("Cubic Routh-Hurwitz Stability Engine")
struct CubicRouthHurwitzStabilityEngineTests {
    private let engine = CubicRouthHurwitzStabilityEngine()

    @Test("Identifies a stable cubic")
    func stable() throws {
        let result = try engine.calculate(.init(quadraticCoefficient: 6, linearCoefficient: 11, constantCoefficient: 6))
        #expect(result.firstColumnOne == 1)
        #expect(result.firstColumnTwo == 6)
        #expect(result.firstColumnThree == 10)
        #expect(result.firstColumnFour == 6)
        #expect(result.signChangeCount == 0)
        #expect(result.isAsymptoticallyStable)
        #expect(result.stabilityMargin == 60)
    }

    @Test("Counts right-half-plane roots")
    func unstable() throws {
        let result = try engine.calculate(.init(quadraticCoefficient: 2, linearCoefficient: 1, constantCoefficient: 3))
        #expect(result.firstColumnThree == -0.5)
        #expect(result.signChangeCount == 2)
        #expect(!result.isAsymptoticallyStable)
    }

    @Test("Rejects singular cases")
    func validation() {
        #expect(throws: CubicRouthHurwitzStabilityError.zeroQuadraticCoefficient) {
            try engine.calculate(.init(quadraticCoefficient: 0, linearCoefficient: 1, constantCoefficient: 1))
        }
        #expect(throws: CubicRouthHurwitzStabilityError.singularRouthCase) {
            try engine.calculate(.init(quadraticCoefficient: 2, linearCoefficient: 1, constantCoefficient: 2))
        }
    }
}
