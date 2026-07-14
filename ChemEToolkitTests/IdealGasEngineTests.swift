import Testing
@testable import ChemEToolkit

@Suite("Ideal Gas Engine")
struct IdealGasEngineTests {
    private let engine = IdealGasEngine()

    private let referencePressure = 249.43387854
    private let tolerance = 0.00000001

    @Test("Calculates pressure using PV = nRT")
    func calculatesPressure() throws {
        let input = IdealGasInput(
            pressure: nil,
            volume: 10,
            moles: 1,
            temperature: 300
        )

        let result = try engine.solve(
            unknownVariable: .pressure,
            input: input
        )

        #expect(result.variable == .pressure)
        #expect(
            abs(result.value - referencePressure) < tolerance
        )
    }

    @Test("Calculates volume using PV = nRT")
    func calculatesVolume() throws {
        let input = IdealGasInput(
            pressure: referencePressure,
            volume: nil,
            moles: 1,
            temperature: 300
        )

        let result = try engine.solve(
            unknownVariable: .volume,
            input: input
        )

        #expect(result.variable == .volume)
        #expect(abs(result.value - 10) < tolerance)
    }

    @Test("Calculates amount of substance")
    func calculatesMoles() throws {
        let input = IdealGasInput(
            pressure: referencePressure,
            volume: 10,
            moles: nil,
            temperature: 300
        )

        let result = try engine.solve(
            unknownVariable: .moles,
            input: input
        )

        #expect(result.variable == .moles)
        #expect(abs(result.value - 1) < tolerance)
    }

    @Test("Calculates temperature")
    func calculatesTemperature() throws {
        let input = IdealGasInput(
            pressure: referencePressure,
            volume: 10,
            moles: 1,
            temperature: nil
        )

        let result = try engine.solve(
            unknownVariable: .temperature,
            input: input
        )

        #expect(result.variable == .temperature)
        #expect(abs(result.value - 300) < tolerance)
    }

    @Test("Rejects a zero volume")
    func rejectsZeroVolume() {
        let input = IdealGasInput(
            pressure: nil,
            volume: 0,
            moles: 1,
            temperature: 300
        )

        #expect(
            throws: CalculationError.valueMustBePositive(
                fieldName: "Volume"
            )
        ) {
            try engine.solve(
                unknownVariable: .pressure,
                input: input
            )
        }
    }

    @Test("Rejects a missing required value")
    func rejectsMissingTemperature() {
        let input = IdealGasInput(
            pressure: nil,
            volume: 10,
            moles: 1,
            temperature: nil
        )

        #expect(
            throws: CalculationError.emptyField(
                fieldName: "Temperature"
            )
        ) {
            try engine.solve(
                unknownVariable: .pressure,
                input: input
            )
        }
    }
}
