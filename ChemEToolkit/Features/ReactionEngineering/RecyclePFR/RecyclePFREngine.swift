import Foundation

struct RecyclePFREngine: Sendable {
    func calculate(
        _ input: RecyclePFRInput
    ) throws -> RecyclePFRResult {
        let values = [
            input.freshFeedConcentration,
            input.freshVolumetricFlowRate,
            input.reactorVolume,
            input.firstOrderRateConstant,
            input.recycleRatio
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RecyclePFRError.nonFiniteInput
        }
        guard
            input.freshFeedConcentration > 0,
            input.freshVolumetricFlowRate > 0
        else {
            throw RecyclePFRError.nonPositiveFeed
        }
        guard
            input.reactorVolume > 0,
            input.firstOrderRateConstant > 0
        else {
            throw RecyclePFRError.nonPositiveVolumeOrRateConstant
        }
        guard input.recycleRatio >= 0 else {
            throw RecyclePFRError.negativeRecycleRatio
        }
        guard input.recycleRatio <= 1000 else {
            throw RecyclePFRError.recycleRatioTooLarge
        }

        let totalFlow =
            input.freshVolumetricFlowRate
            * (1 + input.recycleRatio)

        let tau = input.reactorVolume / totalFlow
        let e = exp(-input.firstOrderRateConstant * tau)
        let denominator =
            1 + input.recycleRatio * (1 - e)

        let outletFraction = e / denominator
        let outlet =
            input.freshFeedConcentration
            * outletFraction

        let inlet =
            (
                input.freshFeedConcentration
                + input.recycleRatio * outlet
            )
            / (1 + input.recycleRatio)

        let singlePassX = 1 - outlet / inlet
        let overallX = 1 - outletFraction
        let recycleFlow =
            input.recycleRatio
            * input.freshVolumetricFlowRate
        let recycledMolarRate =
            recycleFlow * outlet

        let noRecycleTau =
            input.reactorVolume
            / input.freshVolumetricFlowRate
        let noRecycleX =
            1
            - exp(
                -input.firstOrderRateConstant
                * noRecycleTau
            )
        let penalty = max(0, noRecycleX - overallX)

        guard
            [totalFlow, tau, inlet, outlet, singlePassX, overallX, recycleFlow, recycledMolarRate, noRecycleX, penalty]
                .allSatisfy(\.isFinite),
            totalFlow > 0,
            tau > 0,
            inlet > 0,
            outlet > 0,
            inlet <= input.freshFeedConcentration,
            outlet < inlet,
            singlePassX > 0,
            singlePassX < 1,
            overallX > 0,
            overallX < 1,
            recycleFlow >= 0,
            recycledMolarRate >= 0,
            noRecycleX > 0,
            noRecycleX < 1
        else {
            throw RecyclePFRError.numericalFailure
        }

        return .init(
            totalReactorFlowRate: totalFlow,
            reactorResidenceTime: tau,
            reactorInletConcentration: inlet,
            reactorOutletConcentration: outlet,
            singlePassConversion: singlePassX,
            overallFreshFeedConversion: overallX,
            recycledVolumetricFlowRate: recycleFlow,
            recycledReactantMolarRate: recycledMolarRate,
            noRecyclePFRConversion: noRecycleX,
            conversionPenaltyFromRecycle: penalty,
            modelName:
                "Steady recycle PFR with fresh-feed-based recycle ratio and first-order kinetics",
            limitationDescription:
                "Assumes perfect fresh/recycle mixing, equal density, constant volumetric flow within each pass, ideal plug flow and no purge."
        )
    }
}
