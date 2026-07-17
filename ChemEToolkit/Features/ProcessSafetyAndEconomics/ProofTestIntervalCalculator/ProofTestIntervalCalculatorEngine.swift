struct ProofTestIntervalCalculatorEngine:
    Sendable {

    func calculate(
        _ input:
            ProofTestIntervalCalculatorInput
    ) throws
        -> ProofTestIntervalCalculatorResult {

        let values = [
            input.dangerousFailureRate,
            input.diagnosticCoverageFraction,
            input.meanRepairTimeHours,
            input.commonCausePFD,
            input.targetAveragePFD
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw ProofTestIntervalCalculatorError
                .nonFiniteInput
        }

        guard input.dangerousFailureRate > 0 else {
            throw ProofTestIntervalCalculatorError
                .nonPositiveFailureRate
        }

        guard
            input.diagnosticCoverageFraction >= 0,
            input.diagnosticCoverageFraction < 1
        else {
            throw ProofTestIntervalCalculatorError
                .diagnosticCoverageOutsideRange
        }

        guard input.meanRepairTimeHours >= 0 else {
            throw ProofTestIntervalCalculatorError
                .negativeRepairTime
        }

        guard
            input.commonCausePFD >= 0,
            input.commonCausePFD <= 1
        else {
            throw ProofTestIntervalCalculatorError
                .commonCausePFDOutsideRange
        }

        guard
            input.targetAveragePFD > 0,
            input.targetAveragePFD <= 1
        else {
            throw ProofTestIntervalCalculatorError
                .targetPFDOutsideRange
        }

        let undetectedRate =
            input.dangerousFailureRate
            * (
                1
                - input.diagnosticCoverageFraction
            )

        let detectedRate =
            input.dangerousFailureRate
            * input.diagnosticCoverageFraction

        let detectedContribution =
            detectedRate
            * input.meanRepairTimeHours

        let fixedContribution =
            detectedContribution
            + input.commonCausePFD

        let remainingAllowance =
            input.targetAveragePFD
            - fixedContribution

        guard remainingAllowance > 0 else {
            throw ProofTestIntervalCalculatorError
                .noRemainingPFDBudget
        }

        let intervalHours =
            2
            * remainingAllowance
            / undetectedRate

        let intervalDays =
            intervalHours
            / 24

        let intervalYears =
            intervalDays
            / 365.25

        let achievedPFD =
            undetectedRate
            * intervalHours
            / 2
            + fixedContribution

        let targetRRF =
            1
            / input.targetAveragePFD

        let targetBand: String

        switch input.targetAveragePFD {
        case ..<0.00001:
            targetBand =
                "Better than conventional SIL 4 range"
        case ..<0.0001:
            targetBand = "SIL 4"
        case ..<0.001:
            targetBand = "SIL 3"
        case ..<0.01:
            targetBand = "SIL 2"
        case ..<0.1:
            targetBand = "SIL 1"
        default:
            targetBand =
                "Below SIL 1 performance range"
        }

        let results = [
            undetectedRate,
            detectedRate,
            fixedContribution,
            remainingAllowance,
            intervalHours,
            intervalDays,
            intervalYears,
            achievedPFD,
            targetRRF
        ]

        guard
            results.allSatisfy(\.isFinite),
            undetectedRate > 0,
            detectedRate >= 0,
            fixedContribution >= 0,
            remainingAllowance > 0,
            intervalHours > 0,
            intervalDays > 0,
            intervalYears > 0,
            achievedPFD > 0,
            achievedPFD <= 1,
            targetRRF >= 1
        else {
            throw ProofTestIntervalCalculatorError
                .numericalFailure
        }

        return .init(
            dangerousUndetectedFailureRate:
                undetectedRate,
            dangerousDetectedFailureRate:
                detectedRate,
            fixedPFDContribution:
                fixedContribution,
            remainingPFDAllowance:
                remainingAllowance,
            maximumProofTestIntervalHours:
                intervalHours,
            maximumProofTestIntervalDays:
                intervalDays,
            maximumProofTestIntervalYears:
                intervalYears,
            achievedAveragePFDAtInterval:
                achievedPFD,
            targetRiskReductionFactor:
                targetRRF,
            targetLowDemandBand:
                targetBand,
            modelName:
                "Proof-test interval from simplified low-demand 1oo1 PFD budget",
            limitationDescription:
                "The calculated interval is an educational screening result, not a maintenance recommendation. Proof-test coverage, architecture, partial testing, demand rate, repair policy and lifecycle requirements must be assessed by competent functional-safety personnel."
        )
    }
}
