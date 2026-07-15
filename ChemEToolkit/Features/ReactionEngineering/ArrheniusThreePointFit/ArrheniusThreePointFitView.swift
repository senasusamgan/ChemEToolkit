import SwiftUI

struct ArrheniusThreePointFitView:
    View {

    @State private var temperatureOneInput = "300"
    @State private var rateConstantOneInput = "0.019696844"
    @State private var temperatureTwoInput = "350"
    @State private var rateConstantTwoInput = "0.345186870"
    @State private var temperatureThreeInput = "400"
    @State private var rateConstantThreeInput = "2.956633443"

    @State private var result:
        ArrheniusThreePointFitResult?

    @State private var errorMessage = ""

    private let engine =
        ArrheniusThreePointFitEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "chart.dots.scatter",
                    title: "Three-Point Arrhenius Fit",
                    subtitle:
                        "Estimate Eₐ and A by linear regression of three kinetic points",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Arrhenius Linearization")
                            .font(.headline)

                        Text("ln(k) = ln(A) − Eₐ/(RT)")
                            .font(
                                .system(
                                    size: 19,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The tool fits ln(k) against 1/T and reports R² and residuals."
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
                        Text("Point 1")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Temperature 1",
                            symbol: "T₁",
                            unit: "K",
                            placeholder: "Example: 300",
                            text: $temperatureOneInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant 1",
                            symbol: "k₁",
                            unit: "consistent",
                            placeholder: "Example: 0.019696844",
                            text: $rateConstantOneInput
                        )

                        Divider()

                        Text("Point 2")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Temperature 2",
                            symbol: "T₂",
                            unit: "K",
                            placeholder: "Example: 350",
                            text: $temperatureTwoInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant 2",
                            symbol: "k₂",
                            unit: "consistent",
                            placeholder: "Example: 0.345186870",
                            text: $rateConstantTwoInput
                        )

                        Divider()

                        Text("Point 3")
                            .font(.headline)

                        EngineeringInputField(
                            title: "Temperature 3",
                            symbol: "T₃",
                            unit: "K",
                            placeholder: "Example: 400",
                            text: $temperatureThreeInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant 3",
                            symbol: "k₃",
                            unit: "consistent",
                            placeholder: "Example: 2.956633443",
                            text: $rateConstantThreeInput
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
                            title: "Fit Arrhenius Parameters",
                            systemImage:
                                "chart.dots.scatter",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Activation Energy",
                                            value: numberFormatter.format(
                                                result.activationEnergyKilojoulesPerMole
                                            ),
                                            unit: "kJ/mol"
                                        ),
                                        .init(
                                            label: "Pre-Exponential Factor",
                                            value: numberFormatter.format(
                                                result.preExponentialFactor
                                            ),
                                            unit: "same units as k"
                                        ),
                                        .init(
                                            label: "Arrhenius Slope",
                                            value: numberFormatter.format(
                                                result.slope
                                            ),
                                            unit: "K"
                                        ),
                                        .init(
                                            label: "Arrhenius Intercept",
                                            value: numberFormatter.format(
                                                result.intercept
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "R²",
                                            value: numberFormatter.format(
                                                result.coefficientOfDetermination
                                            ),
                                            unit: "—"
                                        ),
                                        .init(
                                            label: "Maximum Relative Residual",
                                            value: numberFormatter.format(
                                                100
                                                * result.maximumRelativeResidual
                                            ),
                                            unit: "%"
                                        )
                                    ],
                                    tint: .orange
                                )

                                CalculatorInfoCard(tint: .orange) {
                                    VStack(
                                        alignment: .leading,
                                        spacing: AppSpacing.small
                                    ) {
                                        Text(
                                            result.fitQualityDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)
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
                AppTheme.Layout.pageHorizontalPadding
            )
            .padding(
                .vertical,
                AppTheme.Layout.pageVerticalPadding
            )
        }
        .navigationTitle("Arrhenius Fit")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    temperatureOne:
                        try InputValidator.parseNumber(
                            temperatureOneInput,
                            fieldName: "temperature one"
                        ),
                    rateConstantOne:
                        try InputValidator.parseNumber(
                            rateConstantOneInput,
                            fieldName: "rate constant one"
                        ),
                    temperatureTwo:
                        try InputValidator.parseNumber(
                            temperatureTwoInput,
                            fieldName: "temperature two"
                        ),
                    rateConstantTwo:
                        try InputValidator.parseNumber(
                            rateConstantTwoInput,
                            fieldName: "rate constant two"
                        ),
                    temperatureThree:
                        try InputValidator.parseNumber(
                            temperatureThreeInput,
                            fieldName: "temperature three"
                        ),
                    rateConstantThree:
                        try InputValidator.parseNumber(
                            rateConstantThreeInput,
                            fieldName: "rate constant three"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        temperatureOneInput = "300"
        rateConstantOneInput = "0.019696844"
        temperatureTwoInput = "350"
        rateConstantTwoInput = "0.345186870"
        temperatureThreeInput = "400"
        rateConstantThreeInput = "2.956633443"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        temperatureOneInput = ""
        rateConstantOneInput = ""
        temperatureTwoInput = ""
        rateConstantTwoInput = ""
        temperatureThreeInput = ""
        rateConstantThreeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ArrheniusThreePointFitView()
    }
}
