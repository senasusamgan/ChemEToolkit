import SwiftUI

struct MixtureDensityCalculatorView:
    View {

    @State private var mass1Input = "50"
    @State private var density1Input = "1000"
    @State private var mass2Input = "30"
    @State private var density2Input = "800"
    @State private var mass3Input = "20"
    @State private var density3Input = "1200"

    @State private var result:
        MixtureDensityCalculatorResult?

    @State private var errorMessage = ""

    private let engine =
        MixtureDensityCalculatorEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "drop.fill",
                    title: "Mixture Density",
                    subtitle: "Estimate density from component masses and densities",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    Text("The module assumes additive component volumes.")
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
                            title: "Component 1 Mass",
                            symbol: "m₁",
                            unit: "kg",
                            placeholder: "50",
                            text: $mass1Input
                        )

                        EngineeringInputField(
                            title: "Component 1 Density",
                            symbol: "ρ₁",
                            unit: "kg/m³",
                            placeholder: "1000",
                            text: $density1Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Mass",
                            symbol: "m₂",
                            unit: "kg",
                            placeholder: "30",
                            text: $mass2Input
                        )

                        EngineeringInputField(
                            title: "Component 2 Density",
                            symbol: "ρ₂",
                            unit: "kg/m³",
                            placeholder: "800",
                            text: $density2Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Mass",
                            symbol: "m₃",
                            unit: "kg",
                            placeholder: "20",
                            text: $mass3Input
                        )

                        EngineeringInputField(
                            title: "Component 3 Density",
                            symbol: "ρ₃",
                            unit: "kg/m³",
                            placeholder: "1200",
                            text: $density3Input
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
                            systemImage: "drop.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Total Mass",
                                        value: numberFormatter.format(result.totalMass),
                                        unit: "kg"
                                    ),
.init(
                                        label: "Total Additive Volume",
                                        value: numberFormatter.format(result.totalAdditiveVolume),
                                        unit: "m³"
                                    ),
.init(
                                        label: "Mixture Density",
                                        value: numberFormatter.format(result.mixtureDensity),
                                        unit: "kg/m³"
                                    ),
.init(
                                        label: "Mass Fraction 1",
                                        value: numberFormatter.format(result.massFraction1),
                                        unit: "—"
                                    ),
.init(
                                        label: "Mass Fraction 2",
                                        value: numberFormatter.format(result.massFraction2),
                                        unit: "—"
                                    ),
.init(
                                        label: "Mass Fraction 3",
                                        value: numberFormatter.format(result.massFraction3),
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
        .navigationTitle("Mixture Density")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    mass1:
                        try InputValidator.parseNumber(
                            mass1Input,
                            fieldName:
                                "component 1 mass"
                        ),
                    density1:
                        try InputValidator.parseNumber(
                            density1Input,
                            fieldName:
                                "component 1 density"
                        ),
                    mass2:
                        try InputValidator.parseNumber(
                            mass2Input,
                            fieldName:
                                "component 2 mass"
                        ),
                    density2:
                        try InputValidator.parseNumber(
                            density2Input,
                            fieldName:
                                "component 2 density"
                        ),
                    mass3:
                        try InputValidator.parseNumber(
                            mass3Input,
                            fieldName:
                                "component 3 mass"
                        ),
                    density3:
                        try InputValidator.parseNumber(
                            density3Input,
                            fieldName:
                                "component 3 density"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        mass1Input = "50"
        density1Input = "1000"
        mass2Input = "30"
        density2Input = "800"
        mass3Input = "20"
        density3Input = "1200"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        mass1Input = ""
        density1Input = ""
        mass2Input = ""
        density2Input = ""
        mass3Input = ""
        density3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        MixtureDensityCalculatorView()
    }
}
