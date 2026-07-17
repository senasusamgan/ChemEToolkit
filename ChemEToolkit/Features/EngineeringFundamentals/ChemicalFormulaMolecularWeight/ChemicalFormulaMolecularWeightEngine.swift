import Foundation

struct ChemicalFormulaMolecularWeightEngine:
    Sendable {

    private let atomicWeights: [String: Double] = [
        "H": 1.008,
        "He": 4.002602,
        "Li": 6.94,
        "Be": 9.0121831,
        "B": 10.81,
        "C": 12.011,
        "N": 14.007,
        "O": 15.999,
        "F": 18.998403163,
        "Ne": 20.1797,
        "Na": 22.98976928,
        "Mg": 24.305,
        "Al": 26.9815385,
        "Si": 28.085,
        "P": 30.973761998,
        "S": 32.06,
        "Cl": 35.45,
        "Ar": 39.948,
        "K": 39.0983,
        "Ca": 40.078,
        "Cr": 51.9961,
        "Mn": 54.938044,
        "Fe": 55.845,
        "Co": 58.933194,
        "Ni": 58.6934,
        "Cu": 63.546,
        "Zn": 65.38,
        "Br": 79.904,
        "Ag": 107.8682,
        "I": 126.90447,
        "Ba": 137.327,
        "Pt": 195.084,
        "Au": 196.966569,
        "Hg": 200.592,
        "Pb": 207.2
    ]

    func calculate(
        _ input:
            ChemicalFormulaMolecularWeightInput
    ) throws
        -> ChemicalFormulaMolecularWeightResult {

        let formula =
            input.formula
                .trimmingCharacters(
                    in: .whitespacesAndNewlines
                )

        guard !formula.isEmpty else {
            throw ChemicalFormulaMolecularWeightError
                .emptyFormula
        }

        let characters =
            Array(formula)

        var index = 0
        var counts: [String: Int] = [:]

        while index < characters.count {
            let current =
                characters[index]

            guard current.isUppercase else {
                throw ChemicalFormulaMolecularWeightError
                    .invalidFormula
            }

            var symbol =
                String(current)

            index += 1

            if
                index < characters.count,
                characters[index].isLowercase
            {
                symbol.append(
                    characters[index]
                )

                index += 1
            }

            guard atomicWeights[symbol] != nil else {
                throw ChemicalFormulaMolecularWeightError
                    .unknownElement
            }

            var digits = ""

            while
                index < characters.count,
                characters[index].isNumber
            {
                digits.append(
                    characters[index]
                )

                index += 1
            }

            let count: Int

            if digits.isEmpty {
                count = 1
            } else {
                guard
                    let parsed =
                        Int(digits),
                    parsed > 0
                else {
                    throw ChemicalFormulaMolecularWeightError
                        .invalidFormula
                }

                count = parsed
            }

            counts[symbol, default: 0] += count
        }

        guard !counts.isEmpty else {
            throw ChemicalFormulaMolecularWeightError
                .invalidFormula
        }

        let molecularWeight =
            counts.reduce(0.0) {
                partial,
                entry in

                partial
                + (
                    atomicWeights[entry.key]
                    ?? 0
                )
                * Double(entry.value)
            }

        let totalAtomCount =
            counts.values.reduce(0, +)

        let breakdown =
            counts
                .sorted {
                    $0.key < $1.key
                }
                .map {
                    "\($0.key): \($0.value)"
                }
                .joined(
                    separator: ", "
                )

        guard
            molecularWeight.isFinite,
            molecularWeight > 0,
            totalAtomCount > 0
        else {
            throw ChemicalFormulaMolecularWeightError
                .numericalFailure
        }

        return .init(
            normalizedFormula:
                formula,
            molecularWeight:
                molecularWeight,
            totalAtomCount:
                totalAtomCount,
            distinctElementCount:
                counts.count,
            elementalBreakdown:
                breakdown,
            modelName:
                "Simple-formula atomic-weight summation",
            limitationDescription:
                "Supports common element symbols and positive integer subscripts. Parentheses, hydrates, charges and isotope notation are outside this introductory parser."
        )
    }
}
