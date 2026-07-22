import SwiftUI

struct GainSchedulingView:
    View {

    @State private var operatingInput = "60"
    @State private var lowerPointInput = "20"
    @State private var upperPointInput = "100"
    @State private var lowerGainInput = "1"
    @State private var upperGainInput = "3"
    @State private var lowerIntegralInput = "10"
    @State private var upperIntegralInput = "4"
    @State private var lowerDerivativeInput = "0"
    @State private var upperDerivativeInput = "2"

    @State private var result:
        GainSchedulingResult?

    @State private var errorMessage = ""

    private let engine =
        GainSchedulingEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "slider.horizontal.3",
                    title: "Gain Scheduling",
                    subtitle: "Interpolate PID settings across an operating range",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("Gain scheduling changes controller parameters as process dynamics vary with the operating point.")
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
                            title: "Current Operating Point",
                            symbol: "x",
                            unit: "operating units",
                            placeholder: "60",
                            text: $operatingInput
                        )

                        EngineeringInputField(
                            title: "Lower Operating Point",
                            symbol: "x_L",
                            unit: "operating units",
                            placeholder: "20",
                            text: $lowerPointInput
                        )

                        EngineeringInputField(
                            title: "Upper Operating Point",
                            symbol: "x_U",
                            unit: "operating units",
                            placeholder: "100",
                            text: $upperPointInput
                        )

                        EngineeringInputField(
                            title: "Lower Controller Gain",
                            symbol: "Kc_L",
                            unit: "—",
                            placeholder: "1",
                            text: $lowerGainInput
                        )

                        EngineeringInputField(
                            title: "Upper Controller Gain",
                            symbol: "Kc_U",
                            unit: "—",
                            placeholder: "3",
                            text: $upperGainInput
                        )

                        EngineeringInputField(
                            title: "Lower Integral Time",
                            symbol: "Ti_L",
                            unit: "time",
                            placeholder: "10",
                            text: $lowerIntegralInput
                        )

                        EngineeringInputField(
                            title: "Upper Integral Time",
                            symbol: "Ti_U",
                            unit: "time",
                            placeholder: "4",
                            text: $upperIntegralInput
                        )

                        EngineeringInputField(
                            title: "Lower Derivative Time",
                            symbol: "Td_L",
                            unit: "time",
                            placeholder: "0",
                            text: $lowerDerivativeInput
                        )

                        EngineeringInputField(
                            title: "Upper Derivative Time",
                            symbol: "Td_U",
                            unit: "time",
                            placeholder: "2",
                            text: $upperDerivativeInput
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
                            systemImage: "slider.horizontal.3",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Interpolation Position",
                                        value: numberFormatter.format(100 * result.interpolationFraction),
                                        unit: "%"
                                    ),
.init(
                                        label: "Scheduled Controller Gain",
                                        value: numberFormatter.format(result.scheduledControllerGain),
                                        unit: "—"
                                    ),
.init(
                                        label: "Scheduled Integral Time",
                                        value: numberFormatter.format(result.scheduledIntegralTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "Scheduled Derivative Time",
                                        value: numberFormatter.format(result.scheduledDerivativeTime),
                                        unit: "time"
                                    ),
.init(
                                        label: "Controller-Gain Slope",
                                        value: numberFormatter.format(result.controllerGainSlope),
                                        unit: "gain/operating unit"
                                    ),
.init(
                                        label: "Schedule Region",
                                        value: result.nearestScheduleRegion,
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
        .navigationTitle("Gain Scheduling")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    operatingPoint:
                        try InputValidator.parseNumber(
                            operatingInput,
                            fieldName:
                                "current operating point"
                        ),
                    lowerOperatingPoint:
                        try InputValidator.parseNumber(
                            lowerPointInput,
                            fieldName:
                                "lower operating point"
                        ),
                    upperOperatingPoint:
                        try InputValidator.parseNumber(
                            upperPointInput,
                            fieldName:
                                "upper operating point"
                        ),
                    lowerControllerGain:
                        try InputValidator.parseNumber(
                            lowerGainInput,
                            fieldName:
                                "lower controller gain"
                        ),
                    upperControllerGain:
                        try InputValidator.parseNumber(
                            upperGainInput,
                            fieldName:
                                "upper controller gain"
                        ),
                    lowerIntegralTime:
                        try InputValidator.parseNumber(
                            lowerIntegralInput,
                            fieldName:
                                "lower integral time"
                        ),
                    upperIntegralTime:
                        try InputValidator.parseNumber(
                            upperIntegralInput,
                            fieldName:
                                "upper integral time"
                        ),
                    lowerDerivativeTime:
                        try InputValidator.parseNumber(
                            lowerDerivativeInput,
                            fieldName:
                                "lower derivative time"
                        ),
                    upperDerivativeTime:
                        try InputValidator.parseNumber(
                            upperDerivativeInput,
                            fieldName:
                                "upper derivative time"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        operatingInput = "60"
        lowerPointInput = "20"
        upperPointInput = "100"
        lowerGainInput = "1"
        upperGainInput = "3"
        lowerIntegralInput = "10"
        upperIntegralInput = "4"
        lowerDerivativeInput = "0"
        upperDerivativeInput = "2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        operatingInput = ""
        lowerPointInput = ""
        upperPointInput = ""
        lowerGainInput = ""
        upperGainInput = ""
        lowerIntegralInput = ""
        upperIntegralInput = ""
        lowerDerivativeInput = ""
        upperDerivativeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        GainSchedulingView()
    }
}
