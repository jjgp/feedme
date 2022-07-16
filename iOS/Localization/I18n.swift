import Foundation

extension String {
    static let i18n = I18n()

    static func t(_ key: KeyPath<I18n, String>) -> String {
        i18n[keyPath: key]
    }
}

struct I18n {}
