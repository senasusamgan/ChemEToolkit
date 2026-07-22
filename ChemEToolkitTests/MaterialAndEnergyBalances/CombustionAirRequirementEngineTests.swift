import Testing
@testable import ChemEToolkit

@Suite("Combustion Air Requirement Engine")
struct CombustionAirRequirementEngineTests {
    private let engine =
        CombustionAirRequirementEngine()

    @Test("Calculates methane combustion with excess air")
    func methane() throws {
        let result = try engine.calculate(
            .init(
                fuelMolarFlow: 10,
                carbonAtomsPerMolecule: 1,
                hydrogenAtomsPerMolecule: 4,
                oxygenAtomsPerMolecule: 0,
                excessAirFraction: 0.20,
                oxygenMoleFractionInAir: 0.21
            )
        )

        #expect(result.stoichiometricOxygenFlow == 20)
        #expect(result.actualOxygenFlow == 24)

        #expect(
            abs(
                result.actualAirFlow
                - 24.0 / 0.21
            ) < 1e-12
        )

        #expect(result.carbonDioxideFlow == 10)
        #expect(result.waterVaporFlow == 20)
        #expect(result.excessOxygenFlow == 4)
    }

    @Test("Zero excess air equals theoretical air")
    func theoreticalAir() throws {
        let result = try engine.calculate(
            .init(
                fuelMolarFlow: 10,
                carbonAtomsPerMolecule: 1,
                hydrogenAtomsPerMolecule: 4,
                oxygenAtomsPerMolecule: 0,
                excessAirFraction: 0,
                oxygenMoleFractionInAir: 0.21
            )
        )

        #expect(
            abs(
                result.actualAirFlow
                - result.theoreticalAirFlow
            ) < 1e-12
        )

        #expect(result.excessOxygenFlow == 0)
    }

    @Test("Rejects noncombustible formula")
    func validation() {
        #expect(
            throws:
                CombustionAirRequirementError
                    .invalidFuelFormula
        ) {
            try engine.calculate(
                .init(
                    fuelMolarFlow: 10,
                    carbonAtomsPerMolecule: 0,
                    hydrogenAtomsPerMolecule: 0,
                    oxygenAtomsPerMolecule: 2,
                    excessAirFraction: 0,
                    oxygenMoleFractionInAir: 0.21
                )
            )
        }
    }
}
