import Testing
@testable import ChemEToolkit

@Suite("Input Validator")
struct InputValidatorTests {
    private let tolerance = 1e-12

    @Test("Parses period decimal separator")
    func parsesPeriodDecimal() throws {
        let value =
            try InputValidator.parseNumber(
                "0.25",
                fieldName: "Value"
            )

        #expect(
            abs(value - 0.25) < tolerance
        )
    }

    @Test("Parses comma decimal separator")
    func parsesCommaDecimal() throws {
        let value =
            try InputValidator.parseNumber(
                "0,25",
                fieldName: "Value"
            )

        #expect(
            abs(value - 0.25) < tolerance
        )
    }

    @Test("Parses scientific notation")
    func parsesScientificNotation() throws {
        let value =
            try InputValidator.parseNumber(
                "1.25e-3",
                fieldName: "Value"
            )

        #expect(
            abs(value - 0.00125) <
            tolerance
        )
    }

    @Test("Parses European grouped number")
    func parsesEuropeanGroupedNumber()
        throws {

        let value =
            try InputValidator.parseNumber(
                "1.234,56",
                fieldName: "Value"
            )

        #expect(
            abs(value - 1234.56) <
            tolerance
        )
    }
}
