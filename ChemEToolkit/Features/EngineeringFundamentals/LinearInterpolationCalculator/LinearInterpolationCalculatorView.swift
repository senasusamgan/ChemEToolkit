import SwiftUI

struct LinearInterpolationCalculatorView:
    View {

    @State private var x1Input = "10"
    @State private var y1Input = "100"
    @State private var x2Input = "20"
    @State private var y2Input = "180"
    @State private var targetInput = "15"

    @State private var result:
        LinearInterpolationCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        LinearInterpolationCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "point.topleft.down.to.point.bottomright.curvepath",
                    title: "Linear Interpolation",
                    subtitle: "Estimate a value between two known points",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The same relation also identifies when the target requires extrapolation.")
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
                            title: "Known x₁",
                            symbol: "x₁",
                            unit: "x unit",
                            placeholder: "10",
                            text: $x1Input
                        )

                        EngineeringInputField(
                            title: "Known y₁",
                            symbol: "y₁",
                            unit: "y unit",
                            placeholder: "100",
                            text: $y1Input
                        )

                        EngineeringInputField(
                            title: "Known x₂",
                            symbol: "x₂",
                            unit: "x unit",
                            placeholder: "20",
                            text: $x2Input
                        )

                        EngineeringInputField(
                            title: "Known y₂",
                            symbol: "y₂",
                            unit: "y unit",
                            placeholder: "180",
                            text: $y2Input
                        )

                        EngineeringInputField(
                            title: "Target x",
                            symbol: "x",
                            unit: "x unit",
                            placeholder: "15",
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
                            systemImage: "point.topleft.down.to.point.bottomright.curvepath",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Interpolated y",
                                        value: numberFormatter.format(result.interpolatedY),
                                        unit: "y unit"
                                    ),
.init(
                                        label: "Interpolation Fraction",
                                        value: numberFormatter.format(result.interpolationFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Slope",
                                        value: numberFormatter.format(result.slope),
                                        unit: "y unit/x unit"
                                    ),
.init(
                                        label: "Extrapolation",
                                        value: result.isExtrapolation ? "Yes" : "No",
                                        unit: "—"
                                    ),
.init(
                                        label: "Assessment",
                                        value: result.rangeDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
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
        .navigationTitle("Linear Interpolation")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    x1:
                        try InputValidator.parseNumber(
                            x1Input,
                            fieldName: "known x1"
                        ),
                    y1:
                        try InputValidator.parseNumber(
                            y1Input,
                            fieldName: "known y1"
                        ),
                    x2:
                        try InputValidator.parseNumber(
                            x2Input,
                            fieldName: "known x2"
                        ),
                    y2:
                        try InputValidator.parseNumber(
                            y2Input,
                            fieldName: "known y2"
                        ),
                    targetX:
                        try InputValidator.parseNumber(
                            targetInput,
                            fieldName: "target x"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        x1Input = "10"
        y1Input = "100"
        x2Input = "20"
        y2Input = "180"
        targetInput = "15"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        x1Input = ""
        y1Input = ""
        x2Input = ""
        y2Input = ""
        targetInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        LinearInterpolationCalculatorView()
    }
}
