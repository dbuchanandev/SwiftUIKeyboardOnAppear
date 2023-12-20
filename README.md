Experimental workaround to [this issue](https://mastodon.social/@b3ll/111611598393367245) for quickly showing the iOS keyboard when a view is presented.

Uses UIKit to trigger keyboard presentation while still keeping the original SwiftUI view being focused.

| Before  | After |
| ------------- | ------------- |
| <video src='https://github.com/dbuchanandev/SwiftUIKeyboardOnAppear/assets/5569820/73d1815c-12c9-45bb-966a-abb4e07a6253' width=180/> | <video src='https://github.com/dbuchanandev/SwiftUIKeyboardOnAppear/assets/5569820/abc1fb54-15c1-4422-a6af-3629df0e8189' width=180/> |

```swift
#if canImport(UIKit)
import UIKit
#endif

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
```
