import Testing
@testable import ChemEToolkit

@Suite("Saturated Mixture Property Engine")
struct SaturatedMixturePropertyEngineTests {
    private let engine =
        SaturatedMixturePropertyEngine()

    @Test("Interpolates mixture property")
    func interpolation() throws {
        let result = try engine.calculate(
            .init(
                saturatedLiquidProperty: 419,
                saturatedVaporProperty: 2676,
                vaporQuality: 0.5
            )
        )

        #expect(result.propertyDifference == 2257)

        #expect(
            abs(
                result.mixtureProperty
                - 1547.5
            ) < 1e-12
        )

        #expect(result.liquidMassFraction == 0.5)
        #expect(result.vaporMassFraction == 0.5)
    }

    @Test("Zero quality returns saturated-liquid property")
    func liquidEndpoint() throws {
        let result = try engine.calculate(
            .init(
                saturatedLiquidProperty: 419,
                saturatedVaporProperty: 2676,
                vaporQuality: 0
            )
        )

        #expect(result.mixtureProperty == 419)
        #expect(result.vaporContribution == 0)
    }

    @Test("Rejects quality above one")
    func validation() {
        #expect(
            throws:
                SaturatedMixturePropertyError
                    .fractionOutsideRange
        ) {
            try engine.calculate(
                .init(
                    saturatedLiquidProperty: 419,
                    saturatedVaporProperty: 2676,
                    vaporQuality: 1.1
                )
            )
        }
    }
}
