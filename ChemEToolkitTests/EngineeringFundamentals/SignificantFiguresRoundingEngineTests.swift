import Testing
@testable import ChemEToolkit

@Suite("Significant Figures Rounding Engine")
struct SignificantFiguresRoundingEngineTests {
    private let engine =
        SignificantFiguresRoundingEngine()

    @Test("Rounds to four significant digits")
    func rounding() throws {
        let result = try engine.calculate(
            .init(
                value: 12345.678,
                significantDigitCount: 4
            )
        )

        #expect(result.roundedValue == 12350)
        #expect(result.decimalPlacesApplied == -1)
        #expect(result.significantDigitCount == 4)
    }

    @Test("Rounds a small decimal")
    func smallValue() throws {
        let result = try engine.calculate(
            .init(
                value: 0.00123456,
                significantDigitCount: 3
            )
        )

        #expect(
            abs(
                result.roundedValue
                - 0.00123
            ) < 1e-15
        )
    }

    @Test("Rejects noninteger significant digits")
    func validation() {
        #expect(
            throws:
                SignificantFiguresRoundingError
                    .invalidSignificantDigitCount
        ) {
            try engine.calculate(
                .init(
                    value: 10,
                    significantDigitCount: 2.5
                )
            )
        }
    }
}
