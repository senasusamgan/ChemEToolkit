import Foundation

struct RTDModelComparisonEngine:
    Sendable {

    private let rangeTolerance =
        1.0e-12

    func calculate(
        _ input:
            RTDModelComparisonInput
    ) throws
        -> RTDModelComparisonResult {

        let values = [
            input.meanResidenceTime,
            input.residenceTimeVariance,
            input.firstOrderRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw RTDModelComparisonError
                .nonFiniteInput
        }

        guard input.meanResidenceTime > 0 else {
            throw RTDModelComparisonError
                .nonPositiveMeanResidenceTime
        }

        guard input.residenceTimeVariance > 0 else {
            throw RTDModelComparisonError
                .nonPositiveVariance
        }

        let meanSquared =
            input.meanResidenceTime
            * input.meanResidenceTime

        guard
            input.residenceTimeVariance
            <= meanSquared
            * (
                1 + rangeTolerance
            )
        else {
            throw RTDModelComparisonError
                .varianceOutsideTanksModelRange
        }

        guard input.firstOrderRateConstant > 0 else {
            throw RTDModelComparisonError
                .nonPositiveRateConstant
        }

        let dimensionlessVariance =
            input.residenceTimeVariance
            / meanSquared

        let equivalentTanks =
            1
            / dimensionlessVariance

        let estimatedPeclet =
            2
            / dimensionlessVariance

        let damkohler =
            input.firstOrderRateConstant
            * input.meanResidenceTime

        let pfrConversion =
            1 - exp(-damkohler)

        let tanksUnreactedFraction =
            pow(
                1
                + damkohler
                / equivalentTanks,
                -equivalentTanks
            )

        let tanksConversion =
            1 - tanksUnreactedFraction

        let cstrConversion =
            damkohler
            / (
                1 + damkohler
            )

        let pfrDifference =
            pfrConversion
            - tanksConversion

        let cstrDifference =
            tanksConversion
            - cstrConversion

        let results = [
            damkohler,
            dimensionlessVariance,
            equivalentTanks,
            estimatedPeclet,
            pfrConversion,
            tanksConversion,
            cstrConversion,
            pfrDifference,
            cstrDifference
        ]

        guard
            results.allSatisfy(\.isFinite),
            damkohler > 0,
            dimensionlessVariance > 0,
            dimensionlessVariance <= 1
                + rangeTolerance,
            equivalentTanks >= 1
                - rangeTolerance,
            estimatedPeclet > 0,
            pfrConversion >= 0,
            pfrConversion <= 1,
            tanksConversion >= 0,
            tanksConversion <= 1,
            cstrConversion >= 0,
            cstrConversion <= 1
        else {
            throw RTDModelComparisonError
                .numericalFailure
        }

        return .init(
            damkohlerNumber:
                damkohler,
            dimensionlessVariance:
                dimensionlessVariance,
            equivalentTanksInSeries:
                equivalentTanks,
            estimatedPecletNumber:
                estimatedPeclet,
            idealPFRConversion:
                pfrConversion,
            tanksInSeriesConversion:
                tanksConversion,
            idealCSTRConversion:
                cstrConversion,
            pfrToTanksConversionDifference:
                pfrDifference,
            tanksToCSTRConversionDifference:
                cstrDifference,
            modelName:
                "First-order PFR–tanks-in-series–CSTR conversion comparison from RTD moments",
            limitationDescription:
                "The equivalent tank count uses N = τ²/σ² and the axial-dispersion estimate uses Pe ≈ 2/σ²θ. The comparison is restricted to 0 < σ²θ ≤ 1 and first-order constant-density kinetics."
        )
    }
}
