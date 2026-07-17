struct SafetyIntegrityLevelTargetEngine:
    Sendable {

    func calculate(
        _ input:
            SafetyIntegrityLevelTargetInput
    ) throws
        -> SafetyIntegrityLevelTargetResult {

        let values = [
            input.unmitigatedEventFrequency,
            input.tolerableEventFrequency,
            input.nonSISRiskReductionFactor
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw SafetyIntegrityLevelTargetError
                .nonFiniteInput
        }

        guard
            input.unmitigatedEventFrequency > 0,
            input.tolerableEventFrequency > 0
        else {
            throw SafetyIntegrityLevelTargetError
                .nonPositiveFrequency
        }

        guard
            input.nonSISRiskReductionFactor >= 1
        else {
            throw SafetyIntegrityLevelTargetError
                .invalidNonSISRiskReductionFactor
        }

        let frequencyAfterNonSIS =
            input.unmitigatedEventFrequency
            / input.nonSISRiskReductionFactor

        let requiredRRF =
            max(
                1,
                frequencyAfterNonSIS
                / input.tolerableEventFrequency
            )

        let requiredPFD =
            1 / requiredRRF

        let classificationBoundaries = [
            1.0,
            10.0,
            100.0,
            1_000.0,
            10_000.0,
            100_000.0
        ]

        let classificationRRF =
            classificationBoundaries
                .first {
                    abs(
                        requiredRRF
                        - $0
                    )
                    <= max(
                        1e-12,
                        $0 * 1e-12
                    )
                }
            ?? requiredRRF

        let nonSISSufficient =
            classificationRRF <= 1

        let targetBand: String
        let description: String

        switch classificationRRF {
        case ...1:
            targetBand =
                "No additional SIF required by this screening"
            description =
                "Credited non-SIS protection reaches the entered tolerable frequency."

        case ..<10:
            targetBand =
                "Below SIL 1 range"
            description =
                "Additional risk reduction is indicated, but the required factor is below the conventional low-demand SIL 1 band."

        case ..<100:
            targetBand =
                "SIL 1"
            description =
                "Screening target falls within the conventional low-demand SIL 1 risk-reduction range."

        case ..<1_000:
            targetBand =
                "SIL 2"
            description =
                "Screening target falls within the conventional low-demand SIL 2 risk-reduction range."

        case ..<10_000:
            targetBand =
                "SIL 3"
            description =
                "Screening target falls within the conventional low-demand SIL 3 risk-reduction range."

        case ..<100_000:
            targetBand =
                "SIL 4"
            description =
                "Screening target falls within the conventional low-demand SIL 4 range; such targets require exceptional scrutiny."

        default:
            targetBand =
                "Beyond conventional SIL 4 range"
            description =
                "The required risk reduction exceeds the conventional low-demand SIL 4 range; redesign and additional independent layers should be considered."
        }

        let results = [
            frequencyAfterNonSIS,
            requiredRRF,
            requiredPFD
        ]

        guard
            results.allSatisfy(\.isFinite),
            frequencyAfterNonSIS > 0,
            requiredRRF >= 1,
            requiredPFD > 0,
            requiredPFD <= 1
        else {
            throw SafetyIntegrityLevelTargetError
                .numericalFailure
        }

        return .init(
            frequencyAfterNonSISProtection:
                frequencyAfterNonSIS,
            requiredSIFRiskReductionFactor:
                requiredRRF,
            requiredAveragePFD:
                requiredPFD,
            targetBand:
                targetBand,
            targetDescription:
                description,
            nonSISProtectionIsSufficient:
                nonSISSufficient,
            modelName:
                "Low-demand SIL target screening from frequency gap",
            limitationDescription:
                "This is not an IEC 61511 lifecycle assessment or SIL verification. Hazard allocation, demand mode, systematic capability, architecture, diagnostics, proof testing, common cause and independence require competent functional-safety analysis."
        )
    }
}
