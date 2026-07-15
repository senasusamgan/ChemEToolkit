import SwiftUI

struct PackedColumnHydraulicsView: View {
    @State private var gasFlow = "0.005"
    @State private var liquidFlow = "0.001"
    @State private var floodingVelocity = "0.1"
    @State private var designFraction = "0.6"
    @State private var packedHeight = "3"
    @State private var gasDensity = "1.2"
    @State private var gasViscosity = "0.000018"
    @State private var voidFraction = "0.4"
    @State private var packingDiameter = "0.005"
    @State private var result: PackedColumnHydraulicsResult?
    @State private var errorMessage = ""

    private let engine = PackedColumnHydraulicsEngine()
    private let formatter = NumberFormatterService.precise

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.xLarge) {
                ModuleHeaderView(
                    symbolName: "gauge.with.dots.needle.50percent",
                    title: "Packed-Column Hydraulics",
                    subtitle: "Size column diameter and estimate dry packed-bed pressure drop",
                    tint: .blue
                )

                CalculatorInfoCard(tint: .blue) {
                    VStack(spacing: AppSpacing.small) {
                        Text("Preliminary Hydraulic Design").font(.headline)
                        Text("A = QG/uG    •    D = √(4A/π)")
                            .font(.system(size: 19, weight: .semibold))
                        Text("uG = fraction × uflood")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Column area is sized from a selected fraction of flooding. Pressure drop uses the dry Ergun equation and excludes liquid-loading corrections.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                CalculatorCard {
                    VStack(alignment: .leading, spacing: AppSpacing.large) {
                        Text("Column Flow and Flooding Basis").font(.headline)

                        EngineeringInputField(
                            title: "Gas Volumetric Flow",
                            symbol: "QG",
                            unit: "m³/s",
                            placeholder: "Example: 0.005",
                            text: $gasFlow
                        )

                        EngineeringInputField(
                            title: "Liquid Volumetric Flow",
                            symbol: "QL",
                            unit: "m³/s",
                            placeholder: "Example: 0.001",
                            text: $liquidFlow
                        )

                        EngineeringInputField(
                            title: "Flooding Gas Velocity",
                            symbol: "uflood",
                            unit: "m/s",
                            placeholder: "Example: 0.1",
                            text: $floodingVelocity
                        )

                        EngineeringInputField(
                            title: "Design Fraction of Flooding",
                            symbol: "f",
                            unit: "—",
                            placeholder: "Example: 0.6",
                            text: $designFraction
                        )

                        EngineeringInputField(
                            title: "Packed Height",
                            symbol: "Z",
                            unit: "m",
                            placeholder: "Example: 3",
                            text: $packedHeight
                        )

                        Divider()
                        Text("Dry Packing and Gas Properties").font(.headline)

                        EngineeringInputField(
                            title: "Gas Density",
                            symbol: "ρG",
                            unit: "kg/m³",
                            placeholder: "Example: 1.2",
                            text: $gasDensity
                        )

                        EngineeringInputField(
                            title: "Gas Dynamic Viscosity",
                            symbol: "μG",
                            unit: "Pa·s",
                            placeholder: "Example: 0.000018",
                            text: $gasViscosity
                        )

                        EngineeringInputField(
                            title: "Bed Void Fraction",
                            symbol: "ε",
                            unit: "—",
                            placeholder: "Example: 0.4",
                            text: $voidFraction
                        )

                        EngineeringInputField(
                            title: "Equivalent Packing Diameter",
                            symbol: "dp",
                            unit: "m",
                            placeholder: "Example: 0.005",
                            text: $packingDiameter
                        )

                        CalculatorInfoCard(tint: .orange) {
                            Label(
                                "The pressure-drop result is a dry single-phase Ergun estimate; irrigated packing requires loading and flooding correlations.",
                                systemImage: "exclamationmark.triangle.fill"
                            )
                            .foregroundStyle(.secondary)
                        }

                        MassTransferActionButtons(loadExample: loadExample, clear: resetInputs)

                        PrimaryActionButton(
                            title: "Calculate Column Hydraulics",
                            systemImage: "gauge.with.dots.needle.50percent",
                            action: calculate
                        )

                        if let result {
                            CalculationResultCard(
                                items: [
                                    .init(label: "Design Gas Velocity", value: formatter.format(result.designGasVelocity), unit: "m/s"),
                                    .init(label: "Column Area", value: formatter.format(result.columnCrossSectionalArea), unit: "m²"),
                                    .init(label: "Column Diameter", value: formatter.format(result.columnDiameter), unit: "m"),
                                    .init(label: "Superficial Liquid Velocity", value: formatter.format(result.superficialLiquidVelocity), unit: "m/s"),
                                    .init(label: "Fraction of Flooding", value: formatter.format(100 * result.fractionOfFlooding), unit: "%"),
                                    .init(label: "Gas Capacity Factor", value: formatter.format(result.gasCapacityFactor), unit: "m/s·√kg/m³"),
                                    .init(label: "Modified Particle Reynolds", value: formatter.format(result.modifiedParticleReynoldsNumber), unit: "—"),
                                    .init(label: "Dry Pressure Drop / Length", value: formatter.format(result.dryPressureDropPerLength), unit: "Pa/m"),
                                    .init(label: "Total Dry Pressure Drop", value: formatter.format(result.totalDryPressureDrop), unit: "Pa")
                                ],
                                tint: .blue
                            )

                            CalculatorInfoCard(tint: .blue) {
                                VStack(alignment: .leading, spacing: AppSpacing.small) {
                                    Label("Hydraulic Interpretation", systemImage: "gauge.with.dots.needle.50percent")
                                        .font(.headline)
                                    Divider()
                                    Text(result.designAssessment).fontWeight(.semibold)
                                    Text(result.modelName).foregroundStyle(.secondary)
                                    Text(result.limitationDescription).foregroundStyle(.secondary)
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
        .navigationTitle("Packed-Column Hydraulics")
    }

    private func calculate() {
        clearResult()
        do {
            result = try engine.calculate(
                .init(
                    gasVolumetricFlowRate: try InputValidator.parseNumber(gasFlow, fieldName: "gas volumetric flow"),
                    liquidVolumetricFlowRate: try InputValidator.parseNumber(liquidFlow, fieldName: "liquid volumetric flow"),
                    floodingGasVelocity: try InputValidator.parseNumber(floodingVelocity, fieldName: "flooding gas velocity"),
                    designFractionOfFlooding: try InputValidator.parseNumber(designFraction, fieldName: "design fraction of flooding"),
                    packedHeight: try InputValidator.parseNumber(packedHeight, fieldName: "packed height"),
                    gasDensity: try InputValidator.parseNumber(gasDensity, fieldName: "gas density"),
                    gasViscosity: try InputValidator.parseNumber(gasViscosity, fieldName: "gas dynamic viscosity"),
                    bedVoidFraction: try InputValidator.parseNumber(voidFraction, fieldName: "bed void fraction"),
                    equivalentPackingDiameter: try InputValidator.parseNumber(packingDiameter, fieldName: "equivalent packing diameter")
                )
            )
        } catch {
            errorMessage = MassTransferViewSupport.errorMessage(for: error)
        }
    }

    private func loadExample() {
        gasFlow = "0.005"
        liquidFlow = "0.001"
        floodingVelocity = "0.1"
        designFraction = "0.6"
        packedHeight = "3"
        gasDensity = "1.2"
        gasViscosity = "0.000018"
        voidFraction = "0.4"
        packingDiameter = "0.005"
        clearResult()
    }

    private func resetInputs() {
        gasFlow = ""
        liquidFlow = ""
        floodingVelocity = ""
        designFraction = ""
        packedHeight = ""
        gasDensity = ""
        gasViscosity = ""
        voidFraction = ""
        packingDiameter = ""
        clearResult()
    }

    private func clearResult() {
        result = nil
        errorMessage = ""
    }
}

#Preview {
    NavigationStack { PackedColumnHydraulicsView() }
}
