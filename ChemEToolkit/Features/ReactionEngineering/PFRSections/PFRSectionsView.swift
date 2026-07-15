import SwiftUI

struct PFRSectionsView: View {
    @State private var concentrationInput = "10"
    @State private var flowInput = "0.002"
    @State private var v1Input = "1"
    @State private var k1Input = "0.001"
    @State private var v2Input = "1.5"
    @State private var k2Input = "0.002"
    @State private var v3Input = "2"
    @State private var k3Input = "0.003"

    @State private var result: PFRSectionsResult?
    @State private var errorMessage = ""

    private let engine = PFRSectionsEngine()
    private let numberFormatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "arrow.right.to.line.compact",
                    title: "PFR Sections",
                    subtitle: "Calculate serial PFR zones with different first-order kinetics",
                    tint: .orange
                )

                CalculatorInfoCard(tint: .orange) {
                    VStack(spacing: AppSpacing.small) {
                        Text("C_out = C_in exp(−Σkᵢτᵢ)")
                            .font(.headline)

                        Text("Sections can represent different temperatures, catalysts or operating zones.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(
                        alignment: .leading,
                        spacing: AppSpacing.large
                    ) {
                        EngineeringInputField(
                            title: "Inlet Concentration",
                            symbol: "C_A0",
                            unit: "mol/m³",
                            placeholder: "Example: 10",
                            text: $concentrationInput
                        )

                        EngineeringInputField(
                            title: "Volumetric Flow Rate",
                            symbol: "v₀",
                            unit: "m³/s",
                            placeholder: "Example: 0.002",
                            text: $flowInput
                        )

                        EngineeringInputField(
                            title: "Section 1 Volume",
                            symbol: "V₁",
                            unit: "m³",
                            placeholder: "Example: 1",
                            text: $v1Input
                        )

                        EngineeringInputField(
                            title: "Section 1 Rate Constant",
                            symbol: "k₁",
                            unit: "1/s",
                            placeholder: "Example: 0.001",
                            text: $k1Input
                        )

                        EngineeringInputField(
                            title: "Section 2 Volume",
                            symbol: "V₂",
                            unit: "m³",
                            placeholder: "Example: 1.5",
                            text: $v2Input
                        )

                        EngineeringInputField(
                            title: "Section 2 Rate Constant",
                            symbol: "k₂",
                            unit: "1/s",
                            placeholder: "Example: 0.002",
                            text: $k2Input
                        )

                        EngineeringInputField(
                            title: "Section 3 Volume",
                            symbol: "V₃",
                            unit: "m³",
                            placeholder: "Example: 2",
                            text: $v3Input
                        )

                        EngineeringInputField(
                            title: "Section 3 Rate Constant",
                            symbol: "k₃",
                            unit: "1/s",
                            placeholder: "Example: 0.003",
                            text: $k3Input
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
                            systemImage: "arrow.right.to.line.compact",
                            action: calculate
                        )

                        if let result {
                            VStack(spacing: AppSpacing.large) {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                            label: "Outlet after Section 1",
                                            value: numberFormatter.format(
                                                result.outletConcentrationSectionOne
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Outlet after Section 2",
                                            value: numberFormatter.format(
                                                result.outletConcentrationSectionTwo
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Final Outlet",
                                            value: numberFormatter.format(
                                                result.outletConcentrationSectionThree
                                            ),
                                            unit: "mol/m³"
                                        ),
                                        .init(
                                            label: "Overall Conversion",
                                            value: numberFormatter.format(
                                                100 * result.overallConversion
                                            ),
                                            unit: "%"
                                        ),
                                        .init(
                                            label: "Total Space Time",
                                            value: numberFormatter.format(
                                                result.totalSpaceTime
                                            ),
                                            unit: "s"
                                        ),
                                        .init(
                                            label: "Weighted Rate Constant",
                                            value: numberFormatter.format(
                                                result.residenceTimeWeightedRateConstant
                                            ),
                                            unit: "1/s"
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

                                        Text(result.limitationDescription)
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
        .navigationTitle("PFR Sections")
    }

    private func calculate() {
        result = nil
        errorMessage = ""

        do {
            result = try engine.calculate(
                .init(
                    inletConcentration:
                        try InputValidator.parseNumber(
                            concentrationInput,
                            fieldName: "inlet concentration"
                        ),
                    volumetricFlowRate:
                        try InputValidator.parseNumber(
                            flowInput,
                            fieldName: "volumetric flow rate"
                        ),
                    sectionOneVolume:
                        try InputValidator.parseNumber(
                            v1Input,
                            fieldName: "section 1 volume"
                        ),
                    sectionOneRateConstant:
                        try InputValidator.parseNumber(
                            k1Input,
                            fieldName: "section 1 rate constant"
                        ),
                    sectionTwoVolume:
                        try InputValidator.parseNumber(
                            v2Input,
                            fieldName: "section 2 volume"
                        ),
                    sectionTwoRateConstant:
                        try InputValidator.parseNumber(
                            k2Input,
                            fieldName: "section 2 rate constant"
                        ),
                    sectionThreeVolume:
                        try InputValidator.parseNumber(
                            v3Input,
                            fieldName: "section 3 volume"
                        ),
                    sectionThreeRateConstant:
                        try InputValidator.parseNumber(
                            k3Input,
                            fieldName: "section 3 rate constant"
                        )
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        concentrationInput = "10"
        flowInput = "0.002"
        v1Input = "1"
        k1Input = "0.001"
        v2Input = "1.5"
        k2Input = "0.002"
        v3Input = "2"
        k3Input = "0.003"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        concentrationInput = ""
        flowInput = ""
        v1Input = ""
        k1Input = ""
        v2Input = ""
        k2Input = ""
        v3Input = ""
        k3Input = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack {
        PFRSectionsView()
    }
}
