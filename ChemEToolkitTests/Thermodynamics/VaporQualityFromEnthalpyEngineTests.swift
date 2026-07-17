import Testing
@testable import ChemEToolkit

@Suite("Vapor Quality from Enthalpy Engine")
struct VaporQualityFromEnthalpyEngineTests {
    private let engine =
        VaporQualityFromEnthalpyEngine()

    @Test("Calculates half quality")
    func halfQuality() throws {
        let result = try engine.calculate(
            .init(
                saturatedLiquidEnthalpy: 419,
                saturatedVaporEnthalpy: 2676,
                mixtureEnthalpy: 1547.5
            )
        )

        #expect(result.latentEnthalpy == 2257)

        #expect(
            abs(
                result.vaporQuality
                - 0.5
            ) < 1e-12
        )

        #expect(result.liquidMassFraction == 0.5)
    }

    @Test("Saturated liquid has zero quality")
    func saturatedLiquid() throws {
        let result = try engine.calculate(
            .init(
                saturatedLiquidEnthalpy: 419,
                saturatedVaporEnthalpy: 2676,
                mixtureEnthalpy: 419
            )
        )

        #expect(result.vaporQuality == 0)
        #expect(
            result.regionDescription
            == "Saturated liquid"
        )
    }

    @Test("Rejects superheated enthalpy")
    func validation() {
        #expect(
            throws:
                VaporQualityFromEnthalpyError
                    .mixtureOutsideSaturationRange
        ) {
            try engine.calculate(
                .init(
                    saturatedLiquidEnthalpy: 419,
                    saturatedVaporEnthalpy: 2676,
                    mixtureEnthalpy: 3000
                )
            )
        }
    }
}
