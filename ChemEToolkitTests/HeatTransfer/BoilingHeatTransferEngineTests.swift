import Testing
@testable import ChemEToolkit

@MainActor
@Suite("Boiling Heat Transfer Engine")
struct BoilingHeatTransferEngineTests {

    private let engine =
        BoilingHeatTransferEngine()

    private let tolerance = 0.000001

    @Test("Calculates boiling duty")
    func calculatesBoilingDuty() throws {
        let result = try engine.calculate(
            input: BoilingHeatTransferInput(
                surfaceTemperature: 120,
                saturationTemperature: 100,
                boilingHeatTransferCoefficient: 5_000,
                surfaceArea: 2
            )
        )

        #expect(
            abs(result.wallSuperheat - 20)
                < tolerance
        )

        #expect(
            abs(result.heatFlux - 100_000)
                < tolerance
        )

        #expect(
            abs(
                result.heatTransferRate
                - 200_000
            ) < tolerance
        )

        #expect(
            result.regimeIndicator
                == .boilingPossible
        )
    }

    @Test("Returns zero without positive superheat")
    func returnsZeroWithoutSuperheat() throws {
        let result = try engine.calculate(
            input: BoilingHeatTransferInput(
                surfaceTemperature: 90,
                saturationTemperature: 100,
                boilingHeatTransferCoefficient: 5_000,
                surfaceArea: 2
            )
        )

        #expect(
            abs(result.heatTransferRate)
                < tolerance
        )

        #expect(
            result.regimeIndicator
                == .noBoiling
        )
    }

    @Test("Rejects invalid boiling inputs")
    func rejectsInvalidInputs() {
        #expect(
            throws:
                BoilingHeatTransferError
                    .nonPositiveHeatTransferCoefficient
        ) {
            try engine.calculate(
                input: BoilingHeatTransferInput(
                    surfaceTemperature: 120,
                    saturationTemperature: 100,
                    boilingHeatTransferCoefficient: 0,
                    surfaceArea: 2
                )
            )
        }

        #expect(
            throws:
                BoilingHeatTransferError
                    .nonPositiveArea
        ) {
            try engine.calculate(
                input: BoilingHeatTransferInput(
                    surfaceTemperature: 120,
                    saturationTemperature: 100,
                    boilingHeatTransferCoefficient: 5_000,
                    surfaceArea: 0
                )
            )
        }
    }
}
