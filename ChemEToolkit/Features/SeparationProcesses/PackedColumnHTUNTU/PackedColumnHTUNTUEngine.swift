struct PackedColumnHTUNTUEngine: Sendable {
    func calculate(_ input: PackedColumnHTUNTUInput) throws -> PackedColumnHTUNTUResult {
        let values = [input.heightOfTransferUnit, input.numberOfTransferUnits, input.packingSafetyFactor]
        guard values.allSatisfy(\.isFinite) else { throw PackedColumnHTUNTUError.nonFiniteInput }
        guard input.heightOfTransferUnit > 0, input.numberOfTransferUnits > 0 else {
            throw PackedColumnHTUNTUError.nonPositiveHTUOrNTU
        }
        guard input.packingSafetyFactor >= 1 else { throw PackedColumnHTUNTUError.invalidSafetyFactor }

        let theoretical = input.heightOfTransferUnit * input.numberOfTransferUnits
        let design = theoretical * input.packingSafetyFactor
        let margin = design - theoretical
        let effectiveNTU = design / input.heightOfTransferUnit

        guard [theoretical, design, margin, effectiveNTU].allSatisfy(\.isFinite) else {
            throw PackedColumnHTUNTUError.numericalFailure
        }

        return .init(
            theoreticalPackedHeight: theoretical,
            designPackedHeight: design,
            effectiveTransferUnits: effectiveNTU,
            addedHeightMargin: margin,
            modelName: "Packed-column HTU/NTU relation",
            limitationDescription: "Uses Z = HTU × NTU with a multiplicative design factor; distributor and disengagement heights are excluded."
        )
    }
}
