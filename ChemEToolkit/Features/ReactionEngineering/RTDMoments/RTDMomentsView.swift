import SwiftUI

struct RTDMomentsView: View {
    @State private var timesInput = "0, 2, 4, 6, 8"
    @State private var concentrationsInput = "0, 1, 3, 1, 0"

    @State private var result: RTDMomentsResult?
    @State private var errorMessage = ""

    private let engine = RTDMomentsEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "waveform.path",
                    title: "RTD Moments",
                    subtitle: "Calculate mean residence time and variance from tracer data",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(title: "Times", symbol: "t", unit: "comma-separated", placeholder: "0, 2, 4, 6, 8", text: $timesInput)
                        EngineeringInputField(title: "Concentrations", symbol: "C", unit: "comma-separated", placeholder: "0, 1, 3, 1, 0", text: $concentrationsInput)

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
                            systemImage: "waveform.path",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(label: "Tracer Area", value: numberFormatter.format(result.tracerArea), unit: "C·time"),
                                        .init(label: "Mean Residence Time", value: numberFormatter.format(result.meanResidenceTime), unit: "time"),
                                        .init(label: "Variance", value: numberFormatter.format(result.variance), unit: "time²"),
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
        .navigationTitle("RTD Moments")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            let times = try parseList(timesInput, fieldName: "times")
            let concentrations = try parseList(concentrationsInput, fieldName: "concentrations")
            result = try engine.calculate(.init(times: times, concentrations: concentrations))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        timesInput = "0, 2, 4, 6, 8"
        concentrationsInput = "0, 1, 3, 1, 0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        timesInput = ""
        concentrationsInput = ""
        result = nil
        errorMessage = ""
    }

    private func parseList(_ text: String, fieldName: String) throws -> [Double] {
        try text.split(separator: ",").map {
            try InputValidator.parseNumber(
                String($0).trimmingCharacters(in: .whitespaces),
                fieldName: fieldName
            )
        }
    }
}

#Preview {
    NavigationStack { RTDMomentsView() }
}
