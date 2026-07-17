import SwiftUI

struct ProofTestIntervalCalculatorView:
    View {

    @State private var failureRateInput = "0.000001"
    @State private var coverageInput = "0.5"
    @State private var repairInput = "8"
    @State private var commonCauseInput = "0.00001"
    @State private var targetInput = "0.0015"

    @State private var result:
        ProofTestIntervalCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        ProofTestIntervalCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "calendar.badge.exclamationmark",
                    title: "Proof-Test Interval Calculator",
                    subtitle: "Solve a simplified maximum interval from a target PFD budget",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The target PFD budget is reduced by detected and common-cause contributions before solving the undetected-failure interval.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(
                    maxWidth:
                        AppTheme.Layout
                            .calculatorMaxWidth
                )

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Dangerous Failure Rate",
                            symbol: "λ_D",
                            unit: "1/hour",
                            placeholder: "0.000001",
                            text: $failureRateInput
                        )

                        EngineeringInputField(
                            title: "Diagnostic Coverage",
                            symbol: "DC",
                            unit: "fraction",
                            placeholder: "0.5",
                            text: $coverageInput
                        )

                        EngineeringInputField(
                            title: "Mean Repair Time",
                            symbol: "MTTR",
                            unit: "hour",
                            placeholder: "8",
                            text: $repairInput
                        )

                        EngineeringInputField(
                            title: "Common-Cause PFD",
                            symbol: "PFD_CC",
                            unit: "—",
                            placeholder: "0.00001",
                            text: $commonCauseInput
                        )

                        EngineeringInputField(
                            title: "Target Average PFD",
                            symbol: "PFD_target",
                            unit: "—",
                            placeholder: "0.0015",
                            text: $targetInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage:
                                        "arrow.counterclockwise"
                                )
                            }

                            Spacer()

                            Button(
                                role: .destructive,
                                action: resetInputs
                            ) {
                                Label(
                                    "Clear",
                                    systemImage: "trash"
                                )
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "calendar.badge.exclamationmark",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Fixed PFD Contribution",
                                        value: numberFormatter.format(result.fixedPFDContribution),
                                        unit: "—"
                                    ),
.init(
                                        label: "Remaining PFD Allowance",
                                        value: numberFormatter.format(result.remainingPFDAllowance),
                                        unit: "—"
                                    ),
.init(
                                        label: "Maximum Proof-Test Interval",
                                        value: numberFormatter.format(result.maximumProofTestIntervalHours),
                                        unit: "hour"
                                    ),
.init(
                                        label: "Maximum Proof-Test Interval",
                                        value: numberFormatter.format(result.maximumProofTestIntervalDays),
                                        unit: "day"
                                    ),
.init(
                                        label: "Target Risk Reduction Factor",
                                        value: numberFormatter.format(result.targetRiskReductionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Target Low-Demand Band",
                                        value: result.targetLowDemandBand,
                                        unit: "—"
                                    )
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(
                                    alignment: .leading,
                                    spacing: AppSpacing.small
                                ) {
                                    Text(result.modelName)
                                        .font(.headline)

                                    Divider()

                                    Text(
                                        result
                                            .limitationDescription
                                    )
                                    .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(
                                message: errorMessage
                            )
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(
                .horizontal,
                AppTheme.Layout
                    .pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout
                    .pageVerticalPadding
            )
        }
        .navigationTitle("Proof-Test Interval Calculator")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    dangerousFailureRate:
                        try InputValidator.parseNumber(
                            failureRateInput,
                            fieldName:
                                "dangerous failure rate"
                        ),
                    diagnosticCoverageFraction:
                        try InputValidator.parseNumber(
                            coverageInput,
                            fieldName:
                                "diagnostic coverage"
                        ),
                    meanRepairTimeHours:
                        try InputValidator.parseNumber(
                            repairInput,
                            fieldName:
                                "mean repair time"
                        ),
                    commonCausePFD:
                        try InputValidator.parseNumber(
                            commonCauseInput,
                            fieldName:
                                "common-cause PFD"
                        ),
                    targetAveragePFD:
                        try InputValidator.parseNumber(
                            targetInput,
                            fieldName:
                                "target average PFD"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        failureRateInput = "0.000001"
        coverageInput = "0.5"
        repairInput = "8"
        commonCauseInput = "0.00001"
        targetInput = "0.0015"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        failureRateInput = ""
        coverageInput = ""
        repairInput = ""
        commonCauseInput = ""
        targetInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ProofTestIntervalCalculatorView()
    }
}
