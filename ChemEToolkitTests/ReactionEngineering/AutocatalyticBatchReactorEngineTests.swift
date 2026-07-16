import Testing
@testable import ChemEToolkit

@Suite("Autocatalytic Batch Reactor Engine")
struct AutocatalyticBatchReactorEngineTests {
    private let engine =
        AutocatalyticBatchReactorEngine()

    @Test("Calculates autocatalytic batch time")
    func calculatesTime() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                initialConcentrationB: 0.1,
                rateConstant: 0.5,
                targetConversionA: 0.9
            )
        )

        #expect(
            abs(
                result.timeToTargetConversion
                - 8.3730367017965293
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalConcentrationA
                - 0.1
            ) < 1e-12
        )
        #expect(
            abs(
                result.finalConcentrationB
                - 1
            ) < 1e-12
        )
        #expect(
            abs(
                result.conversionAtMaximumRate
                - 0.45000000000000001
            ) < 1e-12
        )
        #expect(
            abs(
                result.maximumReactionRate
                - 0.15125000000000002
            ) < 1e-12
        )
    }

    @Test("Large initial autocatalyst gives maximum rate at start")
    func maximumAtStart() throws {
        let result = try engine.calculate(
            .init(
                initialConcentrationA: 1,
                initialConcentrationB: 2,
                rateConstant: 0.5,
                targetConversionA: 0.5
            )
        )

        #expect(
            result.conversionAtMaximumRate
            == 0
        )
        #expect(
            result.maximumReactionRate
            == result.initialReactionRate
        )
    }

    @Test("Rejects missing autocatalyst seed")
    func validation() {
        #expect(
            throws:
                AutocatalyticBatchReactorError
                    .nonPositiveInitialConcentration
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    initialConcentrationB: 0,
                    rateConstant: 0.5,
                    targetConversionA: 0.9
                )
            )
        }

        #expect(
            throws:
                AutocatalyticBatchReactorError
                    .conversionOutOfRange
        ) {
            try engine.calculate(
                .init(
                    initialConcentrationA: 1,
                    initialConcentrationB: 0.1,
                    rateConstant: 0.5,
                    targetConversionA: 1
                )
            )
        }
    }
}
