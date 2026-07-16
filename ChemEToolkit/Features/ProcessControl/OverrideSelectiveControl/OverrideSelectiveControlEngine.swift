struct OverrideSelectiveControlEngine:
    Sendable {

    func calculate(
        _ input:
            OverrideSelectiveControlInput
    ) throws
        -> OverrideSelectiveControlResult {

        let values = [
            input.primaryControllerOutput,
            input.constraintControllerOutput,
            input.minimumFinalOutput,
            input.maximumFinalOutput
        ]

        guard values.allSatisfy(\.isFinite) else {
            throw OverrideSelectiveControlError
                .nonFiniteInput
        }

        guard
            input.minimumFinalOutput
            < input.maximumFinalOutput
        else {
            throw OverrideSelectiveControlError
                .invalidFinalOutputLimits
        }

        let selected: Double
        let selectedDescription: String
        let constraintOverride: Bool

        switch input.selectorMode {
        case .lowSelect:
            if input.constraintControllerOutput
                < input.primaryControllerOutput {
                selected =
                    input.constraintControllerOutput
                selectedDescription =
                    "Constraint controller selected by low selector."
                constraintOverride = true
            } else {
                selected =
                    input.primaryControllerOutput
                selectedDescription =
                    "Primary controller selected by low selector."
                constraintOverride = false
            }

        case .highSelect:
            if input.constraintControllerOutput
                > input.primaryControllerOutput {
                selected =
                    input.constraintControllerOutput
                selectedDescription =
                    "Constraint controller selected by high selector."
                constraintOverride = true
            } else {
                selected =
                    input.primaryControllerOutput
                selectedDescription =
                    "Primary controller selected by high selector."
                constraintOverride = false
            }
        }

        let finalOutput =
            min(
                input.maximumFinalOutput,
                max(
                    input.minimumFinalOutput,
                    selected
                )
            )

        let separation =
            abs(
                input.primaryControllerOutput
                - input.constraintControllerOutput
            )

        let results = [
            selected,
            finalOutput,
            separation
        ]

        guard results.allSatisfy(\.isFinite) else {
            throw OverrideSelectiveControlError
                .numericalFailure
        }

        return .init(
            selectedRawOutput:
                selected,
            finalOutput:
                finalOutput,
            selectedControllerDescription:
                selectedDescription,
            constraintHasOverride:
                constraintOverride,
            controllerSeparation:
                separation,
            finalOutputWasLimited:
                finalOutput != selected,
            modelName:
                "High- or low-select override control",
            limitationDescription:
                "Selects between two scalar controller outputs. Practical override schemes require tracking or external-reset feedback to prevent the unselected controller from winding up."
        )
    }
}
