import Testing
@testable import ChemEToolkit

@Suite("Mass Fraction Calculator Engine")
struct MassFractionCalculatorEngineTests {
    private let engine =
        MassFractionCalculatorEngine()

    @Test("Calculates mass fractions")
    func massFraction() throws {
        let result = try engine.calculate(
            .init(
                componentMass: 25,
                otherMass: 75
            )
        )

        #expect(result.totalMass == 100)
        #expect(result.componentMassFraction == 0.25)
        #expect(result.otherMassFraction == 0.75)
        #expect(result.componentMassPercent == 25)
    }

    @Test("Pure component gives unit mass fraction")
    func pureComponent() throws {
        let result = try engine.calculate(
            .init(
                componentMass: 10,
                otherMass: 0
            )
        )

        #expect(result.componentMassFraction == 1)
    }

    @Test("Rejects negative mass")
    func validation() {
        #expect(
            throws:
                MassFractionCalculatorError
                    .negativeMass
        ) {
            try engine.calculate(
                .init(
                    componentMass: -1,
                    otherMass: 1
                )
            )
        }
    }
}
