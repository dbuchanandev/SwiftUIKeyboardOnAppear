//
//  ContentView.swift
//  SwiftUIKeyboardOnAppear
//
//  Created by Donavon Buchanan on 12/20/23.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct ContentView: View {
    // MARK: Internal
    var body: some View {
        VStack {
            Button("Present Single Field Sheet") {
                presentingSingleFieldSheet = true
            }

            Button("Present Multiple Field Sheet") {
                presentingMultipleFieldSheet = true
            }
        }
        .buttonStyle(.bordered)
        .padding()
        .sheet(isPresented: $presentingSingleFieldSheet) {
            SingleFieldSheetView()
        }
        .sheet(isPresented: $presentingMultipleFieldSheet) {
            MultipleFieldSheetView()
        }
    }

    // MARK: Private
    @State private var presentingSingleFieldSheet = false
    @State private var presentingMultipleFieldSheet = false
}

struct SingleFieldSheetView: View {
    // MARK: Internal
    var body: some View {
        VStack {
            TextField("Text Field Placeholder", text: $textValue)
                .textFieldStyle(.roundedBorder)
                .focusOnAppear($textFocus)
        }
        .padding()
    }

    // MARK: Private
    @FocusState private var textFocus: Bool
    @State private var textValue = String()
}

struct MultipleFieldSheetView: View {
    // MARK: Internal
    enum Fields: Hashable {
        case firstField, secondField, thirdField
    }

    var body: some View {
        VStack {
            TextField("First Field Placeholder", text: $firstText)
                .focusOnAppear($textFocus, equals: .firstField)

            TextField("Second Field Placeholder", text: $secondText)
                .focused($textFocus, equals: .secondField)

            TextField("Third Field Placeholder", text: $thirdText)
                .focused($textFocus, equals: .thirdField)
        }
        .textFieldStyle(.roundedBorder)
        .padding()
    }

    // MARK: Private
    @FocusState private var textFocus: Fields?
    @State private var firstText = String()
    @State private var secondText = String()
    @State private var thirdText = String()
}

extension View {
    func focusOnAppear(_ condition: FocusState<Bool>.Binding) -> some View {
        focused(condition)
            .focusBackground()
            .onAppear {
                condition.wrappedValue = true
            }
    }

    func focusOnAppear<Value>(
        _ binding: FocusState<Value>.Binding,
        equals value: Value
    )
    -> some View where Value: Hashable {
        focused(binding, equals: value)
            .focusBackground()
            .onAppear {
                binding.wrappedValue = value
            }
    }

    fileprivate func focusBackground() -> some View {
        background {
            #if canImport(UIKit)
            FirstResponderView()
            #endif
        }
    }
}

#if canImport(UIKit)
struct FirstResponderView: UIViewRepresentable {
    class Coordinator: NSObject {}

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isHidden = true
        textField.becomeFirstResponder() // Trigger immediate focus
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator() }
}
#endif

#Preview {
    ContentView()
}
