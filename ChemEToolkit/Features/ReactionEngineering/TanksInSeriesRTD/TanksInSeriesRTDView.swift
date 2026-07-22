import SwiftUI

struct TanksInSeriesRTDView: View {
    @State private var meanInput = "10"
    @State private var countInput = "4"
    @State private var timeInput = "8"

    @State private var result: TanksInSeriesRTDResult?
    @State private var errorMessage = ""

    private let engine = TanksInSeriesRTDEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "square.stack.3d.up.fill",
                    title: "Tanks-in-Series RTD",
                    subtitle: "Evaluate the RTD curve for N ideal tanks",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(title: "Mean Residence Time", symbol: "τ", unit: "time", placeholder: "10", text: $meanInput)
                        EngineeringInputField(title: "Number of Tanks", symbol: "N", unit: "whole number", placeholder: "4", text: $countInput)
                        EngineeringInputField(title: "Evaluation Time", symbol: "t", unit: "time", placeholder: "8", text: $timeInput)

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
                            systemImage: "square.stack.3d.up.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(label: "E(t)", value: numberFormatter.format(result.eValue), unit: "1/time"),
                                        .init(label: "Dimensionless Time", value: numberFormatter.format(result.dimensionlessTime), unit: "—"),
                                        .init(label: "Variance", value: numberFormatter.format(result.variance), unit: "time²"),
                                        .init(label: "Standard Deviation", value: numberFormatter.format(result.standardDeviation), unit: "time"),
                                        .init(label: "Peak Time", value: numberFormatter.format(result.peakTime), unit: "time")
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
        .navigationTitle("Tanks-in-Series RTD")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(.init(
                meanResidenceTime: try InputValidator.parseNumber(meanInput, fieldName: "mean residence time"),
                numberOfTanks: try InputValidator.parseNumber(countInput, fieldName: "number of tanks"),
                evaluationTime: try InputValidator.parseNumber(timeInput, fieldName: "evaluation time")
            ))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        meanInput = "10"
        countInput = "4"
        timeInput = "8"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        meanInput = ""
        countInput = ""
        timeInput = ""
        result = nil
        errorMessage = ""
    }


}

#Preview {
    NavigationStack { TanksInSeriesRTDView() }
}
