import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Adams-Bashforth-Moulton Engine") struct AdamsBashforthMoultonEngineTests{
 @Test("Matches exponential growth")func reference()throws{let r=try AdamsBashforthMoultonEngine().solve(.init(equation:.exponentialGrowth,initialX:0,initialY:1,finalX:1,stepSize:0.05));#expect(abs(r.finalValue-exp(1))<2e-5)}
 @Test("Smaller step improves accuracy")func trend()throws{let e=AdamsBashforthMoultonEngine();let coarse=try e.solve(.init(equation:.linearForcing,initialX:0,initialY:1,finalX:2,stepSize:0.2));let fine=try e.solve(.init(equation:.linearForcing,initialX:0,initialY:1,finalX:2,stepSize:0.05));let exact=1+2*exp(-2.0);#expect(abs(fine.finalValue-exact)<abs(coarse.finalValue-exact))}
 @Test("Rejects too few steps")func invalid(){#expect(throws:AdamsBashforthMoultonError.insufficientSteps){try AdamsBashforthMoultonEngine().solve(.init(equation:.exponentialGrowth,initialX:0,initialY:1,finalX:1,stepSize:0.5))}}
}
