import Foundation

struct BatchAdsorptionDesignEngine:
    Sendable {

    private let zeroTolerance =
        1.0e-14

    func calculate(
        _ input:
            BatchAdsorptionDesignInput
    ) throws
        -> BatchAdsorptionDesignResult {

        let values = [
            input.solutionVolume,
            input.initialConcentration,
            input.targetEquilibriumConcentration,
            input.maximumAdsorptionCapacity,
            input.langmuirConstant,
            input.freundlichConstant,
            input.freundlichExponent,
            input.linearDistributionConstant
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw
                BatchAdsorptionDesignError
                    .nonFiniteInput
        }

        guard input.solutionVolume > 0 else {
            throw
                BatchAdsorptionDesignError
                    .nonPositiveSolutionVolume
        }

        guard
            input.initialConcentration > 0,
            input.targetEquilibriumConcentration
            >= 0,
            input.targetEquilibriumConcentration
            < input.initialConcentration
        else {
            throw
                BatchAdsorptionDesignError
                    .invalidConcentrationOrdering
        }

        let equilibriumConcentration =
            input.targetEquilibriumConcentration

        let equilibriumLoading: Double
        let equation: String

        switch input.model {
        case .langmuir:
            guard
                input.maximumAdsorptionCapacity
                > 0,
                input.langmuirConstant > 0
            else {
                throw
                    BatchAdsorptionDesignError
                        .nonPositiveModelParameter
            }

            equilibriumLoading =
                input.maximumAdsorptionCapacity
                * input.langmuirConstant
                * equilibriumConcentration
                / (
                    1
                    + input.langmuirConstant
                    * equilibriumConcentration
                )

            equation =
                "qe = qmax bCe / (1 + bCe)"

        case .freundlich:
            guard
                input.freundlichConstant > 0
            else {
                throw
                    BatchAdsorptionDesignError
                        .nonPositiveModelParameter
            }

            guard input.freundlichExponent > 1 else {
                throw
                    BatchAdsorptionDesignError
                        .invalidFreundlichExponent
            }

            equilibriumLoading =
                input.freundlichConstant
                * pow(
                    equilibriumConcentration,
                    1
                    / input.freundlichExponent
                )

            equation =
                "qe = KF Ce^(1/n)"

        case .linear:
            guard
                input.linearDistributionConstant
                > 0
            else {
                throw
                    BatchAdsorptionDesignError
                        .nonPositiveModelParameter
            }

            equilibriumLoading =
                input.linearDistributionConstant
                * equilibriumConcentration

            equation =
                "qe = K Ce"
        }

        guard
            equilibriumLoading.isFinite,
            equilibriumLoading
            > zeroTolerance
        else {
            throw
                BatchAdsorptionDesignError
                    .zeroEquilibriumLoading
        }

        let soluteRemovedMass =
            input.solutionVolume
            * (
                input.initialConcentration
                - equilibriumConcentration
            )

        let requiredAdsorbentMass =
            soluteRemovedMass
            / equilibriumLoading

        let removalFraction =
            (
                input.initialConcentration
                - equilibriumConcentration
            )
            / input.initialConcentration

        let adsorbentToVolumeRatio =
            requiredAdsorbentMass
            / input.solutionVolume

        let equilibriumLiquidMass =
            input.solutionVolume
            * equilibriumConcentration

        let results = [
            equilibriumLoading,
            soluteRemovedMass,
            requiredAdsorbentMass,
            removalFraction,
            adsorbentToVolumeRatio,
            equilibriumLiquidMass
        ]

        guard
            results.allSatisfy(\.isFinite),
            equilibriumLoading > 0,
            soluteRemovedMass > 0,
            requiredAdsorbentMass > 0,
            removalFraction > 0,
            removalFraction <= 1,
            adsorbentToVolumeRatio > 0,
            equilibriumLiquidMass >= 0
        else {
            throw
                BatchAdsorptionDesignError
                    .numericalFailure
        }

        return
            BatchAdsorptionDesignResult(
                model: input.model,
                targetEquilibriumLoading:
                    equilibriumLoading,
                soluteRemovedMass:
                    soluteRemovedMass,
                requiredAdsorbentMass:
                    requiredAdsorbentMass,
                removalFraction:
                    removalFraction,
                adsorbentToSolutionVolumeRatio:
                    adsorbentToVolumeRatio,
                equilibriumLiquidSoluteMass:
                    equilibriumLiquidMass,
                activeEquation: equation,
                modelName:
                    "\(input.model.title) equilibrium batch-adsorption design",
                limitationDescription:
                    "The vessel is assumed perfectly mixed and at equilibrium; solution volume change, adsorbent displacement and kinetic limitations are neglected."
            )
    }
}
