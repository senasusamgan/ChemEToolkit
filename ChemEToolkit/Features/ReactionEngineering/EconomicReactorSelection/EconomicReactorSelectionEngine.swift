import Foundation

struct EconomicReactorSelectionEngine:
    Sendable {

    func calculate(
        _ input:
            EconomicReactorSelectionInput
    ) throws
        -> EconomicReactorSelectionResult {

        let values = [
            input.volumetricFlowRate,
            input.firstOrderRateConstant,
            input.targetConversion,
            input.pfrInstalledCostPerVolume,
            input.cstrInstalledCostPerVolume,
            input.annualizationFactor,
            input.pfrAnnualOperatingCost,
            input.cstrAnnualOperatingCost
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw EconomicReactorSelectionError
                .nonFiniteInput
        }

        guard
            input.volumetricFlowRate > 0,
            input.firstOrderRateConstant > 0
        else {
            throw EconomicReactorSelectionError
                .nonPositiveDesignParameter
        }

        guard
            input.targetConversion > 0,
            input.targetConversion < 1
        else {
            throw EconomicReactorSelectionError
                .conversionOutOfRange
        }

        guard
            input.pfrInstalledCostPerVolume > 0,
            input.cstrInstalledCostPerVolume > 0
        else {
            throw EconomicReactorSelectionError
                .nonPositiveCapitalCost
        }

        guard
            input.annualizationFactor > 0,
            input.annualizationFactor <= 1
        else {
            throw EconomicReactorSelectionError
                .annualizationFactorOutOfRange
        }

        guard
            input.pfrAnnualOperatingCost >= 0,
            input.cstrAnnualOperatingCost >= 0
        else {
            throw EconomicReactorSelectionError
                .negativeOperatingCost
        }

        let pfrSpaceTime =
            -log(
                1 - input.targetConversion
            )
            / input.firstOrderRateConstant

        let cstrSpaceTime =
            input.targetConversion
            / (
                input.firstOrderRateConstant
                * (
                    1 - input.targetConversion
                )
            )

        let pfrVolume =
            input.volumetricFlowRate
            * pfrSpaceTime

        let cstrVolume =
            input.volumetricFlowRate
            * cstrSpaceTime

        let pfrCapital =
            pfrVolume
            * input.pfrInstalledCostPerVolume

        let cstrCapital =
            cstrVolume
            * input.cstrInstalledCostPerVolume

        let pfrAnnual =
            input.annualizationFactor
            * pfrCapital
            + input.pfrAnnualOperatingCost

        let cstrAnnual =
            input.annualizationFactor
            * cstrCapital
            + input.cstrAnnualOperatingCost

        let preferred =
            pfrAnnual <= cstrAnnual
            ? "PFR"
            : "CSTR"

        let savings =
            abs(
                pfrAnnual - cstrAnnual
            )

        let higherCost =
            max(
                pfrAnnual,
                cstrAnnual
            )

        let relativeSavings =
            higherCost > 0
            ? savings / higherCost
            : 0

        let results = [
            pfrVolume,
            cstrVolume,
            pfrCapital,
            cstrCapital,
            pfrAnnual,
            cstrAnnual,
            savings,
            relativeSavings
        ]

        guard
            results.allSatisfy(\.isFinite),
            pfrVolume > 0,
            cstrVolume > 0,
            pfrCapital > 0,
            cstrCapital > 0,
            pfrAnnual >= 0,
            cstrAnnual >= 0,
            savings >= 0,
            relativeSavings >= 0,
            relativeSavings <= 1
        else {
            throw EconomicReactorSelectionError
                .numericalFailure
        }

        return .init(
            requiredPFRVolume:
                pfrVolume,
            requiredCSTRVolume:
                cstrVolume,
            pfrInstalledCapitalCost:
                pfrCapital,
            cstrInstalledCapitalCost:
                cstrCapital,
            pfrEquivalentAnnualCost:
                pfrAnnual,
            cstrEquivalentAnnualCost:
                cstrAnnual,
            preferredReactor:
                preferred,
            annualSavings:
                savings,
            relativeSavingsFraction:
                relativeSavings,
            modelName:
                "Equivalent annual-cost comparison for first-order ideal PFR and CSTR designs",
            limitationDescription:
                "Uses linear installed cost per reactor volume and fixed annual operating cost. It excludes scale exponents, taxes, depreciation, downtime, heat-transfer equipment and uncertainty."
        )
    }
}
