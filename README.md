# Sweet Slider

A SwiftUI donut ordering demo app focused on polished UI interactions and clear project structure.

## Overview

This project currently contains a UI-first implementation with dummy data.
The app demonstrates:
- Hero-style donut carousel
- Product card and quantity stepper
- Cart and profile pages
- Haptic feedback on slide change and add-to-cart

## Project Structure

```text
Sweet_Slider/
  Core/
    AppPage.swift          # Typed navigation state (home/cart/profile)
    UIConstants.swift      # Shared animation and timing constants
  Models/
    Donut.swift            # Donut model + seed data
  Stores/
    CartStore.swift        # Observable cart state and pricing logic
  Components/
    HomeComponents.swift   # Reusable UI components (slide, stepper, styles)
  ContentView.swift        # Home screen composition and interaction logic
  PagesView.swift          # Cart and Profile screens
  Sweet_SliderApp.swift    # App entry point
  Assets.xcassets/         # Icons and donut assets
```

## Architecture Notes

This codebase follows a pragmatic beginner-friendly SwiftUI architecture:
- Keep domain models in `Models`
- Keep mutable business state in `Stores`
- Keep reusable views/styles in `Components`
- Keep shared enums/constants in `Core`
- Keep top-level page composition in `ContentView` and page-specific screens in `PagesView`

Why this structure:
- Easier onboarding for new developers
- Reduced file size and cognitive load
- Better separation of UI rendering and state logic

## Run the App

1. Open `Sweet_Slider.xcodeproj` in Xcode
2. Select the `Sweet_Slider` scheme
3. Run on iOS Simulator or device

## Current Scope

- UI and interaction prototype
- Local in-memory cart state
- Dummy product data

## Suggested Next Steps

1. Add a dedicated ViewModel per page (`HomeViewModel`, `CartViewModel`)
2. Move copy/strings to localizable resources
3. Add snapshot and unit tests
4. Add persistence layer for cart state
5. Replace placeholder checkout with real flow

## UI Screenshots

Screenshots are available in the `UI/` folder:

- Home carousel: [UI/Donut-1.png](UI/Donut-1.png)
- Home carousel variation: [UI/Donut-2.png](UI/Donut-2.png)
- Home carousel variation: [UI/Donut-3.png](UI/Donut-3.png)
- Home carousel variation: [UI/Donut-4.png](UI/Donut-4.png)
- Cart page: [UI/Cart Page.png](UI/Cart%20Page.png)
- Profile page: [UI/Profile page.png](UI/Profile%20page.png)
