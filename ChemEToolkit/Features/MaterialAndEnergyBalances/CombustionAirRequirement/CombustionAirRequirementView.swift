import SwiftUI

struct CombustionAirRequirementView:
    View {

    @State private var fuelInput = "10"
    @State private var carbonInput = "1"
    @State private var hydrogenInput = "4"
    @State private var oxygenInput = "0"
    @State private var excessInput = "0.20"
    @State private var airOxygenInput = "0.21"

    @State private var result:
        CombustionAirRequirementResult?

    @State private var errorMessage = ""

    private let engine =
        CombustionAirRequirementEngine()

    private let numberFormatter =
        NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "flame.circle.fill",
                    title: "Combustion Air Requirement",
                    subtitle: "Calculate theoretical and excess-air combustion flows",
                    tint: .teal
                )

                CalculatorInfoCard(tint: .teal) {
                    Text("Enter the C, H and O atom counts of a CHO fuel and the selected excess-air fraction.")
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
                            title: "Fuel Molar Flow",
                            symbol: "F_fuel",
                            unit: "kmol/h",
                            placeholder: "10",
                            text: $fuelInput
                        )

                        EngineeringInputField(
                            title: "Carbon Atoms",
                            symbol: "C",
                            unit: "atoms/molecule",
                            placeholder: "1",
                            text: $carbonInput
                        )

                        EngineeringInputField(
                            title: "Hydrogen Atoms",
                            symbol: "H",
                            unit: "atoms/molecule",
                            placeholder: "4",
                            text: $hydrogenInput
                        )

                        EngineeringInputField(
                            title: "Oxygen Atoms",
                            symbol: "O",
                            unit: "atoms/molecule",
                            placeholder: "0",
                            text: $oxygenInput
                        )

                        EngineeringInputField(
                            title: "Excess Air Fraction",
                            symbol: "EA",
                            unit: "—",
                            placeholder: "0.20",
                            text: $excessInput
                        )

                        EngineeringInputField(
                            title: "Oxygen Fraction in Air",
                            symbol: "y_O2",
                            unit: "—",
                            placeholder: "0.21",
                            text: $airOxygenInput
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
                            systemImage: "flame.circle.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(
                                        label: "Stoichiometric Oxygen",
                                        value: numberFormatter.format(result.stoichiometricOxygenFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Actual Air",
                                        value: numberFormatter.format(result.actualAirFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Nitrogen",
                                        value: numberFormatter.format(result.nitrogenFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Carbon Dioxide",
                                        value: numberFormatter.format(result.carbonDioxideFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Water Vapor",
                                        value: numberFormatter.format(result.waterVaporFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Excess Oxygen",
                                        value: numberFormatter.format(result.excessOxygenFlow),
                                        unit: "kmol/h"
                                    ),
.init(
                                        label: "Dry Flue Gas",
                                        value: numberFormatter.format(result.dryFlueGasFlow),
                                        unit: "kmol/h"
                                    )
                                ],
                                tint: .teal
                            )

                            CalculatorInfoCard(tint: .teal) {
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
        .navigationTitle("Combustion Air Requirement")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    fuelMolarFlow:
                        try InputValidator.parseNumber(
                            fuelInput,
                            fieldName:
                                "fuel molar flow"
                        ),
                    carbonAtomsPerMolecule:
                        try InputValidator.parseNumber(
                            carbonInput,
                            fieldName:
                                "carbon atoms"
                        ),
                    hydrogenAtomsPerMolecule:
                        try InputValidator.parseNumber(
                            hydrogenInput,
                            fieldName:
                                "hydrogen atoms"
                        ),
                    oxygenAtomsPerMolecule:
                        try InputValidator.parseNumber(
                            oxygenInput,
                            fieldName:
                                "oxygen atoms"
                        ),
                    excessAirFraction:
                        try InputValidator.parseNumber(
                            excessInput,
                            fieldName:
                                "excess air fraction"
                        ),
                    oxygenMoleFractionInAir:
                        try InputValidator.parseNumber(
                            airOxygenInput,
                            fieldName:
                                "oxygen fraction in air"
                        )
                )
            )
        } catch {
            errorMessage =
                error.localizedDescription
        }
    }

    private func loadExample() {
        fuelInput = "10"
        carbonInput = "1"
        hydrogenInput = "4"
        oxygenInput = "0"
        excessInput = "0.20"
        airOxygenInput = "0.21"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        fuelInput = ""
        carbonInput = ""
        hydrogenInput = ""
        oxygenInput = ""
        excessInput = ""
        airOxygenInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        CombustionAirRequirementView()
    }
}
