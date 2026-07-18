import SwiftUI

    struct ConstantPressureFilterSizingView: View {
        @State private var volumeInput = "10"

    @State private var areaInput = "5"

    @State private var pressureInput = "200000"

    @State private var viscosityInput = "0.001"

    @State private var mediumInput = "100000000000"

    @State private var cakeInput = "100000000000"

    @State private var solidsInput = "20"

        @State private var result: ConstantPressureFilterSizingResult?
        @State private var errorMessage = ""

        private let engine = ConstantPressureFilterSizingEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "line.3.horizontal.decrease",
                        title: "Constant-Pressure Filter Sizing",
                        subtitle: "Estimate filtration time from medium and cake resistance",
                        tint: .purple
                    )

                    CalculatorInfoCard(tint: .purple) {
                        Text("Use a consistent engineering unit system across all entered quantities.")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: AppTheme.Layout.calculatorMaxWidth)

                    CalculatorCard {
                        VStack(alignment: .leading, spacing: AppSpacing.large) {
                        EngineeringInputField(
                        title: "Filtrate Volume",
                        symbol: "V",
                        unit: "m³",
                        placeholder: "10",
                        text: $volumeInput
                    )

                    EngineeringInputField(
                        title: "Filter Area",
                        symbol: "A",
                        unit: "m²",
                        placeholder: "5",
                        text: $areaInput
                    )

                    EngineeringInputField(
                        title: "Pressure Drop",
                        symbol: "deltaP",
                        unit: "Pa",
                        placeholder: "200000",
                        text: $pressureInput
                    )

                    EngineeringInputField(
                        title: "Liquid Viscosity",
                        symbol: "mu",
                        unit: "Pa·s",
                        placeholder: "0.001",
                        text: $viscosityInput
                    )

                    EngineeringInputField(
                        title: "Medium Resistance",
                        symbol: "R_m",
                        unit: "1/m",
                        placeholder: "100000000000",
                        text: $mediumInput
                    )

                    EngineeringInputField(
                        title: "Specific Cake Resistance",
                        symbol: "alpha",
                        unit: "m/kg",
                        placeholder: "100000000000",
                        text: $cakeInput
                    )

                    EngineeringInputField(
                        title: "Solids per Filtrate Volume",
                        symbol: "c",
                        unit: "kg/m³",
                        placeholder: "20",
                        text: $solidsInput
                    )

                            HStack {
                                Spacer()
                                Button(role: .destructive, action: resetInputs) {
                                    Label("Clear", systemImage: "trash")
                                }
                            }
                            .buttonStyle(.bordered)

                            PrimaryActionButton(
                                title: "Calculate",
                                systemImage: "line.3.horizontal.decrease",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Total Filtration Time",
                                value: numberFormatter.format(result.totalFiltrationTime),
                                unit: "s"
                            ),
.init(
                                label: "Medium Contribution",
                                value: numberFormatter.format(result.mediumTimeContribution),
                                unit: "s"
                            ),
.init(
                                label: "Cake Contribution",
                                value: numberFormatter.format(result.cakeTimeContribution),
                                unit: "s"
                            ),
.init(
                                label: "Average Filtrate Rate",
                                value: numberFormatter.format(result.averageFiltrateRate),
                                unit: "m³/s"
                            ),
.init(
                                label: "Final Cake Mass",
                                value: numberFormatter.format(result.finalCakeMass),
                                unit: "kg"
                            )
                                    ],
                                    tint: .purple
                                )

                                CalculatorInfoCard(tint: .purple) {
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
            .navigationTitle("Constant-Pressure Filter Sizing")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            filtrateVolume: try InputValidator.parseNumber(
                            volumeInput,
                            fieldName: "filtrate volume"
                        ),
                        filterArea: try InputValidator.parseNumber(
                            areaInput,
                            fieldName: "filter area"
                        ),
                        pressureDrop: try InputValidator.parseNumber(
                            pressureInput,
                            fieldName: "pressure drop"
                        ),
                        liquidViscosity: try InputValidator.parseNumber(
                            viscosityInput,
                            fieldName: "liquid viscosity"
                        ),
                        mediumResistance: try InputValidator.parseNumber(
                            mediumInput,
                            fieldName: "medium resistance"
                        ),
                        specificCakeResistance: try InputValidator.parseNumber(
                            cakeInput,
                            fieldName: "specific cake resistance"
                        ),
                        solidsPerFiltrateVolume: try InputValidator.parseNumber(
                            solidsInput,
                            fieldName: "solids per filtrate volume"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            volumeInput = ""
        areaInput = ""
        pressureInput = ""
        viscosityInput = ""
        mediumInput = ""
        cakeInput = ""
        solidsInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { ConstantPressureFilterSizingView() }
    }
