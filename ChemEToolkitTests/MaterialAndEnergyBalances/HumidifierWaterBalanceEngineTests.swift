import Testing
@testable import ChemEToolkit

@Suite("Humidifier Water Balance Engine")
struct HumidifierWaterBalanceEngineTests {
    private let engine =
        HumidifierWaterBalanceEngine()

    @Test("Calculates water addition")
    func humidification() throws {
        let result = try engine.calculate(
            .init(
                dryGasMassFlow: 1000,
                inletHumidityRatio: 0.01,
                outletHumidityRatio: 0.03
            )
        )

        #expect(result.inletWaterVaporFlow == 10)
        #expect(result.outletWaterVaporFlow == 30)
        #expect(result.waterAddedFlow == 20)
        #expect(result.inletHumidGasFlow == 1010)
        #expect(result.outletHumidGasFlow == 1030)

        #expect(
            abs(
                result.outletWaterMassFraction
                - 30.0 / 1030.0
            ) < 1e-12
        )
    }

    @Test("Equal humidity ratios require no water")
    func noHumidification() throws {
        let result = try engine.calculate(
            .init(
                dryGasMassFlow: 1000,
                inletHumidityRatio: 0.01,
                outletHumidityRatio: 0.01
            )
        )

        #expect(result.waterAddedFlow == 0)
    }

    @Test("Rejects dehumidification target")
    func validation() {
        #expect(
            throws:
                HumidifierWaterBalanceError
                    .invalidHumidificationTarget
        ) {
            try engine.calculate(
                .init(
                    dryGasMassFlow: 1000,
                    inletHumidityRatio: 0.03,
                    outletHumidityRatio: 0.01
                )
            )
        }
    }
}
