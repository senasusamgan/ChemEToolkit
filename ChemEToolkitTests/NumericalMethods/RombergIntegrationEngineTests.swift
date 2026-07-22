import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Romberg Integration Engine") struct RombergIntegrationEngineTests{
 @Test("Integrates exponential decay")func reference()throws{let r=try RombergIntegrationEngine().solve(.init(function:.exponentialDecay,lowerBound:0,upperBound:1,levels:7));#expect(abs(r.integral-(1-exp(-1.0)))<1e-10)}
 @Test("Extrapolation improves over the first trapezoid")func trend()throws{let r=try RombergIntegrationEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,levels:4));#expect(abs(r.integral-1.0/3)<abs(r.table[0][0]-1.0/3))}
 @Test("Rejects unsupported levels")func invalid(){#expect(throws:RombergIntegrationError.invalidLevels){try RombergIntegrationEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,levels:1))}}
}
