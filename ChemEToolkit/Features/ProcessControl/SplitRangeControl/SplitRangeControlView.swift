import SwiftUI

struct SplitRangeControlView:
    View {

    @State private var controllerOutputInput = "70"
    @State private var minimumInput = "0"
    @State private var splitInput = "50"
    @State private var maximumInput = "100"
    @State private var firstMinimumInput = "0"
    @State private var firstMaximumInput = "100"
    @State private var secondMinimumInput = "0"
    @State private var secondMaximumInput = "100"

    @State private var result:
        SplitRangeControlResult?

    @State private var errorMessage = ""

    private let engine =
        SplitRangeControlEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.swap",
                    title: "Split-Range Control",
                    subtitle: "Map one controller output across two sequential actuators",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Split-range control coordinates two manipulated devices when one actuator cannot cover the full operating range.")
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
                            title: "Controller Output",
                            symbol: "u",
                            unit: "%",
                            placeholder: "70",
                            text: $controllerOutputInput
                        )

                        EngineeringInputField(
                            title: "Minimum Controller Output",
                            symbol: "u_min",
                            unit: "%",
                            placeholder: "0",
                            text: $minimumInput
                        )

                        EngineeringInputField(
                            title: "Split Point",
                            symbol: "u_split",
                            unit: "%",
                            placeholder: "50",
                            text: $splitInput
                        )

                        EngineeringInputField(
                            title: "Maximum Controller Output",
                            symbol: "u_max",
                            unit: "%",
                            placeholder: "100",
                            text: $maximumInput
                        )

                        EngineeringInputField(
                            title: "First Actuator Minimum",
                            symbol: "a₁,min",
                            unit: "%",
                            placeholder: "0",
                            text: $firstMinimumInput
                        )

                        EngineeringInputField(
                            title: "First Actuator Maximum",
                            symbol: "a₁,max",
                            unit: "%",
                            placeholder: "100",
                            text: $firstMaximumInput
                        )

                        EngineeringInputField(
                            title: "Second Actuator Minimum",
                            symbol: "a₂,min",
                            unit: "%",
                            placeholder: "0",
                            text: $secondMinimumInput
                        )

                        EngineeringInputField(
                            title: "Second Actuator Maximum",
                            symbol: "a₂,max",
                            unit: "%",
                            placeholder: "100",
                            text: $secondMaximumInput
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
                            systemImage: "arrow.triangle.swap",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Constrained Controller Output",
                                        value: numberFormatter.format(result.constrainedControllerOutput),
                                        unit: "%"
                                    ),
.init(
                                        label: "First Actuator Opening",
                                        value: numberFormatter.format(100 * result.firstActuatorOpeningFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Second Actuator Opening",
                                        value: numberFormatter.format(100 * result.secondActuatorOpeningFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "First Actuator Signal",
                                        value: numberFormatter.format(result.firstActuatorSignal),
                                        unit: "%"
                                    ),
.init(
                                        label: "Second Actuator Signal",
                                        value: numberFormatter.format(result.secondActuatorSignal),
                                        unit: "%"
                                    ),
.init(
                                        label: "Active Range",
                                        value: result.activeRangeDescription,
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
        .navigationTitle("Split-Range Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    controllerOutput:
                        try InputValidator.parseNumber(
                            controllerOutputInput,
                            fieldName:
                                "controller output"
                        ),
                    minimumControllerOutput:
                        try InputValidator.parseNumber(
                            minimumInput,
                            fieldName:
                                "minimum controller output"
                        ),
                    splitPoint:
                        try InputValidator.parseNumber(
                            splitInput,
                            fieldName:
                                "split point"
                        ),
                    maximumControllerOutput:
                        try InputValidator.parseNumber(
                            maximumInput,
                            fieldName:
                                "maximum controller output"
                        ),
                    firstActuatorMinimum:
                        try InputValidator.parseNumber(
                            firstMinimumInput,
                            fieldName:
                                "first actuator minimum"
                        ),
                    firstActuatorMaximum:
                        try InputValidator.parseNumber(
                            firstMaximumInput,
                            fieldName:
                                "first actuator maximum"
                        ),
                    secondActuatorMinimum:
                        try InputValidator.parseNumber(
                            secondMinimumInput,
                            fieldName:
                                "second actuator minimum"
                        ),
                    secondActuatorMaximum:
                        try InputValidator.parseNumber(
                            secondMaximumInput,
                            fieldName:
                                "second actuator maximum"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        controllerOutputInput = "70"
        minimumInput = "0"
        splitInput = "50"
        maximumInput = "100"
        firstMinimumInput = "0"
        firstMaximumInput = "100"
        secondMinimumInput = "0"
        secondMaximumInput = "100"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        controllerOutputInput = ""
        minimumInput = ""
        splitInput = ""
        maximumInput = ""
        firstMinimumInput = ""
        firstMaximumInput = ""
        secondMinimumInput = ""
        secondMaximumInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        SplitRangeControlView()
    }
}
