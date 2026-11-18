#if canImport(AppKit) && !canImport(UIKit)
    import AppKit
#endif
@testable import GhosttyTerminal
import Testing

struct TerminalScrollModifiersTests {
    // Values from ghostty_input_mouse_momentum_e in ghostty.h (lines 148-156).
    @Test
    func `every momentum phase keeps the header value in a 3-bit field`() {
        let expected: [(TerminalScrollModifiers.Momentum, Int32)] = [
            (.none, 0), (.began, 1), (.stationary, 2), (.changed, 3),
            (.ended, 4), (.cancelled, 5), (.mayBegin, 6),
        ]
        for (momentum, value) in expected {
            #expect(momentum.rawValue == value)
            let mods = TerminalScrollModifiers(precision: true, momentum: momentum)
            #expect(mods.rawValue == 1 | (value << 1))
            #expect(mods.precision)
            #expect(mods.momentum == momentum)
        }
    }

    #if canImport(AppKit) && !canImport(UIKit)
        @Test
        func `appkit momentum phases map one to one`() {
            let cases: [(NSEvent.Phase, TerminalScrollModifiers.Momentum)] = [
                ([], .none), (.began, .began), (.stationary, .stationary), (.changed, .changed),
                (.ended, .ended), (.cancelled, .cancelled), (.mayBegin, .mayBegin),
            ]
            for (phase, momentum) in cases {
                #expect(TerminalScrollModifiers.momentumFrom(phase: phase) == momentum)
            }
        }
    #endif
}
