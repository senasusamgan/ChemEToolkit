import Foundation

struct AdsorptionIsothermsEngine:
    Sendable {

    func calculate(
        _ input: AdsorptionIsothermsInput
    ) throws -> AdsorptionIsothermsResult {

        let values = [
            input.equilibriumFluidConcentration,
            input.maximumAdsorptionCapacity,
            input.langmuirConstant,
            input.freundlichConstant,
            input.freundlichExponent,
            input.linearDistributionConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw AdsorptionIsothermsError
                .nonFiniteInput
        }

        guard
            input.equilibriumFluidConcentration >= 0
        else {
            throw AdsorptionIsothermsError
                .negativeConcentration
        }

        let concentration =
            input.equilibriumFluidConcentration

        let loading: Double
        let slope: Double
        let fractionalSaturation: Double?
        let equation: String
        let interpretation: String

        switch input.model {
        case .langmuir:
            guard
                input.maximumAdsorptionCapacity > 0,
                input.langmuirConstant > 0
            else {
                throw AdsorptionIsothermsError
                    .nonPositiveParameter
            }

            let denominator =
                1
                + input.langmuirConstant
                * concentration

            loading =
                input.maximumAdsorptionCapacity
                * input.langmuirConstant
                * concentration
                / denominator

            slope =
                input.maximumAdsorptionCapacity
                * input.langmuirConstant
                / pow(denominator, 2)

            fractionalSaturation =
                input.langmuirConstant
                * concentration
                / denominator

            equation =
                "q = qmax bC / (1 + bC)"

            interpretation =
                "Finite monolayer capacity with saturation at qmax."

        case .freundlich:
            guard input.freundlichConstant > 0 else {
                throw AdsorptionIsothermsError
                    .nonPositiveParameter
            }

            guard input.freundlichExponent > 1 else {
                throw AdsorptionIsothermsError
                    .invalidFreundlichExponent
            }

            let exponent =
                1 / input.freundlichExponent

            loading =
                input.freundlichConstant
                * pow(concentration, exponent)

            if concentration == 0 {
                slope = .infinity
            } else {
                slope =
                    input.freundlichConstant
                    * exponent
                    * pow(
                        concentration,
                        exponent - 1
                    )
            }

            fractionalSaturation = nil

            equation =
                "q = KF C^(1/n)"

            interpretation =
                "Empirical heterogeneous-surface isotherm without a finite saturation capacity."

        case .linear:
            guard
                input.linearDistributionConstant > 0
            else {
                throw AdsorptionIsothermsError
                    .nonPositiveParameter
            }

            loading =
                input.linearDistributionConstant
                * concentration

            slope =
                input.linearDistributionConstant

            fractionalSaturation = nil

            equation =
                "q = K C"

            interpretation =
                "Henry-law region with constant distribution slope."
        }

        guard
            loading.isFinite,
            loading >= 0,
            slope.isFinite || (
                input.model == .freundlich
                && concentration == 0
            )
        else {
            throw AdsorptionIsothermsError
                .numericalFailure
        }

        return AdsorptionIsothermsResult(
            model: input.model,
            equilibriumLoading: loading,
            localIsothermSlope: slope,
            fractionalSaturation:
                fractionalSaturation,
            activeEquation: equation,
            parameterInterpretation:
                interpretation,
            modelName:
                "\(input.model.title) adsorption isotherm"
        )
    }
}
