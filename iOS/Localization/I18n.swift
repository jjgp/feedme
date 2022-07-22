import Foundation

struct I18n {}

extension String {
    static let i18n = I18n()

    static func t(_ keyPath: KeyPath<I18n, String>) -> String {
        i18n[keyPath: keyPath]
    }

    static func t(_ keyPath: KeyPath<I18n, String>, _ args: CVarArg...) -> String {
        .localizedStringWithFormat(.t(keyPath), args)
    }
}
