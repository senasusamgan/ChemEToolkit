import Testing
@testable import ChemEToolkit

@Suite("Concentration Engine")
struct ConcentrationEngineTests {
    private let engine = ConcentrationEngine()
    private let tolerance = 0.00000001

    @Test("Calculates molarity")
    func calculatesMolarity() throws {
        let input = ConcentrationInput(
            concentration: nil,
            moles: 2,
            denominator: 4
        )

        let result = try engine.solve(
            mode: .molarity,
            unknownVariable: .concentration,
            input: input
        )

        #expect(result.mode == .molarity)
        #expect(result.variable == .concentration)
        #expect(abs(result.value - 0.5) < tolerance)
        #expect(result.unit == "mol/L")
    }

    @Test("Calculates amount of solute")
    func calculatesMoles() throws {
        let input = ConcentrationInput(
            concentration: 0.5,
            moles: nil,
            denominator: 4
        )

        let result = try engine.solve(
            mode: .molarity,
            unknownVariable: .moles,
            input: input
        )

        #expect(result.variable == .moles)
        #expect(abs(result.value - 2) < tolerance)
        #expect(result.unit == "mol")
    }

    @Test("Calculates solution volume")
    func calculatesSolutionVolume() throws {
        let input = ConcentrationInput(
            concentration: 0.5,
            moles: 2,
            denominator: nil
        )

        let result = try engine.solve(
            mode: .molarity,
            unknownVariable: .denominator,
            input: input
        )

        #expect(abs(result.value - 4) < tolerance)
        #expect(result.label == "Solution Volume")
        #expect(result.unit == "L")
    }

    @Test("Calculates molality")
    func calculatesMolality() throws {
        let input = ConcentrationInput(
            concentration: nil,
            moles: 3,
            denominator: 2
        )

        let result = try engine.solve(
            mode: .molality,
            unknownVariable: .concentration,
            input: input
        )

        #expect(result.mode == .molality)
        #expect(abs(result.value - 1.5) < tolerance)
        #expect(result.unit == "mol/kg")
    }

    @Test("Rejects zero denominator")
    func rejectsZeroDenominator() {
        let input = ConcentrationInput(
            concentration: nil,
            moles: 2,
            denominator: 0
        )

        #expect(
            throws: CalculationError.valueMustBePositive(
                fieldName: "Solution Volume"
            )
        ) {
            try engine.solve(
                mode: .molarity,
                unknownVariable: .concentration,
                input: input
            )
        }
    }

    @Test("Rejects negative amount of solute")
    func rejectsNegativeMoles() {
        let input = ConcentrationInput(
            concentration: nil,
            moles: -1,
            denominator: 2
        )

        #expect(
            throws: CalculationError.valueCannotBeNegative(
                fieldName: "Amount of Solute"
            )
        ) {
            try engine.solve(
                mode: .molality,
                unknownVariable: .concentration,
                input: input
            )
        }
    }
}
