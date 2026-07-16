import Testing
@testable import ChemEToolkit

@Suite("Economic Reactor Selection Engine")
struct EconomicReactorSelectionEngineTests {
    private let engine =
        EconomicReactorSelectionEngine()

    @Test("Compares annualized PFR and CSTR costs")
    func economicSelection() throws {
        let result = try engine.calculate(
            .init(
                volumetricFlowRate: 1,
                firstOrderRateConstant: 0.5,
                targetConversion: 0.8,
                pfrInstalledCostPerVolume: 100000,
                cstrInstalledCostPerVolume: 70000,
                annualizationFactor: 0.2,
                pfrAnnualOperatingCost: 10000,
                cstrAnnualOperatingCost: 15000
            )
        )

        #expect(
            abs(
                result.requiredPFRVolume
                - 3.2188758248682006
            ) < 1e-12
        )
        #expect(
            abs(
                result.requiredCSTRVolume
                - 8
            ) < 1e-12
        )
        #expect(
            abs(
                result.pfrEquivalentAnnualCost
                - 74377.516497364006
            ) < 1e-8
        )
        #expect(
            abs(
                result.cstrEquivalentAnnualCost
                - 127000
            ) < 1e-8
        )
        #expect(result.preferredReactor == "PFR")
    }

    @Test("Operating cost can change preferred reactor")
    func operatingCostEffect() throws {
        let result = try engine.calculate(
            .init(
                volumetricFlowRate: 1,
                firstOrderRateConstant: 0.5,
                targetConversion: 0.8,
                pfrInstalledCostPerVolume: 100000,
                cstrInstalledCostPerVolume: 70000,
                annualizationFactor: 0.2,
                pfrAnnualOperatingCost: 200000,
                cstrAnnualOperatingCost: 0
            )
        )

        #expect(result.preferredReactor == "CSTR")
    }

    @Test("Rejects invalid annualization factor")
    func validation() {
        #expect(
            throws:
                EconomicReactorSelectionError
                    .annualizationFactorOutOfRange
        ) {
            try engine.calculate(
                .init(
                    volumetricFlowRate: 1,
                    firstOrderRateConstant: 0.5,
                    targetConversion: 0.8,
                    pfrInstalledCostPerVolume: 100000,
                    cstrInstalledCostPerVolume: 70000,
                    annualizationFactor: 0,
                    pfrAnnualOperatingCost: 10000,
                    cstrAnnualOperatingCost: 15000
                )
            )
        }
    }
}
