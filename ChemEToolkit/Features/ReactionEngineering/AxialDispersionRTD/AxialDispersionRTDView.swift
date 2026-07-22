import SwiftUI

struct AxialDispersionRTDView: View {
    @State private var meanInput = "10"
    @State private var pecletInput = "20"
    @State private var timeInput = "10"

    @State private var result: AxialDispersionRTDResult?
    @State private var errorMessage = ""

    private let engine = AxialDispersionRTDEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.left.and.right",
                    title: "Axial-Dispersion RTD",
                    subtitle: "Evaluate RTD broadening from the Peclet number",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(title: "Mean Residence Time", symbol: "τ", unit: "time", placeholder: "10", text: $meanInput)
                        EngineeringInputField(title: "Peclet Number", symbol: "Pe", unit: "—", placeholder: "20", text: $pecletInput)
                        EngineeringInputField(title: "Evaluation Time", symbol: "t", unit: "time", placeholder: "10", text: $timeInput)

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "arrow.left.and.right",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(label: "E(t)", value: numberFormatter.format(result.eValue), unit: "1/time"),
                                        .init(label: "Dimensionless E", value: numberFormatter.format(result.dimensionlessEValue), unit: "—"),
                                        .init(label: "Dimensionless Variance", value: numberFormatter.format(result.dimensionlessVariance), unit: "—"),
                                        .init(label: "Standard Deviation", value: numberFormatter.format(result.standardDeviation), unit: "time"),
                                        .init(label: "Equivalent Tanks", value: numberFormatter.format(result.equivalentTanksInSeries), unit: "—")
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(alignment: .leading, spacing: AppSpacing.small) {
                                        Text(result.modelName).font(.headline)
                                        Divider()
                                        Text(result.limitationDescription)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Axial-Dispersion RTD")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(.init(
                meanResidenceTime: try InputValidator.parseNumber(meanInput, fieldName: "mean residence time"),
                pecletNumber: try InputValidator.parseNumber(pecletInput, fieldName: "Peclet number"),
                evaluationTime: try InputValidator.parseNumber(timeInput, fieldName: "evaluation time")
            ))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        meanInput = "10"
        pecletInput = "20"
        timeInput = "10"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        meanInput = ""
        pecletInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }


}

#Preview {
    NavigationStack { AxialDispersionRTDView() }
}
