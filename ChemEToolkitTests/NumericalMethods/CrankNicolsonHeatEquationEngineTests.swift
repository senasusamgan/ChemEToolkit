import Foundation
import Testing
@testable import ChemEToolkit
@Suite("Crank-Nicolson Heat Equation Engine") struct CrankNicolsonHeatEquationEngineTests{
 @Test("Preserves a uniform field")func reference()throws{let r=try CrankNicolsonHeatEquationEngine().solve(.init(thermalDiffusivity:1e-5,length:0.1,totalTime:100,spatialNodes:11,timeSteps:10,initialTemperature:50,leftBoundaryTemperature:50,rightBoundaryTemperature:50));#expect(r.temperatures.allSatisfy{abs($0-50)<1e-10})}
 @Test("Hot boundaries raise the center temperature")func trend()throws{let e=CrankNicolsonHeatEquationEngine();let short=try e.solve(.init(thermalDiffusivity:1e-5,length:0.1,totalTime:10,spatialNodes:11,timeSteps:10,initialTemperature:20,leftBoundaryTemperature:100,rightBoundaryTemperature:100));let long=try e.solve(.init(thermalDiffusivity:1e-5,length:0.1,totalTime:100,spatialNodes:11,timeSteps:100,initialTemperature:20,leftBoundaryTemperature:100,rightBoundaryTemperature:100));#expect(long.temperatures[5]>short.temperatures[5])}
 @Test("Rejects invalid grid")func invalid(){#expect(throws:CrankNicolsonHeatEquationError.invalidGrid){try CrankNicolsonHeatEquationEngine().solve(.init(thermalDiffusivity:1e-5,length:1,totalTime:1,spatialNodes:2,timeSteps:1,initialTemperature:0,leftBoundaryTemperature:0,rightBoundaryTemperature:0))}}
}
