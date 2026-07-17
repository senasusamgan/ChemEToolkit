import Foundation

struct GillilandStageEstimateEngine:
    Sendable {

    func calculate(
        _ input:
            GillilandStageEstimateInput
    ) throws
        -> GillilandStageEstimateResult {

        let values = [
            input.minimumTheoreticalStages,
            input.minimumRefluxRatio,
            input.operatingRefluxRatio
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw GillilandStageEstimateError
                .nonFiniteInput
        }

        guard input.minimumTheoreticalStages > 0 else {
            throw GillilandStageEstimateError
                .nonPositiveMinimumStages
        }

        guard input.minimumRefluxRatio >= 0 else {
            throw GillilandStageEstimateError
                .negativeMinimumReflux
        }

        guard
            input.operatingRefluxRatio
            > input.minimumRefluxRatio
        else {
            throw GillilandStageEstimateError
                .operatingRefluxNotAboveMinimum
        }

        let x =
            (
                input.operatingRefluxRatio
                - input.minimumRefluxRatio
            )
            / (
                input.operatingRefluxRatio + 1
            )

        let exponent =
            (
                1 + 54.4 * x
            )
            / (
                11 + 117.2 * x
            )
            * (
                x - 1
            )
            / Foundation.sqrt(x)

        let y =
            1
            - Foundation.exp(exponent)

        let stages =
            (
                input.minimumTheoreticalStages + y
            )
            / (
                1 - y
            )

        let aboveMinimum =
            stages
            - input.minimumTheoreticalStages

        let refluxMultiple =
            input.minimumRefluxRatio > 0
            ? input.operatingRefluxRatio
                / input.minimumRefluxRatio
            : Double.infinity

        let finiteOutputs = [
            x,
            y,
            stages,
            aboveMinimum
        ]

        guard
            finiteOutputs.allSatisfy(\.isFinite),
            x > 0,
            x < 1,
            y >= 0,
            y < 1,
            stages
                >= input.minimumTheoreticalStages,
            refluxMultiple.isFinite
                || refluxMultiple == .infinity
        else {
            throw GillilandStageEstimateError
                .numericalFailure
        }

        return .init(
            gillilandX:
                x,
            gillilandY:
                y,
            estimatedTheoreticalStages:
                stages,
            stagesAboveMinimum:
                aboveMinimum,
            refluxMultipleOfMinimum:
                refluxMultiple,
            modelName:
                "Eduljee explicit approximation to the Gilliland correlation",
            limitationDescription:
                "Estimates theoretical stages from Nmin, Rmin and operating reflux. Practical stage count is rounded upward."
        )
    }
}
