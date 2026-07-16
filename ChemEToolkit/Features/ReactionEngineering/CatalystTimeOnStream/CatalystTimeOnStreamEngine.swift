import Foundation

struct CatalystTimeOnStreamEngine:
    Sendable {

    func calculate(
        _ input:
            CatalystTimeOnStreamInput
    ) throws
        -> CatalystTimeOnStreamResult {

        let values = [
            input.freshDamkohlerNumber,
            input.deactivationRateConstant,
            input.minimumAcceptableConversion
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CatalystTimeOnStreamError
                .nonFiniteInput
        }

        guard input.freshDamkohlerNumber > 0 else {
            throw CatalystTimeOnStreamError
                .nonPositiveDamkohlerNumber
        }

        guard
            input.deactivationRateConstant > 0
        else {
            throw CatalystTimeOnStreamError
                .nonPositiveDeactivationRate
        }

        guard
            input.minimumAcceptableConversion > 0,
            input.minimumAcceptableConversion < 1
        else {
            throw CatalystTimeOnStreamError
                .conversionOutOfRange
        }

        let freshPFRConversion =
            1
            - exp(
                -input.freshDamkohlerNumber
            )

        let freshCSTRConversion =
            input.freshDamkohlerNumber
            / (
                1
                + input.freshDamkohlerNumber
            )

        guard
            input.minimumAcceptableConversion
                < freshPFRConversion,
            input.minimumAcceptableConversion
                < freshCSTRConversion
        else {
            throw CatalystTimeOnStreamError
                .freshReactorBelowTarget
        }

        let requiredPFRActivity =
            -log(
                1
                - input.minimumAcceptableConversion
            )
            / input.freshDamkohlerNumber

        let requiredCSTRActivity =
            input.minimumAcceptableConversion
            / (
                input.freshDamkohlerNumber
                * (
                    1
                    - input.minimumAcceptableConversion
                )
            )

        let pfrLimit =
            -log(requiredPFRActivity)
            / input.deactivationRateConstant

        let cstrLimit =
            -log(requiredCSTRActivity)
            / input.deactivationRateConstant

        let halfLife =
            log(2)
            / input.deactivationRateConstant

        let limitingDescription =
            pfrLimit < cstrLimit
            ? "The PFR reaches the minimum conversion first."
            : "The CSTR reaches the minimum conversion first."

        let results = [
            freshPFRConversion,
            freshCSTRConversion,
            requiredPFRActivity,
            requiredCSTRActivity,
            pfrLimit,
            cstrLimit,
            halfLife
        ]

        guard
            results.allSatisfy(\.isFinite),
            freshPFRConversion > 0,
            freshPFRConversion < 1,
            freshCSTRConversion > 0,
            freshCSTRConversion < 1,
            requiredPFRActivity > 0,
            requiredPFRActivity < 1,
            requiredCSTRActivity > 0,
            requiredCSTRActivity < 1,
            pfrLimit > 0,
            cstrLimit > 0,
            halfLife > 0
        else {
            throw CatalystTimeOnStreamError
                .numericalFailure
        }

        return .init(
            freshPFRConversion:
                freshPFRConversion,
            freshCSTRConversion:
                freshCSTRConversion,
            requiredPFRActivity:
                requiredPFRActivity,
            requiredCSTRActivity:
                requiredCSTRActivity,
            pfrTimeOnStreamLimit:
                pfrLimit,
            cstrTimeOnStreamLimit:
                cstrLimit,
            catalystActivityHalfLife:
                halfLife,
            limitingReactorDescription:
                limitingDescription,
            modelName:
                "First-order catalyst lifetime from minimum PFR and CSTR conversion constraints",
            limitationDescription:
                "Uses a(t)=exp(−k_d t), X_PFR=1−exp(−aDa₀) and X_CSTR=aDa₀/(1+aDa₀). It assumes constant temperature, first-order reaction kinetics and uniform catalyst activity."
        )
    }
}
