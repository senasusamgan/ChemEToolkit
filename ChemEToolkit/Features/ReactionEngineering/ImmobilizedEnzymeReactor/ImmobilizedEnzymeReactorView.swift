import SwiftUI

struct ImmobilizedEnzymeReactorView: View {
    @State private var radiusInput = "0.001"
    @State private var diffusivityInput = "1e-9"
    @State private var maximumRateInput = "0.01"
    @State private var michaelisInput = "10"
    @State private var substrateInput = "2"
    @State private var pelletVolumeInput = "0.5"
    @State private var result: ImmobilizedEnzymeReactorResult?
    @State private var errorMessage = ""

    private let engine = ImmobilizedEnzymeReactorEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "circle.hexagongrid.fill",
                    title: "Immobilized Enzyme Reactor",
                    subtitle: "Estimate spherical-pellet effectiveness and diffusion loss",
                    tint: .orange
                )

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                            title: "Pellet Radius",
                            symbol: "R",
                            unit: "m",
                            placeholder: "0.001",
                            text: $radiusInput
                        )

                        EngineeringInputField(
                            title: "Effective Diffusivity",
                            symbol: "D_e",
                            unit: "m²/s",
                            placeholder: "1e-9",
                            text: $diffusivityInput
                        )

                        EngineeringInputField(
                            title: "Maximum Volumetric Rate",
                            symbol: "V_max",
                            unit: "mol/(m³·s)",
                            placeholder: "0.01",
                            text: $maximumRateInput
                        )

                        EngineeringInputField(
                            title: "Michaelis Constant",
                            symbol: "K_m",
                            unit: "mol/m³",
                            placeholder: "10",
                            text: $michaelisInput
                        )

                        EngineeringInputField(
                            title: "Bulk Substrate",
                            symbol: "S_b",
                            unit: "mol/m³",
                            placeholder: "2",
                            text: $substrateInput
                        )

                        EngineeringInputField(
                            title: "Total Pellet Volume",
                            symbol: "V_p",
                            unit: "m³",
                            placeholder: "0.5",
                            text: $pelletVolumeInput
                        )

                        HStack(spacing: AppSpacing.medium) {
                            Button(action: loadExample) {
                                Label("Load Example", systemImage: "arrow.counterclockwise")
                            }
                            Spacer()
                            Button(role: .destructive, action: resetInputs) {
                                Label("Clear", systemImage: "trash")
                            }
                        }
                        .buttonStyle(.bordered)

                        PrimaryActionButton(
                            title: "Calculate",
                            systemImage: "circle.hexagongrid.fill",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Thiele Modulus", value: formatter.format(result.thieleModulus), unit: "—"),
.init(label: "Effectiveness Factor", value: formatter.format(result.effectivenessFactor), unit: "—"),
.init(label: "Diffusion Loss", value: formatter.format(100 * result.internalDiffusionLossFraction), unit: "%"),
.init(label: "Intrinsic Rate", value: formatter.format(result.intrinsicVolumetricRate), unit: "mol/(m³·s)"),
.init(label: "Observed Rate", value: formatter.format(result.observedVolumetricRate), unit: "mol/(m³·s)"),
.init(label: "Total Molar Rate", value: formatter.format(result.totalObservedMolarRate), unit: "mol/s")
                                ],
                                tint: .orange
                            )

                            CalculatorInfoCard(tint: .orange) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Text(result.modelName).font(.headline)
                                    Divider()
                                    Text(result.limitationDescription)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                        if !errorMessage.isEmpty {
                            CalculationErrorCard(message: errorMessage)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Layout.pageHorizontalPadding)
            .padding(.vertical, AppTheme.Layout.pageVerticalPadding)
        }
        .navigationTitle("Immobilized Enzyme Reactor")
    }

    private func calculate() {
        result = nil
        errorMessage = ""
        do {
            result = try engine.calculate(
                .init(
                    sphericalPelletRadius: try InputValidator.parseNumber(radiusInput, fieldName: "pellet radius"),
                    effectiveDiffusivity: try InputValidator.parseNumber(diffusivityInput, fieldName: "effective diffusivity"),
                    maximumVolumetricRate: try InputValidator.parseNumber(maximumRateInput, fieldName: "maximum rate"),
                    michaelisConstant: try InputValidator.parseNumber(michaelisInput, fieldName: "Michaelis constant"),
                    bulkSubstrateConcentration: try InputValidator.parseNumber(substrateInput, fieldName: "bulk substrate"),
                    totalPelletVolume: try InputValidator.parseNumber(pelletVolumeInput, fieldName: "pellet volume")
                )
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadExample() {
        radiusInput = "0.001"
        diffusivityInput = "1e-9"
        maximumRateInput = "0.01"
        michaelisInput = "10"
        substrateInput = "2"
        pelletVolumeInput = "0.5"
        result = nil
        errorMessage = ""
    }

    private func resetInputs() {
        radiusInput = ""
        diffusivityInput = ""
        maximumRateInput = ""
        michaelisInput = ""
        substrateInput = ""
        pelletVolumeInput = ""
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { ImmobilizedEnzymeReactorView() }
}
