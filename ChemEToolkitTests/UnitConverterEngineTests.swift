import Testing
@testable import ChemEToolkit

@Suite("Unit Converter Engine")
struct UnitConverterEngineTests {
    private let engine = UnitConverterEngine()
    private let tolerance = 0.00000001

    @Test("Converts Celsius to Kelvin")
    func convertsCelsiusToKelvin() throws {
        let result = try engine.convert(
            value: 25,
            from: .celsius,
            to: .kelvin
        )

        #expect(
            abs(result.outputValue - 298.15) <
            tolerance
        )

        #expect(result.fromUnit == .celsius)
        #expect(result.toUnit == .kelvin)
    }

    @Test("Converts Fahrenheit to Celsius")
    func convertsFahrenheitToCelsius() throws {
        let result = try engine.convert(
            value: 32,
            from: .fahrenheit,
            to: .celsius
        )

        #expect(
            abs(result.outputValue) <
            tolerance
        )
    }

    @Test("Converts kilopascal to bar")
    func convertsKilopascalToBar() throws {
        let result = try engine.convert(
            value: 100,
            from: .kilopascal,
            to: .bar
        )

        #expect(
            abs(result.outputValue - 1) <
            tolerance
        )
    }

    @Test("Converts liter to cubic meter")
    func convertsLiterToCubicMeter() throws {
        let result = try engine.convert(
            value: 1_000,
            from: .liter,
            to: .cubicMeter
        )

        #expect(
            abs(result.outputValue - 1) <
            tolerance
        )
    }

    @Test("Converts kilogram to gram")
    func convertsKilogramToGram() throws {
        let result = try engine.convert(
            value: 2.5,
            from: .kilogram,
            to: .gram
        )

        #expect(
            abs(result.outputValue - 2_500) <
            tolerance
        )
    }

    @Test("Converts kilojoule to kilocalorie")
    func convertsKilojouleToKilocalorie() throws {
        let result = try engine.convert(
            value: 4.184,
            from: .kilojoule,
            to: .kilocalorie
        )

        #expect(
            abs(result.outputValue - 1) <
            tolerance
        )
    }

    @Test("Returns the same value for identical units")
    func convertsIdenticalUnits() throws {
        let result = try engine.convert(
            value: 42.5,
            from: .pascal,
            to: .pascal
        )

        #expect(
            abs(result.outputValue - 42.5) <
            tolerance
        )
    }

    @Test("Rejects units from different categories")
    func rejectsDifferentCategories() {
        #expect(
            throws: CalculationError.calculationFailed(
                reason:
                    "Units from different categories cannot be converted."
            )
        ) {
            try engine.convert(
                value: 10,
                from: .kilogram,
                to: .liter
            )
        }
    }
}
