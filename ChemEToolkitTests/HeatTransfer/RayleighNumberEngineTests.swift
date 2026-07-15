import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Rayleigh Number Engine")
struct RayleighNumberEngineTests {

    private let engine = RayleighNumberEngine()
    private let tolerance = 0.000001

    @Test("Calculates Rayleigh number")
    func calculatesRayleighNumber() throws {
        let result = try engine.calculate(
            input: RayleighNumberInput(
                grashofNumber: 100_000_000,
                prandtlNumber: 0.7
            )
        )

        #expect(
            abs(
                result.rayleighNumber
                - 70_000_000
            ) < tolerance
        )
    }

    @Test("Allows zero buoyancy")
    func allowsZeroGrashofNumber() throws {
        let result = try engine.calculate(
            input: RayleighNumberInput(
                grashofNumber: 0,
                prandtlNumber: 7
            )
        )

        #expect(
            abs(result.rayleighNumber)
                < tolerance
        )
    }

    @Test("Rejects invalid Rayleigh inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                RayleighNumberError
                    .negativeGrashofNumber
        ) {
            try engine.calculate(
                input: RayleighNumberInput(
                    grashofNumber: -1,
                    prandtlNumber: 0.7
                )
            )
        }

        #expect(
            throws:
                RayleighNumberError
                    .nonPositivePrandtlNumber
        ) {
            try engine.calculate(
                input: RayleighNumberInput(
                    grashofNumber: 1,
                    prandtlNumber: 0
                )
            )
        }

        #expect(
            throws:
                RayleighNumberError
                    .nonFiniteInput
        ) {
            try engine.calculate(
                input: RayleighNumberInput(
                    grashofNumber: .infinity,
                    prandtlNumber: 0.7
                )
            )
        }
    }
}
