import Combine
import XCTest

protocol Reducer {
    associatedtype State
}

enum Actions {
    struct Action<State> {
        let action: (inout State) -> State

        init(reduce: @escaping (inout State) -> State) {
            action = reduce
        }

        init(mutate: @escaping (inout State) -> Void) {
            action = { state in
                mutate(&state)
                return state
            }
        }
    }

    struct Creator<T, State> {
        let creator: (T) -> Action<State>

        init(reduce: @escaping (inout State, T) -> State) {
            creator = { value in
                Action { state in
                    reduce(&state, value)
                }
            }
        }

        init(mutate: @escaping (inout State, T) -> Void) {
            creator = { value in
                Action { state in
                    mutate(&state, value)
                }
            }
        }
    }

    struct Async {}
}

protocol State {}

extension State {
    typealias Action = Actions.Action<Self>
    typealias ActionCreator<T> = Actions.Creator<T, Self>
    typealias AsyncAction = Actions.Async
}

struct Count {
    var count: Int
}

extension Count: State {
    var increment: ActionCreator<Int> {
        .init { state, value in
            state.count += value
        }
    }

    var decrement: ActionCreator<Int> {
        .init { state, value in
            state.count += value
        }
    }
}

var count = Count(count: 1)
// count.send(\.increment)

protocol StatePublisher: ObservableObject {
    var cancellables: Set<AnyCancellable> { get }
    var state: State { get }
    var statePublished: Published<State> { get }
    var statePublisher: Published<State>.Publisher { get }
}

protocol ActionSender {
    associatedtype State

    var subject: PassthroughSubject<KeyPath<State, Any>, Never> { get }

    func send(_ action: KeyPath<State, Any>)
}

// extension ActionSender {
//    func send(_ action: Action) {
//        subject.send(action)
//    }
// }
//
// typealias Reducer<State, Action> = (inout State, Action) -> State
//
// final class Store<State: Equatable, Action: Equatable>: StatePublisher, ActionSender {
//    private(set) var cancellables: Set<AnyCancellable> = []
//    private(set) var subject: PassthroughSubject<Action, Never>
//    @Published private(set) var state: State
//    var statePublished: Published<State> { _state }
//    var statePublisher: Published<State>.Publisher { $state }
//
//    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
//        state = initialState
//        subject = PassthroughSubject<Action, Never>()
//        subject
//            .scan(initialState) { state, action in
//                var state = state
//                return reducer(&state, action)
//            }
//            .removeDuplicates()
//            .assign(to: \.state, on: self)
//            .store(in: &cancellables)
//    }
// }
//
// class StoreTests: XCTestCase {
//    func testInitialState() async {
//        let sut = makeSut()
//        let spy = PublisherSpy(sut.$state)
//        XCTAssertEqual(spy.values, [0])
//    }
//
//    func testActionsUpdateState() {
//        let sut = makeSut()
//        let spy = PublisherSpy(sut.$state)
//        sut.send(.decrement)
//        let anotherSpy = PublisherSpy(sut.$state)
//        sut.send(.increment)
//        XCTAssertEqual(spy.values, [0, -1, 0])
//        XCTAssertEqual(anotherSpy.values, [-1, 0])
//    }
// }
//
//// MARK: - Test Helpers
//
// private enum Action: String {
//    case increment
//    case decrement
// }
//
// private func reducer(state: inout Int, action: Action) -> Int {
//    switch action {
//    case .increment:
//        state += 1
//    case .decrement:
//        state -= 1
//    }
//    return state
// }
//
// private func makeSut(initialState: Int = 0) -> Store<Int, Action> {
//    Store(
//        initialState: initialState,
//        reducer: reducer(state:action:)
//    )
// }
//
// private class PublisherSpy<P: Publisher> {
//    private var cancellable: AnyCancellable!
//    private(set) var failure: P.Failure?
//    private(set) var isFinished = false
//    private(set) var values: [P.Output] = []
//
//    init(_ publisher: P) {
//        cancellable = publisher.sink(
//            receiveCompletion: { [weak self] completion in
//                switch completion {
//                case .finished:
//                    self?.isFinished = false
//                case let .failure(error):
//                    self?.failure = error
//                }
//            },
//            receiveValue: { [weak self] value in
//                self?.values.append(value)
//            }
//        )
//    }
// }
