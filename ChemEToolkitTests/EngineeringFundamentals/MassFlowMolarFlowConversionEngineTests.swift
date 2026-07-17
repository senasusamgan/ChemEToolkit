import Testing
@testable import ChemEToolkit

@Suite("Mass Flow-Molar Flow Conversion Engine")
struct MassFlowMolarFlowConversionEngineTests {
    private let engine =
        MassFlowMolarFlowConversionEngine()

    @Test("Converts mass flow to molar flow")
    func conversion() throws {
        let result = try engine.calculate(
            .init(
                massFlowRateKilogramsPerHour:
                    1800,
                molecularWeightKilogramsPerKilomole:
                    18
            )
        )

        #expect(
            result.molarFlowRateKilomolesPerHour
            == 100
        )

        #expect(
            abs(
                result.molarFlowRateMolesPerSecond
                - 27.77777777777778
            ) < 1e-12
        )

        #expect(
            result.massFlowRateKilogramsPerSecond
            == 0.5
        )
    }

    @Test("Zero mass flow remains zero")
    func zeroFlow() throws {
        let result = try engine.calculate(
            .init(
                massFlowRateKilogramsPerHour:
                    0,
                molecularWeightKilogramsPerKilomole:
                    44
            )
        )

        #expect(
            result.molarFlowRateKilomolesPerHour
            == 0
        )
    }

    @Test("Rejects zero molecular weight")
    func validation() {
        #expect(
            throws:
                MassFlowMolarFlowConversionError
                    .nonPositiveMolecularWeight
        ) {
            try engine.calculate(
                .init(
                    massFlowRateKilogramsPerHour:
                        100,
                    molecularWeightKilogramsPerKilomole:
                        0
                )
            )
        }
    }
}
