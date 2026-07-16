import Foundation

struct ReactorOptimizationEngine:
    Sendable {

    private let equalRateTolerance =
        1e-10

    func calculate(
        _ input:
            ReactorOptimizationInput
    ) throws
        -> ReactorOptimizationResult {

        let values = [
            input.inletConcentrationA,
            input.volumetricFlowRate,
            input.firstRateConstant,
            input.secondRateConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ReactorOptimizationError
                .nonFiniteInput
        }

        guard
            input.inletConcentrationA > 0,
            input.volumetricFlowRate > 0
        else {
            throw ReactorOptimizationError
                .nonPositiveFeedCondition
        }

        guard
            input.firstRateConstant > 0,
            input.secondRateConstant > 0
        else {
            throw ReactorOptimizationError
                .nonPositiveRateConstant
        }

        let scale =
            max(
                1,
                input.firstRateConstant,
                input.secondRateConstant
            )

        let pfrSpaceTime: Double
        let pfrMaximumB: Double

        if abs(
            input.secondRateConstant
            - input.firstRateConstant
        )
        <= equalRateTolerance * scale {
            pfrSpaceTime =
                1
                / input.firstRateConstant

            pfrMaximumB =
                input.inletConcentrationA
                / exp(1)
        } else {
            pfrSpaceTime =
                log(
                    input.secondRateConstant
                    / input.firstRateConstant
                )
                / (
                    input.secondRateConstant
                    - input.firstRateConstant
                )

            pfrMaximumB =
                input.inletConcentrationA
                * input.firstRateConstant
                / (
                    input.secondRateConstant
                    - input.firstRateConstant
                )
                * (
                    exp(
                        -input.firstRateConstant
                        * pfrSpaceTime
                    )
                    - exp(
                        -input.secondRateConstant
                        * pfrSpaceTime
                    )
                )
        }

        let cstrSpaceTime =
            1
            / (
                input.firstRateConstant
                * input.secondRateConstant
            ).squareRoot()

        let cstrMaximumB =
            input.inletConcentrationA
            * input.firstRateConstant
            * cstrSpaceTime
            / (
                (
                    1
                    + input.firstRateConstant
                    * cstrSpaceTime
                )
                * (
                    1
                    + input.secondRateConstant
                    * cstrSpaceTime
                )
            )

        let pfrYield =
            pfrMaximumB
            / input.inletConcentrationA

        let cstrYield =
            cstrMaximumB
            / input.inletConcentrationA

        let recommendation =
            pfrYield >= cstrYield
            ? "PFR"
            : "CSTR"

        let advantage =
            abs(
                pfrYield - cstrYield
            )

        let pfrVolume =
            input.volumetricFlowRate
            * pfrSpaceTime

        let cstrVolume =
            input.volumetricFlowRate
            * cstrSpaceTime

        let results = [
            pfrSpaceTime,
            pfrVolume,
            pfrMaximumB,
            pfrYield,
            cstrSpaceTime,
            cstrVolume,
            cstrMaximumB,
            cstrYield,
            advantage
        ]

        guard
            results.allSatisfy(\.isFinite),
            pfrSpaceTime > 0,
            cstrSpaceTime > 0,
            pfrVolume > 0,
            cstrVolume > 0,
            pfrYield > 0,
            pfrYield < 1,
            cstrYield > 0,
            cstrYield < 1
        else {
            throw ReactorOptimizationError
                .numericalFailure
        }

        return .init(
            optimumPFRSpaceTime:
                pfrSpaceTime,
            optimumPFRVolume:
                pfrVolume,
            maximumPFRConcentrationB:
                pfrMaximumB,
            maximumPFRYieldB:
                pfrYield,
            optimumCSTRSpaceTime:
                cstrSpaceTime,
            optimumCSTRVolume:
                cstrVolume,
            maximumCSTRConcentrationB:
                cstrMaximumB,
            maximumCSTRYieldB:
                cstrYield,
            recommendedReactor:
                recommendation,
            yieldAdvantage:
                advantage,
            modelName:
                "Intermediate-product optimization for consecutive first-order reactions A → B → C",
            limitationDescription:
                "Optimizes ideal isothermal PFR and single CSTR residence time for maximum B concentration. Costs, heat effects, pressure drop and reactor networks are excluded."
        )
    }
}
