import Foundation

struct CSTRsInSeriesEngine: Sendable {
    private let integerTolerance = 1.0e-10

    func calculate(
        _ input: CSTRsInSeriesInput
    ) throws -> CSTRsInSeriesResult {
        let values = [
            input.firstOrderRateConstant,
            input.totalReactorVolume,
            input.volumetricFlowRate,
            input.numberOfReactors
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw CSTRsInSeriesError.nonFiniteInput
        }
        guard input.firstOrderRateConstant > 0 else {
            throw CSTRsInSeriesError.nonPositiveRateConstant
        }
        guard
            input.totalReactorVolume > 0,
            input.volumetricFlowRate > 0
        else {
            throw CSTRsInSeriesError.nonPositiveVolumeOrFlow
        }

        let rounded = input.numberOfReactors.rounded()
        guard
            abs(input.numberOfReactors - rounded) <= integerTolerance,
            rounded >= 1,
            rounded <= 100
        else {
            throw CSTRsInSeriesError.invalidReactorCount
        }

        let count = Int(rounded)
        let totalTau =
            input.totalReactorVolume / input.volumetricFlowRate
        let tankTau = totalTau / Double(count)
        let da = input.firstOrderRateConstant * tankTau
        let remaining = pow(1 + da, -Double(count))
        let seriesX = 1 - remaining
        let totalDa = input.firstOrderRateConstant * totalTau
        let singleX = totalDa / (1 + totalDa)
        let pfrX = 1 - exp(-totalDa)
        let gain = max(0, seriesX - singleX)
        let gap = max(0, pfrX - seriesX)

        guard
            [totalTau, tankTau, da, remaining, seriesX, singleX, pfrX, gain, gap]
                .allSatisfy(\.isFinite),
            totalTau > 0,
            tankTau > 0,
            da > 0,
            remaining > 0,
            remaining < 1,
            seriesX > 0,
            seriesX < 1,
            singleX > 0,
            singleX < 1,
            pfrX > 0,
            pfrX < 1
        else {
            throw CSTRsInSeriesError.numericalFailure
        }

        return .init(
            numberOfReactors: count,
            totalSpaceTime: totalTau,
            spaceTimePerReactor: tankTau,
            damkohlerNumberPerReactor: da,
            conversionForSeries: seriesX,
            conversionForSingleCSTR: singleX,
            conversionForPFR: pfrX,
            seriesGainOverSingleCSTR: gain,
            remainingGapToPFR: gap,
            outletConcentrationFraction: remaining,
            modelName:
                "Equal-volume CSTR cascade with constant-density first-order kinetics",
            limitationDescription:
                "Assumes identical ideal CSTRs, equal tank volumes, steady state, constant volumetric flow and one irreversible first-order reaction."
        )
    }
}
