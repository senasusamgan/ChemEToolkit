import Foundation
import SwiftUI

struct ECurveGeneratorView:
    View {

    @State private var timesInput =
        "0, 2, 4, 6, 8"

    @State private var concentrationsInput =
        "0, 1, 3, 1, 0"

    @State private var result:
        ECurveGeneratorResult?

    @State private var errorMessage = ""

    private let engine =
        ECurveGeneratorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "waveform.path.ecg",
                    title:
                        "E-Curve Generator",
                    subtitle:
                        "Normalize pulse-tracer data into the exit-age distribution E(t)",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Pulse-Tracer Normalization")
                            .font(.headline)

                        Text(
                            "E(t) = C(t) / ∫C(t)dt"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Enter comma-separated time and tracer-concentration values."
                        )
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    }
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
                            title: "Times",
                            symbol: "t",
                            unit: "comma-separated",
                            placeholder:
                                "0, 2, 4, 6, 8",
                            text: $timesInput
                        )

                        EngineeringInputField(
                            title:
                                "Tracer Concentrations",
                            symbol: "C",
                            unit: "comma-separated",
                            placeholder:
                                "0, 1, 3, 1, 0",
                            text:
                                $concentrationsInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label(
                                    "Load Example",
                                    systemImage: "arrow.counterclockwise"
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
                            title:
                                "Generate E-Curve",
                            systemImage:
                                "waveform.path.ecg",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Raw Tracer Area",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .rawTracerArea
                                                ),
                                            unit:
                                                "concentration·time"
                                        ),
                                        .init(
                                            label:
                                                "Normalized Area",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .normalizedArea
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label:
                                                "Mean Residence Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .meanResidenceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Peak Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .peakTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Peak E(t)",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .peakEValue
                                                ),
                                            unit: "1/time"
                                        ),
                                        .init(
                                            label:
                                                "Generated Points",
                                            value:
                                                "\(result.eValues.count)",
                                            unit: "points"
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
        .navigationTitle("E-Curve")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    times:
                        try parseList(
                            timesInput,
                            fieldName: "times"
                        ),
                    tracerConcentrations:
                        try parseList(
                            concentrationsInput,
                            fieldName:
                                "tracer concentrations"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        timesInput =
            "0, 2, 4, 6, 8"
        concentrationsInput =
            "0, 1, 3, 1, 0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        timesInput = ""
        concentrationsInput = ""
        result = nil
        errorMessage = ""
    }


    private func parseList(
        _ text: String,
        fieldName: String
    ) throws -> [Double] {
        try text
            .split(separator: ",")
            .map {
                try InputValidator.parseNumber(
                    String($0)
                        .trimmingCharacters(
                            in: .whitespaces
                        ),
                    fieldName: fieldName
                )
            }
    }

}

#Preview {
    NavigationStack {
        ECurveGeneratorView()
    }
}
