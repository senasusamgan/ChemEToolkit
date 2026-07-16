import SwiftUI

struct RatioControlView:
    View {

    @State private var wildFlowInput = "100"
    @State private var ratioInput = "0.25"
    @State private var trimInput = "2"
    @State private var minimumInput = "0"
    @State private var maximumInput = "50"
    @State private var measuredInput = "24"

    @State private var result:
        RatioControlResult?

    @State private var errorMessage = ""

    private let engine =
        RatioControlEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "divide.circle.fill",
                    title: "Ratio Control",
                    subtitle: "Calculate a controlled-stream flow setpoint from a measured wild stream",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Ratio control keeps two compatible material streams in a selected proportion as the wild stream changes.")
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
                            title: "Wild-Stream Flow",
                            symbol: "F_w",
                            unit: "flow units",
                            placeholder: "100",
                            text: $wildFlowInput
                        )

                        EngineeringInputField(
                            title: "Desired Flow Ratio",
                            symbol: "R",
                            unit: "controlled/wild",
                            placeholder: "0.25",
                            text: $ratioInput
                        )

                        EngineeringInputField(
                            title: "Trim Bias",
                            symbol: "b",
                            unit: "flow units",
                            placeholder: "2",
                            text: $trimInput
                        )

                        EngineeringInputField(
                            title: "Minimum Controlled Flow",
                            symbol: "F_min",
                            unit: "flow units",
                            placeholder: "0",
                            text: $minimumInput
                        )

                        EngineeringInputField(
                            title: "Maximum Controlled Flow",
                            symbol: "F_max",
                            unit: "flow units",
                            placeholder: "50",
                            text: $maximumInput
                        )

                        EngineeringInputField(
                            title: "Measured Controlled Flow",
                            symbol: "F_c",
                            unit: "flow units",
                            placeholder: "24",
                            text: $measuredInput
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
                            systemImage: "divide.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Ideal Controlled Setpoint",
                                        value: numberFormatter.format(result.idealControlledFlowSetpoint),
                                        unit: "flow units"
                                    ),
.init(
                                        label: "Applied Controlled Setpoint",
                                        value: numberFormatter.format(result.appliedControlledFlowSetpoint),
                                        unit: "flow units"
                                    ),
.init(
                                        label: "Measured Flow Ratio",
                                        value: result.measuredFlowRatio.map { numberFormatter.format($0) } ?? "Undefined at zero wild flow",
                                        unit: "—"
                                    ),
.init(
                                        label: "Ratio Error",
                                        value: result.ratioError.map { numberFormatter.format($0) } ?? "Undefined",
                                        unit: "—"
                                    ),
.init(
                                        label: "Controlled-Flow Error",
                                        value: numberFormatter.format(result.controlledFlowError),
                                        unit: "flow units"
                                    ),
.init(
                                        label: "Setpoint Limited",
                                        value: result.setpointWasLimited ? "Yes" : "No",
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
        .navigationTitle("Ratio Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    wildStreamFlow:
                        try InputValidator.parseNumber(
                            wildFlowInput,
                            fieldName:
                                "wild-stream flow"
                        ),
                    desiredFlowRatio:
                        try InputValidator.parseNumber(
                            ratioInput,
                            fieldName:
                                "desired flow ratio"
                        ),
                    trimBias:
                        try InputValidator.parseNumber(
                            trimInput,
                            fieldName:
                                "trim bias"
                        ),
                    minimumControlledFlow:
                        try InputValidator.parseNumber(
                            minimumInput,
                            fieldName:
                                "minimum controlled flow"
                        ),
                    maximumControlledFlow:
                        try InputValidator.parseNumber(
                            maximumInput,
                            fieldName:
                                "maximum controlled flow"
                        ),
                    measuredControlledFlow:
                        try InputValidator.parseNumber(
                            measuredInput,
                            fieldName:
                                "measured controlled flow"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        wildFlowInput = "100"
        ratioInput = "0.25"
        trimInput = "2"
        minimumInput = "0"
        maximumInput = "50"
        measuredInput = "24"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        wildFlowInput = ""
        ratioInput = ""
        trimInput = ""
        minimumInput = ""
        maximumInput = ""
        measuredInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        RatioControlView()
    }
}
