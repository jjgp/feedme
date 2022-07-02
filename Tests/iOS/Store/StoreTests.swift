import Combine
import XCTest

protocol StatePublisher: ObservableObject {
    associatedtype State: Equatable

    var cancellables: Set<AnyCancellable> { get }
    var state: State { get }
    var statePublished: Published<State> { get }
    var statePublisher: Published<State>.Publisher { get }
}

protocol ActionSender {
    associatedtype Action: Equatable

    var subject: PassthroughSubject<Action, Never> { get }

    func send(_ action: Action)
}

extension ActionSender {
    func send(_ action: Action) {
        subject.send(action)
    }
}

typealias Reducer<State, Action> = (inout State, Action) -> State

final class Store<State: Equatable, Action: Equatable>: StatePublisher, ActionSender {
    private(set) var cancellables: Set<AnyCancellable> = []
    private(set) var subject: PassthroughSubject<Action, Never>
    @Published private(set) var state: State
    var statePublished: Published<State> { _state }
    var statePublisher: Published<State>.Publisher { $state }

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
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
        XCTAssertEqual(spy.values, [0])
    }

    func testActionsUpdateState() {
        let sut = makeSut()
        let spy = PublisherSpy(sut.$state)
        sut.send(.decrement)
        let anotherSpy = PublisherSpy(sut.$state)
        sut.send(.increment)
        XCTAssertEqual(spy.values, [0, -1, 0])
        XCTAssertEqual(anotherSpy.values, [-1, 0])
    }
}

// MARK: - Test Helpers

private enum Action: String {
    case increment
    case decrement
}

private func reducer(state: inout Int, action: Action) -> Int {
    switch action {
    case .increment:
        state += 1
    case .decrement:
        state -= 1
    }
    return state
}

private func makeSut(initialState: Int = 0) -> Store<Int, Action> {
    Store(
        initialState: initialState,
        reducer: reducer(state:action:)
    )
}

private class PublisherSpy<P: Publisher> {
    private var cancellable: AnyCancellable!
    private(set) var failure: P.Failure?
    private(set) var isFinished = false
    private(set) var values: [P.Output] = []

    init(_ publisher: P) {
        cancellable = publisher.sink(
            receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isFinished = false
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
