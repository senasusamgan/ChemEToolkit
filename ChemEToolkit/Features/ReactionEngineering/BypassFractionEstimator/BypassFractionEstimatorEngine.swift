struct BypassFractionEstimatorEngine:
    Sendable {

    private let rangeTolerance =
        1.0e-12

    func calculate(
        _ input:
            BypassFractionEstimatorInput
    ) throws
        -> BypassFractionEstimatorResult {

        let values = [
            input.inletTracerConcentration,
            input.immediateOutletTracerConcentration,
            input.totalVolumetricFlowRate
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BypassFractionEstimatorError
                .nonFiniteInput
        }

        guard
            input.inletTracerConcentration > 0
        else {
            throw BypassFractionEstimatorError
                .nonPositiveInletConcentration
        }

        guard
            input.immediateOutletTracerConcentration >= 0
        else {
            throw BypassFractionEstimatorError
                .negativeOutletConcentration
        }

        guard
            input.immediateOutletTracerConcentration
            <= input.inletTracerConcentration
            * (
                1 + rangeTolerance
            )
        else {
            throw BypassFractionEstimatorError
                .outletExceedsInlet
        }

        guard
            input.totalVolumetricFlowRate > 0
        else {
            throw BypassFractionEstimatorError
                .nonPositiveFlowRate
        }

        let bypassFraction =
            min(
                1,
                input.immediateOutletTracerConcentration
                / input.inletTracerConcentration
            )

        let reactorFraction =
            1 - bypassFraction

        let bypassFlow =
            bypassFraction
            * input.totalVolumetricFlowRate

        let reactorFlow =
            reactorFraction
            * input.totalVolumetricFlowRate

        let interpretation: String

        if bypassFraction < 0.01 {
            interpretation =
                "No meaningful immediate bypass is indicated."
        } else if bypassFraction < 0.10 {
            interpretation =
                "A small immediate bypass fraction is indicated."
        } else if bypassFraction < 0.30 {
            interpretation =
                "A moderate immediate bypass fraction is indicated."
        } else {
            interpretation =
                "A large immediate bypass fraction is indicated."
        }

        let results = [
            bypassFraction,
            reactorFraction,
            bypassFlow,
            reactorFlow
        ]

        guard
            results.allSatisfy(\.isFinite),
            bypassFraction >= 0,
            bypassFraction <= 1,
            reactorFraction >= 0,
            reactorFraction <= 1,
            bypassFlow >= 0,
            reactorFlow >= 0
        else {
            throw BypassFractionEstimatorError
                .numericalFailure
        }

        return .init(
            bypassFraction:
                bypassFraction,
            reactorPathFraction:
                reactorFraction,
            bypassFlowRate:
                bypassFlow,
            reactorPathFlowRate:
                reactorFlow,
            concentrationRatio:
                bypassFraction,
            interpretationDescription:
                interpretation,
            modelName:
                "Immediate step-tracer bypass estimate b = C_out(0⁺)/C_in",
            limitationDescription:
                "Assumes the immediate outlet tracer signal originates only from a zero-residence-time bypass stream. Detector delay, axial dispersion and imperfect tracer injection are not separated."
        )
    }
}
