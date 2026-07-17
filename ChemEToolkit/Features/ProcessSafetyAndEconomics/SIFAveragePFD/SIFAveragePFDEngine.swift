struct SIFAveragePFDEngine:
    Sendable {

    func calculate(
        _ input:
            SIFAveragePFDInput
    ) throws
        -> SIFAveragePFDResult {

        let values = [
            input.dangerousFailureRate,
            input.diagnosticCoverageFraction,
            input.proofTestIntervalHours,
            input.meanRepairTimeHours,
            input.commonCausePFD
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SIFAveragePFDError
                .nonFiniteInput
        }

        guard input.dangerousFailureRate > 0 else {
            throw SIFAveragePFDError
                .nonPositiveFailureRate
        }

        guard
            input.diagnosticCoverageFraction >= 0,
            input.diagnosticCoverageFraction <= 1
        else {
            throw SIFAveragePFDError
                .diagnosticCoverageOutsideRange
        }

        guard input.proofTestIntervalHours > 0 else {
            throw SIFAveragePFDError
                .nonPositiveProofTestInterval
        }

        guard input.meanRepairTimeHours >= 0 else {
            throw SIFAveragePFDError
                .negativeRepairTime
        }

        guard
            input.commonCausePFD >= 0,
            input.commonCausePFD <= 1
        else {
            throw SIFAveragePFDError
                .commonCausePFDOutsideRange
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

        let undetectedContribution =
            undetectedRate
            * input.proofTestIntervalHours
            / 2

        let detectedContribution =
            detectedRate
            * input.meanRepairTimeHours

        let totalPFD =
            undetectedContribution
            + detectedContribution
            + input.commonCausePFD

        guard totalPFD <= 1 else {
            throw SIFAveragePFDError
                .modelOutsideProbabilityRange
        }

        let riskReductionFactor =
            totalPFD > 0
            ? 1 / totalPFD
            : Double.infinity

        let band: String
        let description: String

        switch totalPFD {
        case ..<0.00001:
            band =
                "Better than conventional SIL 4 range"
            description =
                "The simplified average PFD is below 10⁻⁵."

        case ..<0.0001:
            band = "SIL 4"
            description =
                "The simplified average PFD lies from 10⁻⁵ to below 10⁻⁴."

        case ..<0.001:
            band = "SIL 3"
            description =
                "The simplified average PFD lies from 10⁻⁴ to below 10⁻³."

        case ..<0.01:
            band = "SIL 2"
            description =
                "The simplified average PFD lies from 10⁻³ to below 10⁻²."

        case ..<0.1:
            band = "SIL 1"
            description =
                "The simplified average PFD lies from 10⁻² to below 10⁻¹."

        default:
            band = "Below SIL 1 performance range"
            description =
                "The simplified average PFD is at least 10⁻¹."
        }

        let results = [
            undetectedRate,
            detectedRate,
            undetectedContribution,
            detectedContribution,
            totalPFD,
            riskReductionFactor
        ]

        guard
            results.allSatisfy(\.isFinite),
            undetectedRate >= 0,
            detectedRate >= 0,
            undetectedContribution >= 0,
            detectedContribution >= 0,
            totalPFD > 0,
            riskReductionFactor >= 1
        else {
            throw SIFAveragePFDError
                .numericalFailure
        }

        return .init(
            dangerousUndetectedFailureRate:
                undetectedRate,
            dangerousDetectedFailureRate:
                detectedRate,
            undetectedPFDContribution:
                undetectedContribution,
            detectedPFDContribution:
                detectedContribution,
            commonCausePFDContribution:
                input.commonCausePFD,
            averageProbabilityOfFailureOnDemand:
                totalPFD,
            riskReductionFactor:
                riskReductionFactor,
            lowDemandSILBand:
                band,
            assessmentDescription:
                description,
            modelName:
                "Simplified low-demand 1oo1 SIF average PFD",
            limitationDescription:
                "This educational approximation does not verify IEC 61511 compliance. Architecture, proof-test coverage, partial testing, repair states, systematic capability, common cause and subsystem dependencies require validated reliability analysis."
        )
    }
}
