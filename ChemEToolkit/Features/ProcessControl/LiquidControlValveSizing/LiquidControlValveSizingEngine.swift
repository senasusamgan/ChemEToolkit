struct LiquidControlValveSizingEngine: Sendable {
    private let waterDensity = 1000.0
    private let cvPerKv = 1.156099228

    func calculate(_ input: LiquidControlValveSizingInput) throws -> LiquidControlValveSizingResult {
        let values = [input.liquidFlowRate, input.pressureDrop, input.liquidDensity,
                      input.installedValveKv, input.designSafetyFactor]
        guard values.allSatisfy(\.isFinite) else { throw LiquidControlValveSizingError.nonFiniteInput }
        guard input.liquidFlowRate >= 0 else { throw LiquidControlValveSizingError.negativeFlowRate }
        guard input.pressureDrop > 0 else { throw LiquidControlValveSizingError.nonPositivePressureDrop }
        guard input.liquidDensity > 0 else { throw LiquidControlValveSizingError.nonPositiveDensity }
        guard input.installedValveKv > 0 else { throw LiquidControlValveSizingError.nonPositiveInstalledKv }
        guard input.designSafetyFactor >= 1 else { throw LiquidControlValveSizingError.invalidSafetyFactor }

        let specificGravity = input.liquidDensity / waterDensity
        let requiredKv = input.liquidFlowRate * (specificGravity / input.pressureDrop).squareRoot()
        let designKv = requiredKv * input.designSafetyFactor
        let equivalentCv = designKv * cvPerKv
        let capacityFraction = designKv / input.installedValveKv
        let estimatedOpening = min(1, max(0, capacityFraction))
        let margin = (input.installedValveKv - designKv) / input.installedValveKv

        let results = [specificGravity, requiredKv, designKv, equivalentCv,
                       capacityFraction, estimatedOpening, margin]
        guard results.allSatisfy(\.isFinite), specificGravity > 0, requiredKv >= 0,
              designKv >= 0, capacityFraction >= 0, estimatedOpening >= 0,
              estimatedOpening <= 1 else {
            throw LiquidControlValveSizingError.numericalFailure
        }

        return .init(
            specificGravity: specificGravity,
            requiredKvWithoutMargin: requiredKv,
            designKv: designKv,
            equivalentCv: equivalentCv,
            installedCapacityFraction: capacityFraction,
            estimatedLinearOpening: estimatedOpening,
            installedValveIsAdequate: input.installedValveKv >= designKv,
            capacityMarginFraction: margin,
            modelName: "Incompressible-liquid Kv sizing: Q = Kv·√(ΔP/SG)",
            limitationDescription: "Uses Q in m³/h, ΔP in bar and density relative to water. It neglects flashing, cavitation, viscosity corrections, fittings, noise, choked flow and manufacturer-specific recovery factors."
        )
    }
}
