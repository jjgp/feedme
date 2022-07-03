import Combine
import XCTest

protocol State: Equatable {
    associatedtype Action: RawRepresentable where Action.RawValue == String
}

typealias Reducer<S: State> = (inout S?, S.Action) -> S

protocol StatePublisher: ObservableObject {
    associatedtype S: State

    var cancellables: Set<AnyCancellable> { get }
    var state: S? { get }
    var statePublished: Published<S?> { get }
    var statePublisher: Published<S?>.Publisher { get }
}

protocol ActionSender {
    associatedtype S: State

    var subject: PassthroughSubject<Action, Never> { get }

    func send(_ action: Action)

    typealias Action = S.Action
}

extension ActionSender {
    func send(_ action: Action) {
        subject.send(action)
    }
}

final class Store<S: State>: StatePublisher, ActionSender {
    private(set) var cancellables: Set<AnyCancellable> = []
    private(set) var subject: PassthroughSubject<Action, Never>
    @Published private(set) var state: S?
    var statePublished: Published<S?> { _state }
    var statePublisher: Published<S?>.Publisher { $state }

    init(initialState: S?, reducer: @escaping Reducer<S>) {
        state = initialState
        subject = PassthroughSubject<Action, Never>()
        subject
            .scan(initialState) { state, action in
                var state = state
                return reducer(&state, action)
            }
            .removeDuplicates()
            .assign(to: \.state, on: self)
            .store(in: &cancellables)
    }
}

class StoreTests: XCTestCase {
    func testInitialize() async {
        let sut = makeSut()
        let spy = PublisherSpy(sut.$state)
        sut.send(.initialize)
        XCTAssertEqual(spy.values, [nil, Count()])
    }

    func testUpdatingCount() async {
        let sut = makeSut(initialState: Count())
        let spy = PublisherSpy(sut.$state)
        sut.send(.increment(10))
        sut.send(.decrement(20))
        let values = spy.values.map { $0?.count }
        XCTAssertEqual(values, [0, 10, -10])
    }
}

// MARK: - Test Helpers

struct Count: State {
    var count = 0

    enum Action {
        case initialize, increment(Int), decrement(Int)
    }
}

extension Count.Action: RawRepresentable {
    typealias RawValue = String

    public init?(rawValue: RawValue) {
        let components = rawValue.components(separatedBy: ",")
        let value = components.count == 2 ? components.last.flatMap(Int.init) : nil

        if components.first == "initialize" {
            self = .initialize
        } else if components.first == "increment", let value = value {
            self = .increment(value)
        } else if components.first == "decrement", let value = value {
            self = .decrement(value)
        } else {
            return nil
        }
    }

    var rawValue: String {
        switch self {
        case .initialize:
            return "initialize"
        case let .increment(value):
            return "increment,\(value)"
        case let .decrement(value):
            return "decrement,\(value)"
        }
    }
}

private func reducer(state: inout Count?, action: Count.Action) -> Count {
    switch action {
    case .initialize:
        return Count()
    case let .increment(value):
        state?.count += value
    case let .decrement(value):
        state?.count -= value
    }
    return state ?? Count()
}

private func makeSut(initialState: Count? = nil) -> Store<Count> {
    Store(initialState: initialState, reducer: reducer(state:action:))
}

private class PublisherSpy<P: Publisher> {
    private var cancellable: AnyCancellable!
    private(set) var failure: P.Failure?
    private(set) var finished = false
    private(set) var values: [P.Output] = []

    init(_ publisher: P) {
        cancellable = publisher.sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.finished = false
                case let .failure(error):
                    self?.failure = error
                }
            },
            receiveValue: { [weak self] value in
                self?.values.append(value)
            }
        )
    }
}
