import SwiftUI

    struct PackedColumnHTUNTUView: View {
        @State private var htuInput = "0.8"

    @State private var ntuInput = "6"

    @State private var safetyInput = "1.15"

        @State private var result: PackedColumnHTUNTUResult?
        @State private var errorMessage = ""

        private let engine = PackedColumnHTUNTUEngine()
        private let numberFormatter = NumberFormatterService.precise

        var body: some View {
            ScrollView {
                VStack(spacing: AppSpacing.xLarge) {
                    ModuleHeaderView(
                        symbolName: "square.stack.3d.up.fill",
                        title: "Packed-Column HTU/NTU",
                        subtitle: "Estimate packed height from transfer units",
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
                        title: "Height of Transfer Unit",
                        symbol: "HTU",
                        unit: "m",
                        placeholder: "0.8",
                        text: $htuInput
                    )

                    EngineeringInputField(
                        title: "Number of Transfer Units",
                        symbol: "NTU",
                        unit: "—",
                        placeholder: "6",
                        text: $ntuInput
                    )

                    EngineeringInputField(
                        title: "Packing Safety Factor",
                        symbol: "SF",
                        unit: "—",
                        placeholder: "1.15",
                        text: $safetyInput
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
                                systemImage: "square.stack.3d.up.fill",
                                action: calculate
                            )

                            if let result {
                                CalculationResultCard(
                                    items: [
                                        .init(
                                label: "Design Packed Height",
                                value: numberFormatter.format(result.designPackedHeight),
                                unit: "m"
                            ),
.init(
                                label: "Theoretical Packed Height",
                                value: numberFormatter.format(result.theoreticalPackedHeight),
                                unit: "m"
                            ),
.init(
                                label: "Effective Transfer Units",
                                value: numberFormatter.format(result.effectiveTransferUnits),
                                unit: "—"
                            ),
.init(
                                label: "Added Height Margin",
                                value: numberFormatter.format(result.addedHeightMargin),
                                unit: "m"
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
            .navigationTitle("Packed-Column HTU/NTU")
        }

        private func calculate() {
            result = nil
            errorMessage = ""

            do {
                result = try engine.calculate(
                    .init(
                            heightOfTransferUnit: try InputValidator.parseNumber(
                            htuInput,
                            fieldName: "height of transfer unit"
                        ),
                        numberOfTransferUnits: try InputValidator.parseNumber(
                            ntuInput,
                            fieldName: "number of transfer units"
                        ),
                        packingSafetyFactor: try InputValidator.parseNumber(
                            safetyInput,
                            fieldName: "packing safety factor"
                        )
                    )
                )
            } catch {
                errorMessage = error.localizedDescription
            }
        }

        private func resetInputs() {
            htuInput = ""
        ntuInput = ""
        safetyInput = ""
            result = nil
            errorMessage = ""
        }
    }

    #Preview {
        NavigationStack { PackedColumnHTUNTUView() }
    }
