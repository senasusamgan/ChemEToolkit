import SwiftUI

struct ChemicalProcessRiskMatrixView:
    View {

    @State private var likelihoodInput = "4"
    @State private var severityInput = "5"
    @State private var safeguardInput = "3"

    @State private var result:
        ChemicalProcessRiskMatrixResult?

    @State private var errorMessage = ""

    private let engine =
        ChemicalProcessRiskMatrixEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "exclamationmark.triangle.fill",
                    title: "Chemical Process Risk Matrix",
                    subtitle: "Screen inherent and residual risk with a five-by-five matrix",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("Likelihood and severity create the inherent score; a bounded safeguard credit produces a residual screening score.")
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
                            title: "Likelihood Rating",
                            symbol: "L",
                            unit: "1–5",
                            placeholder: "4",
                            text: $likelihoodInput
                        )

                        EngineeringInputField(
                            title: "Severity Rating",
                            symbol: "S",
                            unit: "1–5",
                            placeholder: "5",
                            text: $severityInput
                        )

                        EngineeringInputField(
                            title: "Existing Safeguard Credit",
                            symbol: "C",
                            unit: "0–4 score reduction",
                            placeholder: "3",
                            text: $safeguardInput
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
                            systemImage: "exclamationmark.triangle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Inherent Risk Score",
                                        value: String(result.inherentRiskScore),
                                        unit: "score"
                                    ),
.init(
                                        label: "Inherent Risk Band",
                                        value: result.inherentRiskBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Residual Risk Score",
                                        value: String(result.residualRiskScore),
                                        unit: "score"
                                    ),
.init(
                                        label: "Residual Risk Band",
                                        value: result.residualRiskBand,
                                        unit: "—"
                                    ),
.init(
                                        label: "Risk Reduction",
                                        value: numberFormatter.format(100 * result.riskReductionFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Action Priority",
                                        value: result.actionPriority,
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
        .navigationTitle("Chemical Process Risk Matrix")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    likelihoodRating:
                        try InputValidator.parseNumber(
                            likelihoodInput,
                            fieldName:
                                "likelihood rating"
                        ),
                    severityRating:
                        try InputValidator.parseNumber(
                            severityInput,
                            fieldName:
                                "severity rating"
                        ),
                    existingSafeguardCredit:
                        try InputValidator.parseNumber(
                            safeguardInput,
                            fieldName:
                                "existing safeguard credit"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        likelihoodInput = "4"
        severityInput = "5"
        safeguardInput = "3"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        likelihoodInput = ""
        severityInput = ""
        safeguardInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ChemicalProcessRiskMatrixView()
    }
}
