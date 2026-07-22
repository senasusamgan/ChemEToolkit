import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Monte Carlo Integration Engine") struct MonteCarloIntegrationEngineTests{
 @Test("Seeded estimate matches x squared integral")func reference()throws{let r=try MonteCarloIntegrationEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,sampleCount:100000,seed:42));#expect(abs(r.integral-1.0/3)<0.005)}
 @Test("Same seed is reproducible")func trend() throws {
        let engine = MonteCarloIntegrationEngine()
        let input = MonteCarloIntegrationInput(
            function: .gaussian,
            lowerBound: 0,
            upperBound: 1,
            sampleCount: 1_000,
            seed: 7
        )

        let first = try engine.solve(input)
        let second = try engine.solve(input)

        #expect(first.integral == second.integral)
        #expect(first.standardError == second.standardError)
        #expect(first.sampleCount == second.sampleCount)
    }
 @Test("Rejects one sample")func invalid(){#expect(throws:MonteCarloIntegrationError.insufficientSamples){try MonteCarloIntegrationEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,sampleCount:1))}}
}
