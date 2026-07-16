import Foundation
import SwiftUI

struct StepResponseRTDAnalysisView:
    View {

    @State private var timesInput =
        "0, 2, 4, 6, 8, 10"

    @State private var responsesInput =
        "0.1, 0.2, 0.5, 0.8, 0.95, 1"

    @State private var result:
        StepResponseRTDAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        StepResponseRTDAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "chart.xyaxis.line",
                    title:
                        "Step-Response RTD Analysis",
                    subtitle:
                        "Extract mean time, median time and interval E values from F(t)",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Step-Tracer Analysis")
                            .font(.headline)

                        Text(
                            "t̄ = ∫[1−F(t)]dt"
                        )
                        .font(
                            .system(
                                size: 19,
                                weight: .semibold
                            )
                        )

                        Text(
                            "Enter normalized outlet responses F(t) between zero and one."
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
                                "0, 2, 4, 6, 8, 10",
                            text: $timesInput
                        )

                        EngineeringInputField(
                            title:
                                "Normalized Outlet Responses",
                            symbol: "F(t)",
                            unit: "comma-separated",
                            placeholder:
                                "0.1, 0.2, 0.5, 0.8, 0.95, 1",
                            text: $responsesInput
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
                                "Analyze Step Response",
                            systemImage:
                                "chart.xyaxis.line",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
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
                                                "Median Residence Time",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .medianResidenceTime
                                                ),
                                            unit: "time"
                                        ),
                                        .init(
                                            label:
                                                "Immediate Bypass Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .immediateBypassFraction
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Final Response",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .finalResponse
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Interval E Values",
                                            value:
                                                "\(result.intervalEValues.count)",
                                            unit: "intervals"
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
        .navigationTitle("Step-Response RTD")
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
                    normalizedOutletResponses:
                        try parseList(
                            responsesInput,
                            fieldName:
                                "normalized outlet responses"
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
            "0, 2, 4, 6, 8, 10"
        responsesInput =
            "0.1, 0.2, 0.5, 0.8, 0.95, 1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        timesInput = ""
        responsesInput = ""
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
        StepResponseRTDAnalysisView()
    }
}
