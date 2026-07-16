import Testing
@testable import ChemEToolkit

@Suite("Segregation Model Conversion Engine")
struct SegregationModelConversionEngineTests {
    private let engine =
        SegregationModelConversionEngine()

    @Test("Calculates second-order segregation conversion")
    func secondOrder() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                rateConstant: 0.2,
                reactionOrder: 2,
                times: [0, 2, 4, 6, 8],
                eValues:
                    [0, 0.1, 0.3, 0.1, 0]
            )
        )

        #expect(
            abs(
                result.meanResidenceTime
                - 4
            ) < 1e-12
        )
        #expect(
            abs(
                result.outletConcentrationA
                - 0.5670995670995671
            ) < 1e-12
        )
        #expect(
            abs(
                result.conversionFraction
                - 0.4329004329004329
            ) < 1e-12
        )
        #expect(
            abs(
                result.equivalentPFRConversion
                - 0.44444444444444442
            ) < 1e-12
        )
    }

    @Test("Handles zero-order finite depletion")
    func zeroOrderDepletion() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                rateConstant: 1,
                reactionOrder: 0,
                times: [0, 1, 2],
                eValues: [0, 1, 0]
            )
        )

        #expect(
            abs(
                result.conversionFraction
                - 1
            ) < 1e-12
        )
        #expect(
            result.batchConcentrations[1]
            == 0
        )
    }

    @Test("Rejects invalid kinetics and RTD")
    func validation() {
        #expect(
            throws:
                SegregationModelConversionError
                    .reactionOrderOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    rateConstant: 0.2,
                    reactionOrder: 4,
                    times: [0, 1],
                    eValues: [0, 1]
                )
            )
        }

        #expect(
            throws:
                SegregationModelConversionError
                    .negativeEValue
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    rateConstant: 0.2,
                    reactionOrder: 2,
                    times: [0, 1],
                    eValues: [1, -1]
                )
            )
        }

        #expect(
            throws:
                SegregationModelConversionError
                    .nonPositiveRateConstant
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    rateConstant: 0,
                    reactionOrder: 2,
                    times: [0, 1],
                    eValues: [0, 1]
                )
            )
        }
    }
}
