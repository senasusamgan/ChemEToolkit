import SwiftUI

struct EquilibriumConversionView:
    View {

    @State private var initialAInput = "1"
    @State private var initialBInput = "0"
    @State private var equilibriumConstantInput = "4"

    @State private var result:
        EquilibriumConversionResult?

    @State private var errorMessage = ""

    private let engine =
        EquilibriumConversionEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName:
                        "equal.circle.fill",
                    title:
                        "Equilibrium Conversion",
                    subtitle:
                        "Determine equilibrium composition and reaction direction for A ⇌ B",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("1:1 Concentration Equilibrium")
                            .font(.headline)

                        Text("K_c = C_B,eq / C_A,eq")
                            .font(
                                .system(
                                    size: 19,
                                    weight: .semibold
                                )
                            )

                        Text(
                            "The signed extent is positive for net A → B and negative for net B → A."
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
                            title:
                                "Initial Concentration A",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 1",
                            text: $initialAInput
                        )

                        EngineeringInputField(
                            title:
                                "Initial Concentration B",
                            symbol: "C_B0",
                            unit: "mol/m³",
                            placeholder: "Example: 0",
                            text: $initialBInput
                        )

                        EngineeringInputField(
                            title:
                                "Equilibrium Constant",
                            symbol: "K_c",
                            unit: "—",
                            placeholder: "Example: 4",
                            text:
                                $equilibriumConstantInput
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
                                "Calculate Equilibrium",
                            systemImage:
                                "equal.circle.fill",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label:
                                                "Equilibrium Concentration A",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equilibriumConcentrationA
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Equilibrium Concentration B",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .equilibriumConcentrationB
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Signed Extent",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .signedExtentConcentration
                                                ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label:
                                                "Signed Extent Fraction",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .signedExtentFractionOfTotal
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Forward Conversion of Initial A",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .forwardConversionOfInitialA
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Reverse Conversion of Initial B",
                                            value:
                                                numberFormatter.format(
                                                    100
                                                    * result
                                                        .reverseConversionOfInitialB
                                                ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label:
                                                "Initial Reaction Quotient",
                                            value:
                                                numberFormatter.format(
                                                    result
                                                        .initialReactionQuotient
                                                ),
                                            unit: "—"
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
                                            result
                                                .directionDescription
                                        )
                                        .font(.headline)

                                        Divider()

                                        Text(result.modelName)

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
        .navigationTitle("Equilibrium Conversion")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    initialConcentrationA:
                        try InputValidator.parseNumber(
                            initialAInput,
                            fieldName:
                                "initial concentration A"
                        ),
                    initialConcentrationB:
                        try InputValidator.parseNumber(
                            initialBInput,
                            fieldName:
                                "initial concentration B"
                        ),
                    equilibriumConstant:
                        try InputValidator.parseNumber(
                            equilibriumConstantInput,
                            fieldName:
                                "equilibrium constant"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        initialAInput = "1"
        initialBInput = "0"
        equilibriumConstantInput = "4"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        initialAInput = ""
        initialBInput = ""
        equilibriumConstantInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        EquilibriumConversionView()
    }
}
