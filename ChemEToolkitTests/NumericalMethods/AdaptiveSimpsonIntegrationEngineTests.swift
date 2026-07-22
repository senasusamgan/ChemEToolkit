import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Adaptive Simpson Integration Engine") struct AdaptiveSimpsonIntegrationEngineTests{
 @Test("Integrates x squared")func reference()throws{let r=try AdaptiveSimpsonIntegrationEngine().solve(.init(function:.square,lowerBound:0,upperBound:1));#expect(abs(r.integral-1.0/3)<1e-9)}
 @Test("Tighter tolerance improves the error estimate")func trend()throws{let e=AdaptiveSimpsonIntegrationEngine();let loose=try e.solve(.init(function:.gaussian,lowerBound:0,upperBound:2,tolerance:1e-4));let tight=try e.solve(.init(function:.gaussian,lowerBound:0,upperBound:2,tolerance:1e-10));#expect(tight.estimatedError<=loose.estimatedError)}
 @Test("Rejects equal bounds")func invalid(){#expect(throws:AdaptiveSimpsonIntegrationError.invalidBounds){try AdaptiveSimpsonIntegrationEngine().solve(.init(function:.square,lowerBound:1,upperBound:1))}}
}
