import SwiftUI

struct ConversionFromRTDView: View {
    @State private var rateInput = "0.2"
    @State private var timesInput = "0, 2, 4, 6, 8"
    @State private var eInput = "0, 0.125, 0.375, 0.125, 0"

    @State private var result: ConversionFromRTDResult?
    @State private var errorMessage = ""

    private let engine = ConversionFromRTDEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "function",
                    title: "Conversion from RTD",
                    subtitle: "Predict first-order conversion from residence-time data",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(title: "First-Order Rate Constant", symbol: "k", unit: "1/time", placeholder: "0.2", text: $rateInput)
                        EngineeringInputField(title: "Times", symbol: "t", unit: "comma-separated", placeholder: "0, 2, 4, 6, 8", text: $timesInput)
                        EngineeringInputField(title: "E Values", symbol: "E", unit: "comma-separated", placeholder: "0, 0.125, 0.375, 0.125, 0", text: $eInput)

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
                            systemImage: "function",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(label: "RTD Conversion", value: numberFormatter.format(100 * result.conversionFraction), unit: "%"),
                                        .init(label: "Outlet Unreacted Fraction", value: numberFormatter.format(result.outletUnreactedFraction), unit: "—"),
                                        .init(label: "Mean Residence Time", value: numberFormatter.format(result.meanResidenceTime), unit: "time"),
                                        .init(label: "Ideal PFR Conversion", value: numberFormatter.format(100 * result.idealPFRConversion), unit: "%"),
                                        .init(label: "Ideal CSTR Conversion", value: numberFormatter.format(100 * result.idealCSTRConversion), unit: "%")
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
        .navigationTitle("Conversion from RTD")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            let times = try parseList(timesInput, fieldName: "times")
            let eValues = try parseList(eInput, fieldName: "E values")
            result = try engine.calculate(.init(
                firstOrderRateConstant: try InputValidator.parseNumber(rateInput, fieldName: "first-order rate constant"),
                times: times,
                eValues: eValues
            ))
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        rateInput = "0.2"
        timesInput = "0, 2, 4, 6, 8"
        eInput = "0, 0.125, 0.375, 0.125, 0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        rateInput = ""
        timesInput = ""
        eInput = ""
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
    NavigationStack { ConversionFromRTDView() }
}
