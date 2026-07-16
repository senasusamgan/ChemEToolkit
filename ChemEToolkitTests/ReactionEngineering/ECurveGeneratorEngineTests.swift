import Testing
@testable import ChemEToolkit

@Suite("E-Curve Generator Engine")
struct ECurveGeneratorEngineTests {
    private let engine =
        ECurveGeneratorEngine()

    @Test("Normalizes pulse-tracer data")
    func generatesECurve() throws {
        let result = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8],
                tracerConcentrations:
                    [0, 1, 3, 1, 0]
            )
        )

        #expect(
            abs(
                result.rawTracerArea
                - 10
            ) < 1e-12
        )
        #expect(
            abs(
                result.normalizedArea
                - 1
            ) < 1e-12
        )
        #expect(
            abs(
                result.meanResidenceTime
                - 4
            ) < 1e-12
        )
        #expect(result.peakTime == 4)
        #expect(
            abs(
                result.peakEValue
                - 0.3
            ) < 1e-12
        )
    }

    @Test("Concentration scaling does not change E")
    func scalingInvariance() throws {
        let first = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8],
                tracerConcentrations:
                    [0, 1, 3, 1, 0]
            )
        )

        let second = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8],
                tracerConcentrations:
                    [0, 10, 30, 10, 0]
            )
        )

        #expect(
            first.eValues
            == second.eValues
        )
    }

    @Test("Rejects invalid tracer data")
    func validation() {
        #expect(
            throws:
                ECurveGeneratorError
                    .mismatchedArrays
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1],
                    tracerConcentrations: [1]
                )
            )
        }

        #expect(
            throws:
                ECurveGeneratorError
                    .negativeConcentration
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1],
                    tracerConcentrations:
                        [1, -1]
                )
            )
        }

        #expect(
            throws:
                ECurveGeneratorError
                    .zeroTracerArea
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1],
                    tracerConcentrations:
                        [0, 0]
                )
            )
        }
    }
}
