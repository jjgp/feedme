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
    func testInitialState() async {
        let sut = makeSut()
        let spy = PublisherSpy(sut.$state)
        sut.send(.initialize)
        XCTAssertEqual(spy.values, [nil, Count()])
    }
}

// MARK: - Test Helpers

struct Count: State {
    var count = 0

    enum Action: String {
        case initialize, increment, decrement
    }
}

private func reducer(state: inout Count?, action: Count.Action) -> Count {
    var state = state ?? Count()

    switch action {
    case .increment:
        state.count += 1
    case .decrement:
        state.count -= 1
    default:
        return Count()
    }

    return state
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
