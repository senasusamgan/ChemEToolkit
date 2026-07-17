import Testing
@testable import ChemEToolkit

@Suite("Linear Interpolation Calculator Engine")
struct LinearInterpolationCalculatorEngineTests {
    private let engine =
        LinearInterpolationCalculatorEngine()

    @Test("Interpolates between two points")
    func interpolation() throws {
        let result = try engine.calculate(
            .init(
                x1: 10,
                y1: 100,
                x2: 20,
                y2: 180,
                targetX: 15
            )
        )

        #expect(result.interpolatedY == 140)
        #expect(result.interpolationFraction == 0.5)
        #expect(result.slope == 8)
        #expect(!result.isExtrapolation)
    }

    @Test("Detects extrapolation")
    func extrapolation() throws {
        let result = try engine.calculate(
            .init(
                x1: 10,
                y1: 100,
                x2: 20,
                y2: 180,
                targetX: 25
            )
        )

        #expect(result.interpolatedY == 220)
        #expect(result.isExtrapolation)
    }

    @Test("Rejects identical x-values")
    func validation() {
        #expect(
            throws:
                LinearInterpolationCalculatorError
                    .identicalXValues
        ) {
            try engine.calculate(
                .init(
                    x1: 10,
                    y1: 100,
                    x2: 10,
                    y2: 180,
                    targetX: 15
                )
            )
        }
    }
}
