struct BlockDiagramAlgebraEngine:
    Sendable {

    private let tolerance = 1e-12

    func calculate(
        _ input: BlockDiagramAlgebraInput
    ) throws -> BlockDiagramAlgebraResult {

        let values = [
            input.firstForwardBlockGain,
            input.secondForwardBlockGain,
            input.feedbackBlockGain
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw BlockDiagramAlgebraError.nonFiniteInput
        }

        let series =
            input.firstForwardBlockGain
            * input.secondForwardBlockGain

        let parallel =
            input.firstForwardBlockGain
            + input.secondForwardBlockGain

        let loopGain =
            series * input.feedbackBlockGain

        let negativeDenominator = 1 + loopGain
        let positiveDenominator = 1 - loopGain

        let negativeGain =
            abs(negativeDenominator) > tolerance
            ? series / negativeDenominator
            : nil

        let positiveGain =
            abs(positiveDenominator) > tolerance
            ? series / positiveDenominator
            : nil

        let negativeSensitivity =
            abs(negativeDenominator) > tolerance
            ? 1 / negativeDenominator
            : nil

        let positiveSensitivity =
            abs(positiveDenominator) > tolerance
            ? 1 / positiveDenominator
            : nil

        let singularity: String

        if negativeGain == nil && positiveGain == nil {
            singularity = "Both feedback configurations are singular."
        } else if negativeGain == nil {
            singularity = "Negative-feedback denominator 1 + L is singular."
        } else if positiveGain == nil {
            singularity = "Positive-feedback denominator 1 − L is singular."
        } else {
            singularity = "Both feedback reductions are finite."
        }

        let finiteValues = [series, parallel, loopGain]

        guard finiteValues.allSatisfy(\.isFinite) else {
            throw BlockDiagramAlgebraError.numericalFailure
        }

        return .init(
            seriesGain: series,
            parallelGain: parallel,
            loopGain: loopGain,
            negativeFeedbackGain: negativeGain,
            positiveFeedbackGain: positiveGain,
            negativeFeedbackSensitivity: negativeSensitivity,
            positiveFeedbackSensitivity: positiveSensitivity,
            singularityDescription: singularity,
            modelName: "Static scalar block-diagram reduction",
            limitationDescription: "Applies series, parallel and single-loop feedback formulas to scalar gains. Dynamic transfer functions, summing-junction signs and multiloop structures require symbolic block-diagram analysis."
        )
    }
}
