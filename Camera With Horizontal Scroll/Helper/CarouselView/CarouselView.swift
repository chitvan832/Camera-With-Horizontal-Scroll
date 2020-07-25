
//SOURCE: https://gist.github.com/xtabbas/97b44b854e1315384b7d1d5ccce20623

import SwiftUI

//TODO: Refactor Whole code
struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: Int //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    @EnvironmentObject var model: ContentViewModel
    
    @inlinable public init(
        numberOfItems: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = CGFloat(numberOfItems - 1) * spacing
        self.cardWidth = (UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2))/2 //279
    }
    
    var body: some View {
        let numberOfItems = CGFloat(self.numberOfItems)
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(model.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(model.activeCard) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + model.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.model.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.model.screenDrag = 0
            
            if (value.translation.width < -50 && CGFloat(self.model.activeCard) < numberOfItems - 1) {
                self.model.activeCard = self.model.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50 && CGFloat(self.model.activeCard) > 0) {
                self.model.activeCard = self.model.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}

struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var model: ContentViewModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Item<Content: View>: View {
    
    @EnvironmentObject var model: ContentViewModel
    
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: String
    var content: Content
    
    @inlinable public init(
        _id: String,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = (UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2))/2 //279
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth,
                   height: cardHeight,
                   alignment: .center)
    }
}
