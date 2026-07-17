import SwiftUI

struct SIFAveragePFDView:
    View {

    @State private var failureRateInput = "0.000001"
    @State private var coverageInput = "0.5"
    @State private var intervalInput = "1000"
    @State private var repairInput = "8"
    @State private var commonCauseInput = "0.00001"

    @State private var result:
        SIFAveragePFDResult?

    @State private var errorMessage = ""

    private let engine =
        SIFAveragePFDEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "shield.checkered",
                    title: "SIF Average PFD",
                    subtitle: "Estimate simplified low-demand 1oo1 protection performance",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("The approximation separates dangerous undetected, dangerous detected and common-cause PFD contributions.")
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
                            title: "Proof-Test Interval",
                            symbol: "T",
                            unit: "hour",
                            placeholder: "1000",
                            text: $intervalInput
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
                            systemImage: "shield.checkered",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Undetected PFD Contribution",
                                        value: numberFormatter.format(result.undetectedPFDContribution),
                                        unit: "—"
                                    ),
.init(
                                        label: "Detected PFD Contribution",
                                        value: numberFormatter.format(result.detectedPFDContribution),
                                        unit: "—"
                                    ),
.init(
                                        label: "Common-Cause Contribution",
                                        value: numberFormatter.format(result.commonCausePFDContribution),
                                        unit: "—"
                                    ),
.init(
                                        label: "Average PFD",
                                        value: numberFormatter.format(result.averageProbabilityOfFailureOnDemand),
                                        unit: "—"
                                    ),
.init(
                                        label: "Risk Reduction Factor",
                                        value: numberFormatter.format(result.riskReductionFactor),
                                        unit: "—"
                                    ),
.init(
                                        label: "Low-Demand Band",
                                        value: result.lowDemandSILBand,
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
        .navigationTitle("SIF Average PFD")
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
                    proofTestIntervalHours:
                        try InputValidator.parseNumber(
                            intervalInput,
                            fieldName:
                                "proof-test interval"
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
        intervalInput = "1000"
        repairInput = "8"
        commonCauseInput = "0.00001"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        failureRateInput = ""
        coverageInput = ""
        intervalInput = ""
        repairInput = ""
        commonCauseInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SIFAveragePFDView()
    }
}
