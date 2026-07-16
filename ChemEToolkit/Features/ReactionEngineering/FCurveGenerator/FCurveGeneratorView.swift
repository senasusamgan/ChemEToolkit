import Foundation
import SwiftUI

struct FCurveGeneratorView:
    View {

    @State private var timesInput =
        "0, 2, 4, 6, 8"

    @State private var eValuesInput =
        "0, 0.1, 0.3, 0.1, 0"

    @State private var result:
        FCurveGeneratorResult?

    @State private var errorMessage = ""

    private let engine =
        FCurveGeneratorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.line.uptrend.xyaxis",
                    title:
                        "F-Curve Generator",
                    subtitle:
                        "Integrate E(t) into a cumulative residence-time distribution",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Cumulative RTD")
                            .font(.headline)

                        Text(
                            "F(t) = ∫₀ᵗ E(ξ)dξ"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "The result includes t10, t50 and t90 residence-time quantiles."
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
                            title: "E Values",
                            symbol: "E(t)",
                            unit: "comma-separated",
                            placeholder:
                                "0, 0.1, 0.3, 0.1, 0",
                            text: $eValuesInput
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
                                "Generate F-Curve",
                            systemImage:
                                "chart.line.uptrend.xyaxis",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Raw E-Curve Area",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .rawEArea
                                                ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "t10",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeAtTenPercent
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Median Time t50",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .medianResidenceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label: "t90",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .timeAtNinetyPercent
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Central 80% Span",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .centralEightyPercentSpan
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Generated Points",
                                            value:
                                                "\(result.fValues.count)",
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
        .navigationTitle("F-Curve")
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
                    eValues:
                        try parseList(
                            eValuesInput,
                            fieldName:
                                "E values"
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
        eValuesInput =
            "0, 0.1, 0.3, 0.1, 0"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        timesInput = ""
        eValuesInput = ""
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
        FCurveGeneratorView()
    }
}
