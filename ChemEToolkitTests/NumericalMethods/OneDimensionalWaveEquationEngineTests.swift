import Foundation
import Testing
@testable import ChemEToolkit
@Suite("One-Dimensional Wave Equation Engine") struct OneDimensionalWaveEquationEngineTests{
 @Test("Half-period reverses the sine mode")func reference()throws{let r=try OneDimensionalWaveEquationEngine().solve(.init(waveSpeed:1,length:1,totalTime:1,spatialNodes:101,timeSteps:200,initialAmplitude:1));#expect(abs(r.displacements[50]+1)<0.001)}
 @Test("Quarter-period approaches zero")func trend()throws{let r=try OneDimensionalWaveEquationEngine().solve(.init(waveSpeed:1,length:1,totalTime:0.5,spatialNodes:101,timeSteps:100,initialAmplitude:1));#expect(abs(r.displacements[50])<0.001)}
 @Test("Rejects unstable Courant number")func invalid(){#expect(throws:OneDimensionalWaveEquationError.unstableCourantNumber){try OneDimensionalWaveEquationEngine().solve(.init(waveSpeed:1,length:1,totalTime:1,spatialNodes:101,timeSteps:10,initialAmplitude:1))}}
}
