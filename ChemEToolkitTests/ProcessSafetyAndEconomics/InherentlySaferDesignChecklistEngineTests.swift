import Testing
@testable import ChemEToolkit

@Suite("Inherently Safer Design Checklist Engine")
struct InherentlySaferDesignChecklistEngineTests {
    private let engine =
        InherentlySaferDesignChecklistEngine()

    @Test("Calculates principle coverage")
    func coverage() throws {
        let result = try engine.calculate(
            .init(
                minimizeRating: 3,
                substituteRating: 2,
                moderateRating: 4,
                simplifyRating: 3,
                implementationConfidence: 4
            )
        )

        #expect(result.principleScore == 12)
        #expect(result.maximumPrincipleScore == 20)

        #expect(
            abs(
                result.coverageFraction
                - 0.6
            ) < 1e-12
        )

        #expect(
            abs(
                result.confidenceAdjustedScore
                - 9.6
            ) < 1e-12
        )

        #expect(result.weakestPrinciple == "Substitute")
        #expect(result.maturityBand == "Established")
    }

    @Test("All-zero ratings remain valid")
    func zeroRatings() throws {
        let result = try engine.calculate(
            .init(
                minimizeRating: 0,
                substituteRating: 0,
                moderateRating: 0,
                simplifyRating: 0,
                implementationConfidence: 0
            )
        )

        #expect(result.principleScore == 0)
        #expect(result.coverageFraction == 0)
        #expect(result.maturityBand == "Initial")
    }

    @Test("Rejects rating above five")
    func validation() {
        #expect(
            throws:
                InherentlySaferDesignChecklistError
                    .ratingOutsideRange
        ) {
            try engine.calculate(
                .init(
                    minimizeRating: 6,
                    substituteRating: 2,
                    moderateRating: 4,
                    simplifyRating: 3,
                    implementationConfidence: 4
                )
            )
        }
    }
}
