import Foundation
import Testing
@testable import ChemEToolkit
@Suite("High-Order Finite Difference Engine") struct HighOrderFiniteDifferenceEngineTests{
 @Test("Differentiates a cubic")func reference()throws{let r=try HighOrderFiniteDifferenceEngine().solve(.init(function:.cubic,point:2,step:1e-3));#expect(abs(r.firstDerivative-10)<1e-9);#expect(abs(r.secondDerivative-12)<1e-7)}
 @Test("Smaller step improves the exponential derivative")func trend()throws{let e=HighOrderFiniteDifferenceEngine();let coarse=try e.solve(.init(function:.exponential,point:1,step:0.1));let fine=try e.solve(.init(function:.exponential,point:1,step:0.01));#expect(abs(fine.firstDerivative-exp(1))<abs(coarse.firstDerivative-exp(1)))}
 @Test("Rejects zero step")func invalid(){#expect(throws:HighOrderFiniteDifferenceError.invalidStep){try HighOrderFiniteDifferenceEngine().solve(.init(function:.sine,point:0,step:0))}}
}
