import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Gauss-Legendre Quadrature Engine") struct GaussLegendreQuadratureEngineTests{
 @Test("Integrates a polynomial exactly")func reference()throws{let r=try GaussLegendreQuadratureEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,order:2));#expect(abs(r.integral-1.0/3)<1e-14)}
 @Test("Higher order improves a Gaussian integral")func trend()throws{let e=GaussLegendreQuadratureEngine();let reference=0.746824132812427;let low=try e.solve(.init(function:.gaussian,lowerBound:0,upperBound:1,order:2));let high=try e.solve(.init(function:.gaussian,lowerBound:0,upperBound:1,order:5));#expect(abs(high.integral-reference)<abs(low.integral-reference))}
 @Test("Rejects unsupported order")func invalid(){#expect(throws:GaussLegendreQuadratureError.unsupportedOrder){try GaussLegendreQuadratureEngine().solve(.init(function:.square,lowerBound:0,upperBound:1,order:6))}}
}
