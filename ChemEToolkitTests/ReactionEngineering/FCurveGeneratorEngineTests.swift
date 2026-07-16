import Testing
@testable import ChemEToolkit

@Suite("F-Curve Generator Engine")
struct FCurveGeneratorEngineTests {
    private let engine =
        FCurveGeneratorEngine()

    @Test("Generates cumulative RTD and quantiles")
    func generatesFCurve() throws {
        let result = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8],
                eValues:
                    [0, 0.1, 0.3, 0.1, 0]
            )
        )

        #expect(
            result.fValues.count == 5
        )
        #expect(
            abs(result.fValues[1] - 0.1)
            < 1e-12
        )
        #expect(
            abs(result.fValues[2] - 0.5)
            < 1e-12
        )
        #expect(
            abs(result.fValues[3] - 0.9)
            < 1e-12
        )
        #expect(result.fValues[4] == 1)
        #expect(
            abs(
                result.timeAtTenPercent
                - 2
            ) < 1e-12
        )
        #expect(
            abs(
                result.medianResidenceTime
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.timeAtNinetyPercent
                - 6
            ) < 1e-12
        )
    }

    @Test("Normalizes an unscaled E curve")
    func normalization() throws {
        let result = try engine.calculate(
            .init(
                times: [0, 2, 4, 6, 8],
                eValues: [0, 1, 3, 1, 0]
            )
        )

        #expect(
            abs(result.rawEArea - 10)
            < 1e-12
        )
        #expect(
            abs(result.fValues.last! - 1)
            < 1e-12
        )
    }

    @Test("Rejects invalid E data")
    func validation() {
        #expect(
            throws:
                FCurveGeneratorError
                    .nonIncreasingTime
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1, 1],
                    eValues: [0, 1, 0]
                )
            )
        }

        #expect(
            throws:
                FCurveGeneratorError
                    .negativeEValue
        ) {
            try engine.calculate(
                .init(
                    times: [0, 1],
                    eValues: [1, -1]
                )
            )
        }
    }
}
