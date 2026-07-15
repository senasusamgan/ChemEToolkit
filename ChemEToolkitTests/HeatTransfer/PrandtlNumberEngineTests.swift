import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Prandtl Number Engine")
struct PrandtlNumberEngineTests {

    private let engine = PrandtlNumberEngine()
    private let tolerance = 0.000001

    @Test("Calculates a liquid-like Prandtl number")
    func calculatesPrandtlNumber() throws {
        let result = try engine.calculate(
            input: PrandtlNumberInput(
                dynamicViscosity: 0.001,
                specificHeatCapacity: 4180,
                thermalConductivity: 0.6
            )
        )

        #expect(
            abs(
                result.prandtlNumber
                - 6.966666666666667
            ) < tolerance
        )

        #expect(
            result.transportRegime
                == .comparableDiffusion
        )
    }

    @Test("Classifies very high Prandtl number")
    func classifiesHighPrandtlNumber() throws {
        let result = try engine.calculate(
            input: PrandtlNumberInput(
                dynamicViscosity: 1,
                specificHeatCapacity: 20,
                thermalConductivity: 1
            )
        )

        #expect(result.prandtlNumber == 20)
        #expect(
            result.transportRegime
                == .momentumDiffusionDominant
        )
    }

    @Test("Rejects invalid fluid properties")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                PrandtlNumberError
                    .nonPositiveDynamicViscosity
        ) {
            try engine.calculate(
                input: PrandtlNumberInput(
                    dynamicViscosity: 0,
                    specificHeatCapacity: 4180,
                    thermalConductivity: 0.6
                )
            )
        }

        #expect(
            throws:
                PrandtlNumberError
                    .nonPositiveSpecificHeatCapacity
        ) {
            try engine.calculate(
                input: PrandtlNumberInput(
                    dynamicViscosity: 0.001,
                    specificHeatCapacity: 0,
                    thermalConductivity: 0.6
                )
            )
        }

        #expect(
            throws:
                PrandtlNumberError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                input: PrandtlNumberInput(
                    dynamicViscosity: .infinity,
                    specificHeatCapacity: 4180,
                    thermalConductivity: 0.6
                )
            )
        }
    }
}
