import Testing
@testable import ChemEToolkit

@Suite("Mole Fraction Calculator Engine")
struct MoleFractionCalculatorEngineTests {
    private let engine =
        MoleFractionCalculatorEngine()

    @Test("Calculates mole fractions")
    func moleFraction() throws {
        let result = try engine.calculate(
            .init(
                componentMoles: 2,
                otherMoles: 8
            )
        )

        #expect(result.totalMoles == 10)
        #expect(result.componentMoleFraction == 0.2)
        #expect(result.otherMoleFraction == 0.8)
        #expect(result.componentMolePercent == 20)
    }

    @Test("Pure component gives unit mole fraction")
    func pureComponent() throws {
        let result = try engine.calculate(
            .init(
                componentMoles: 5,
                otherMoles: 0
            )
        )

        #expect(result.componentMoleFraction == 1)
        #expect(result.otherMoleFraction == 0)
    }

    @Test("Rejects zero total moles")
    func validation() {
        #expect(
            throws:
                MoleFractionCalculatorError
                    .zeroTotalMoles
        ) {
            try engine.calculate(
                .init(
                    componentMoles: 0,
                    otherMoles: 0
                )
            )
        }
    }
}
