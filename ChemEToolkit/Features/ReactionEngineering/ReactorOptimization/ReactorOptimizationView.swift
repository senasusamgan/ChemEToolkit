import SwiftUI

struct ReactorOptimizationView:
    View {

    @State private var concentrationInput = "1"
    @State private var flowInput = "0.01"
    @State private var firstInput = "0.5"
    @State private var secondInput = "0.2"
    @State private var result:
        ReactorOptimizationResult?

    @State private var errorMessage = ""

    private let engine =
        ReactorOptimizationEngine()

    private let formatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "target",
                    title: "Reactor Optimization",
                    subtitle: "Compare optimum PFR and CSTR operation for maximum intermediate yield",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    Text("For A → B → C, the module finds the PFR and CSTR residence times that maximize desired intermediate B.")
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
                            title: "Inlet Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "1",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "Q",
                            unit: "m³/time",
                            placeholder: "0.01",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant A → B",
                            symbol: "k₁",
                            unit: "1/time",
                            placeholder: "0.5",
                            text: $firstInput
                        )

                        EngineeringInputField(
                            title: "Rate Constant B → C",
                            symbol: "k₂",
                            unit: "1/time",
                            placeholder: "0.2",
                            text: $secondInput
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
                            title: "Calculate",
                            systemImage: "target",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Optimum PFR Volume",
                                        value: formatter.format(result.optimumPFRVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "Maximum PFR Yield B",
                                        value: formatter.format(100 * result.maximumPFRYieldB),
                                        unit: "%"
                                    ),
.init(
                                        label: "Optimum CSTR Volume",
                                        value: formatter.format(result.optimumCSTRVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "Maximum CSTR Yield B",
                                        value: formatter.format(100 * result.maximumCSTRYieldB),
                                        unit: "%"
                                    ),
.init(
                                        label: "Recommended Reactor",
                                        value: result.recommendedReactor,
                                        unit: "—"
                                    ),
.init(
                                        label: "Yield Advantage",
                                        value: formatter.format(100 * result.yieldAdvantage),
                                        unit: "percentage points"
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
        .navigationTitle("Reactor Optimization")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentrationA: try InputValidator.parseNumber(concentrationInput, fieldName: "inlet concentration A"),
                    volumetricFlowRate: try InputValidator.parseNumber(flowInput, fieldName: "volumetric flow rate"),
                    firstRateConstant: try InputValidator.parseNumber(firstInput, fieldName: "first rate constant"),
                    secondRateConstant: try InputValidator.parseNumber(secondInput, fieldName: "second rate constant")
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "1"
        flowInput = "0.01"
        firstInput = "0.5"
        secondInput = "0.2"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        firstInput = ""
        secondInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        ReactorOptimizationView()
    }
}
