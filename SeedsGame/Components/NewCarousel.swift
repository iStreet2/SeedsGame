//
//  NewCarousel.swift
//  PathsTest
//
//  Created by André Arteca on 25/01/24.
//

import SwiftUI

struct Carousel: View {
    @Binding var currentIndex: Int
    @Binding var gestureIsOn: Bool
    @GestureState var gesture: Float = 0.0
    @State var dragOffset: CGFloat = 0
    @State var currentScale: CGFloat = 1.2
    @State var nextScale: CGFloat = 0.7
    
    @State var currentOpacity: CGFloat = 1.0
    @State var nextOpacity: CGFloat = 0.7
    
    @State var currentGray: CGFloat = 0
    @State var nextGray: CGFloat = 1.0
    
    var views: [AnyView]
    
    // Criação da gesture Horizontal
    var dragGestureHorizontal: some Gesture {
        DragGesture()
            .onChanged { value in
                self.dragOffset =
                value.translation.width
                var scale: CGFloat = dragOffset
                
                if abs(scale) > 100 {
                    scale = 100
                } else {
                    scale = dragOffset
                }
                
                self.currentScale = getX(min: 0, max: 180, slider: scale, min2: 1.2, max2: 0.7)
                self.nextScale = getX(min: 0, max: 180, slider: scale, min2: 0.7, max2: 1.2)
                
                self.currentOpacity = getX(min: 0, max: 180, slider: scale, min2: 1.0, max2: 0.5)
                self.nextOpacity = getX(min: 0, max: 180, slider: scale, min2: 0.5, max2: 1.0)
                
                self.currentGray = getX(min: 0, max: 180, slider: scale, min2: 0, max2: 1.0)
                self.nextGray = getX(min: 0, max: 180, slider: scale, min2: 1.0, max2: 0)
                
            }
//            .onEnded { value in
//                withAnimation(Animation.spring()) {
//                    if value.translation.width < -40 {
//                        currentIndex = min(currentIndex + 1, views.count - 1)
//                        
//                    } else if value.translation.width > 40 {
//                        currentIndex = max(currentIndex - 1, 0)
//                        
//                    }
//                    self.dragOffset = 0.5
//                    self.currentScale = 1.2
//                    self.nextScale = 1.2
//                    self.currentOpacity = 1.2
//                    self.nextOpacity = 0.7
//                    self.currentGray = 0.0
//                    self.nextGray = 1.0
//                }
//            }
    }
    
    
    public init<Views>(currentIndex: Binding<Int>, gestureIsOn: Binding<Bool>, @ViewBuilder content: @escaping () -> TupleView<Views>) {
        self._currentIndex = currentIndex
        self._gestureIsOn = gestureIsOn
        views = content().getViews
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                ZStack() {
                    ForEach(views.indices) { index in
                        self.views[index]
                            .frame(width:geometry.size.width/2, height: geometry.size.width/2)
                            .scaleEffect(index == currentIndex ? gestureIsOn ? currentScale: 1 : index == currentIndex + 1 ? dragOffset < 0 ? nextScale: 1.2 : index == currentIndex - 1 ? dragOffset > 0 ? nextScale: 1.2 : 1.2)
                            .offset(x: geometry.size.width)
                            .offset(x: CGFloat(index - currentIndex) * geometry.size.width/2 + dragOffset)
                        
                            .opacity(index == currentIndex ? currentOpacity : gestureIsOn ? index == currentIndex + 1 ? dragOffset < 0 ? nextOpacity: 0.5 : index == currentIndex - 1 ? dragOffset > 0 ? nextOpacity: 0.5 : 0.5:0)
                            .grayscale(index == currentIndex ? currentGray: index == currentIndex + 1 ? dragOffset < 0 ? nextGray: 1.0 : index == currentIndex - 1 ? dragOffset > 0 ? nextGray: 1.0 : 1.0)
                        
                    }
                    
                }
                
                .gesture(gestureIsOn ? dragGestureHorizontal : nil)
                Spacer()
            }
            
        }
    }
}

extension View {

    func getX(min:CGFloat, max: CGFloat, slider: CGFloat, min2:CGFloat, max2:CGFloat) -> CGFloat{
        let ratio: CGFloat = (abs(slider) - min) / (max - min)
        let newX: CGFloat = min2 + ratio * (max2 - min2)
        return newX
    }
}
