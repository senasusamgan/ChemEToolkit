import Foundation

struct BypassDeadVolumeReactorEngine:
    Sendable {

    func calculate(
        _ input:
            BypassDeadVolumeReactorInput
    ) throws
        -> BypassDeadVolumeReactorResult {

        let values = [
            input.nominalReactorVolume,
            input.totalVolumetricFlowRate,
            input.deadVolumeFraction,
            input.bypassFraction,
            input.firstOrderRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BypassDeadVolumeReactorError
                .nonFiniteInput
        }

        guard
            input.nominalReactorVolume > 0,
            input.totalVolumetricFlowRate > 0
        else {
            throw BypassDeadVolumeReactorError
                .nonPositiveVolumeOrFlow
        }

        guard
            input.deadVolumeFraction >= 0,
            input.deadVolumeFraction < 1
        else {
            throw BypassDeadVolumeReactorError
                .deadVolumeFractionOutOfRange
        }

        guard
            input.bypassFraction >= 0,
            input.bypassFraction < 1
        else {
            throw BypassDeadVolumeReactorError
                .bypassFractionOutOfRange
        }

        guard input.firstOrderRateConstant > 0 else {
            throw BypassDeadVolumeReactorError
                .nonPositiveRateConstant
        }

        let nominalSpaceTime =
            input.nominalReactorVolume
            / input.totalVolumetricFlowRate

        let activeVolume =
            input.nominalReactorVolume
            * (
                1 - input.deadVolumeFraction
            )

        let reactorFlow =
            input.totalVolumetricFlowRate
            * (
                1 - input.bypassFraction
            )

        let activePathSpaceTime =
            activeVolume / reactorFlow

        let activePathConversion =
            1
            - exp(
                -input.firstOrderRateConstant
                * activePathSpaceTime
            )

        let overallConversion =
            (
                1 - input.bypassFraction
            )
            * activePathConversion

        let outletUnreactedFraction =
            1 - overallConversion

        let idealNominalConversion =
            1
            - exp(
                -input.firstOrderRateConstant
                * nominalSpaceTime
            )

        let conversionPenalty =
            idealNominalConversion
            - overallConversion

        let results = [
            nominalSpaceTime,
            activeVolume,
            reactorFlow,
            activePathSpaceTime,
            activePathConversion,
            overallConversion,
            outletUnreactedFraction,
            idealNominalConversion,
            conversionPenalty
        ]

        guard
            results.allSatisfy(\.isFinite),
            nominalSpaceTime > 0,
            activeVolume > 0,
            reactorFlow > 0,
            activePathSpaceTime > 0,
            activePathConversion >= 0,
            activePathConversion <= 1,
            overallConversion >= 0,
            overallConversion <= 1,
            outletUnreactedFraction >= 0,
            outletUnreactedFraction <= 1,
            idealNominalConversion >= 0,
            idealNominalConversion <= 1
        else {
            throw BypassDeadVolumeReactorError
                .numericalFailure
        }

        return .init(
            nominalSpaceTime:
                nominalSpaceTime,
            activeReactorVolume:
                activeVolume,
            reactorPathFlowRate:
                reactorFlow,
            activePathSpaceTime:
                activePathSpaceTime,
            activePathConversion:
                activePathConversion,
            overallConversion:
                overallConversion,
            outletUnreactedFraction:
                outletUnreactedFraction,
            idealNominalPFRConversion:
                idealNominalConversion,
            conversionPenalty:
                conversionPenalty,
            modelName:
                "Parallel zero-residence-time bypass plus active PFR with inaccessible dead volume",
            limitationDescription:
                "Assumes the non-bypassed stream behaves as an ideal constant-density PFR and the bypass stream has zero conversion. Dead volume is completely inaccessible, with no mass exchange."
        )
    }
}
