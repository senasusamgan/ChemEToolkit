import Foundation
import SwiftUI
struct CubicHermiteInterpolationView: View {
 @State private var output:String?
 @State private var errorText:String?
 var body:some View { ScrollView { VStack(alignment:.leading,spacing:16) {
  Text("Cubic Hermite Interpolation").font(.largeTitle.bold())
  Text("Endpoint values and slopes must use mutually consistent units.").foregroundStyle(.secondary)
  Button("Calculate Example"){calculate()}.buttonStyle(.borderedProminent)
  if let output{Text("Result: \(output)").font(.headline)}
  if let errorText{Text(errorText).foregroundStyle(.red)}
 }.padding() } }
 private func calculate(){do{let r = try CubicHermiteInterpolationEngine().solve(.init(x0: 0, x1: 1, y0: 0, y1: 1, slope0: 0, slope1: 3, query: 0.5)); output = String(format: "%.10g", r.value);errorText=nil}catch{output=nil;errorText=error.localizedDescription}}
}
