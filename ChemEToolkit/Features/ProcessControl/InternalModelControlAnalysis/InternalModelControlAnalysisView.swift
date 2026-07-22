import SwiftUI

struct InternalModelControlAnalysisView:
    View {

    @State private var actualGainInput = "2"
    @State private var actualTimeInput = "10"
    @State private var modelGainInput = "1.9"
    @State private var modelTimeInput = "9.5"
    @State private var deadTimeInput = "2"
    @State private var filterInput = "4"
    @State private var frequencyInput = "0.1"

    @State private var result:
        InternalModelControlAnalysisResult?

    @State private var errorMessage = ""

    private let engine =
        InternalModelControlAnalysisEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "gearshape.2.fill",
                    title: "Internal Model Control",
                    subtitle: "Analyze the IMC filter, inverse-model controller and model mismatch",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("A larger IMC filter time constant produces a slower but more robust controller.")
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
                            title: "Actual Process Gain",
                            symbol: "K",
                            unit: "output/input",
                            placeholder: "2",
                            text: $actualGainInput
                        )

                        EngineeringInputField(
                            title: "Actual Time Constant",
                            symbol: "τ",
                            unit: "time",
                            placeholder: "10",
                            text: $actualTimeInput
                        )

                        EngineeringInputField(
                            title: "Model Process Gain",
                            symbol: "K̂",
                            unit: "output/input",
                            placeholder: "1.9",
                            text: $modelGainInput
                        )

                        EngineeringInputField(
                            title: "Model Time Constant",
                            symbol: "τ̂",
                            unit: "time",
                            placeholder: "9.5",
                            text: $modelTimeInput
                        )

                        EngineeringInputField(
                            title: "Model Dead Time",
                            symbol: "θ̂",
                            unit: "time",
                            placeholder: "2",
                            text: $deadTimeInput
                        )

                        EngineeringInputField(
                            title: "IMC Filter Time Constant",
                            symbol: "λ",
                            unit: "time",
                            placeholder: "4",
                            text: $filterInput
                        )

                        EngineeringInputField(
                            title: "Angular Frequency",
                            symbol: "ω",
                            unit: "rad/time",
                            placeholder: "0.1",
                            text: $frequencyInput
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
                            systemImage: "gearshape.2.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Equivalent PI Gain",
                                        value: numberFormatter.format(result.equivalentPIControllerGain),
                                        unit: "controller gain"
                                    ),
.init(
                                        label: "Equivalent PI Integral Time",
                                        value: numberFormatter.format(result.equivalentPIIntegralTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "IMC Controller Magnitude",
                                        value: numberFormatter.format(result.imcControllerMagnitude),
                                        unit: "—"
                                    ),
.init(
                                        label: "IMC Controller Phase",
                                        value: numberFormatter.format(result.imcControllerPhaseDegrees),
                                        unit: "degrees"
                                    ),
.init(
                                        label: "Nominal Closed-Loop Magnitude",
                                        value: numberFormatter.format(result.nominalClosedLoopMagnitude),
                                        unit: "—"
                                    ),
.init(
                                        label: "Largest Model Mismatch",
                                        value: numberFormatter.format(100 * max(result.gainMismatchFraction, result.timeConstantMismatchFraction)),
                                        unit: "%"
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
        .navigationTitle("Internal Model Control")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    actualProcessGain:
                        try InputValidator.parseNumber(
                            actualGainInput,
                            fieldName:
                                "actual process gain"
                        ),
                    actualTimeConstant:
                        try InputValidator.parseNumber(
                            actualTimeInput,
                            fieldName:
                                "actual time constant"
                        ),
                    modelProcessGain:
                        try InputValidator.parseNumber(
                            modelGainInput,
                            fieldName:
                                "model process gain"
                        ),
                    modelTimeConstant:
                        try InputValidator.parseNumber(
                            modelTimeInput,
                            fieldName:
                                "model time constant"
                        ),
                    modelDeadTime:
                        try InputValidator.parseNumber(
                            deadTimeInput,
                            fieldName:
                                "model dead time"
                        ),
                    filterTimeConstant:
                        try InputValidator.parseNumber(
                            filterInput,
                            fieldName:
                                "filter time constant"
                        ),
                    angularFrequency:
                        try InputValidator.parseNumber(
                            frequencyInput,
                            fieldName:
                                "angular frequency"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        actualGainInput = "2"
        actualTimeInput = "10"
        modelGainInput = "1.9"
        modelTimeInput = "9.5"
        deadTimeInput = "2"
        filterInput = "4"
        frequencyInput = "0.1"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        actualGainInput = ""
        actualTimeInput = ""
        modelGainInput = ""
        modelTimeInput = ""
        deadTimeInput = ""
        filterInput = ""
        frequencyInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        InternalModelControlAnalysisView()
    }
}
