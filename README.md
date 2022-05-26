# InAccessibility
A SwiftUI app that's not very accessible... On purpose

This app is part of the [Accessibility](https://www.swiftuiseries.com/accessibility) event during the SwiftUI Series. This project has been made inaccessible and non-inclusive on purpose. Can you fix the 20+ areas that can be improved?


## What was improved?
- MainView:
    - Made UI Better in terms of iPad Support
    - Added searchable to view so that people can easily filter out unncessecary elements
    - Added actions to info and favroite for cells using swipeActions but also contextMenu (VoiceOver and Rotor Support)
    - Improved accesiibilityLabel by using NumberFormatter to spell out dollar
    - added several keyboard shortcuts but still not ideal
- StockCell:
    - Improved layout of cells so that they are readable when dynamicTypeSize is active
    - In terms of cells revamped all accessibilityLabel & value to better reflect what person would want to hear
- Graph:
    - I didn't have much time to go further down with contrast but it is a main point of improvement throught my app. I tried to use more of systemColors from UIKit but didn't manage to quite nail it. But still i did my best
    - Usage of reduceTransparency to remove opacity if needed
    - usage of reducemotion to remove animation where needed
    - usage of legibilityWeight to make dots bold by default
    - added accessibilityChartDescriptor to this graph
- DetailView:
    - horizontalSizeClass is used in buttons layout
    - accessibilityShowButtonShapes is used to further make buttons more stand out
    - added custom accessibilityLabel to big text to spell out numbers without dot
    - Changed buttons from on tap to real buttons to make use of system accessibility improvements  