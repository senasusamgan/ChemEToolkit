import SwiftUI

struct BinaryIsothermalFlashView:
    View {

    @State private var flowInput = "100"
    @State private var fractionInput = "0.50"
    @State private var k1Input = "2.0"
    @State private var k2Input = "0.50"

    @State private var result:
        BinaryIsothermalFlashResult?

    @State private var errorMessage = ""

    private let engine =
        BinaryIsothermalFlashEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.triangle.branch",
                    title: "Binary Isothermal Flash",
                    subtitle: "Solve vapor fraction and phase compositions",
                    tint: .purple
                )

                CalculatorInfoCard(tint: .purple) {
                    Text("K-values must correspond to the selected flash temperature and pressure.")
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
                            title: "Feed Molar Flow",
                            symbol: "F",
                            unit: "kmol/h",
                            placeholder: "100",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Feed Mole Fraction 1",
                            symbol: "z₁",
                            unit: "—",
                            placeholder: "0.50",
                            text: $fractionInput
                        )

                        EngineeringInputField(
                            title: "Equilibrium Ratio 1",
                            symbol: "K₁",
                            unit: "—",
                            placeholder: "2.0",
                            text: $k1Input
                        )

                        EngineeringInputField(
                            title: "Equilibrium Ratio 2",
                            symbol: "K₂",
                            unit: "—",
                            placeholder: "0.50",
                            text: $k2Input
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
                            systemImage: "arrow.triangle.branch",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Vapor Fraction",
                                        value: numberFormatter.format(result.vaporFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Liquid Fraction",
                                        value: numberFormatter.format(result.liquidFraction),
                                        unit: "—"
                                    ),
.init(
                                        label: "Vapor Flow",
                                        value: numberFormatter.format(result.vaporMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Liquid Flow",
                                        value: numberFormatter.format(result.liquidMolarFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Liquid Mole Fraction 1",
                                        value: numberFormatter.format(result.liquidMoleFraction1),
                                        unit: "—"
                                    ),
.init(
                                        label: "Vapor Mole Fraction 1",
                                        value: numberFormatter.format(result.vaporMoleFraction1),
                                        unit: "—"
                                    ),
.init(
                                        label: "Phase State",
                                        value: result.phaseDescription,
                                        unit: "—"
                                    )
                                ],
                                tint: .purple
                            )

                            CalculatorInfoCard(tint: .purple) {
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
        .navigationTitle("Binary Isothermal Flash")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    feedMolarFlow:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName:
                                "feed molar flow"
                        ),
                    feedMoleFraction1:
                        try InputValidator.parseNumber(
                            fractionInput,
                            fieldName:
                                "feed mole fraction 1"
                        ),
                    equilibriumRatio1:
                        try InputValidator.parseNumber(
                            k1Input,
                            fieldName:
                                "equilibrium ratio 1"
                        ),
                    equilibriumRatio2:
                        try InputValidator.parseNumber(
                            k2Input,
                            fieldName:
                                "equilibrium ratio 2"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        flowInput = "100"
        fractionInput = "0.50"
        k1Input = "2.0"
        k2Input = "0.50"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        flowInput = ""
        fractionInput = ""
        k1Input = ""
        k2Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        BinaryIsothermalFlashView()
    }
}
