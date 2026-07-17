import Foundation

struct FenskeMinimumStagesEngine:
    Sendable {

    func calculate(
        _ input:
            FenskeMinimumStagesInput
    ) throws
        -> FenskeMinimumStagesResult {

        let values = [
            input.distillateLightMoleFraction,
            input.bottomsLightMoleFraction,
            input.averageRelativeVolatility
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw FenskeMinimumStagesError
                .nonFiniteInput
        }

        let fractions = [
            input.distillateLightMoleFraction,
            input.bottomsLightMoleFraction
        ]

        guard
            fractions.allSatisfy({
                $0 > 0 && $0 < 1
            })
        else {
            throw FenskeMinimumStagesError
                .fractionAtBoundary
        }

        guard
            input.distillateLightMoleFraction
            > input.bottomsLightMoleFraction
        else {
            throw FenskeMinimumStagesError
                .invalidSeparationOrdering
        }

        guard
            input.averageRelativeVolatility > 1
        else {
            throw FenskeMinimumStagesError
                .invalidRelativeVolatility
        }

        let distillateRatio =
            input.distillateLightMoleFraction
            / (
                1
                - input.distillateLightMoleFraction
            )

        let bottomsRatio =
            input.bottomsLightMoleFraction
            / (
                1
                - input.bottomsLightMoleFraction
            )

        let separationFactor =
            distillateRatio
            / bottomsRatio

        let logVolatility =
            Foundation.log(
                input.averageRelativeVolatility
            )

        let stages =
            Foundation.log(
                separationFactor
            )
            / logVolatility

        let outputs = [
            distillateRatio,
            bottomsRatio,
            separationFactor,
            logVolatility,
            stages
        ]

        guard
            outputs.allSatisfy(\.isFinite),
            stages > 0
        else {
            throw FenskeMinimumStagesError
                .numericalFailure
        }

        return .init(
            minimumTheoreticalStages:
                stages,
            separationFactor:
                separationFactor,
            distillateLightHeavyRatio:
                distillateRatio,
            bottomsLightHeavyRatio:
                bottomsRatio,
            logarithmicVolatility:
                logVolatility,
            modelName:
                "Binary Fenske total-reflux stage estimate",
            limitationDescription:
                "Returns the minimum number of theoretical stages at total reflux using one average relative volatility."
        )
    }
}
