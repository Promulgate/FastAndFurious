@objc protocol RaceTrackObservable {
    func racecarsDidMove(distancesForIdentifiers: [String: Float])
}

class RaceTrack: NSObject {

    enum RaceStatus {
        case unstarted
        case started
        case ended
    }

    // Raceables
    let racecars: [FFRaceable]
    let trackLength: Float
    // observer
    weak var observer: RaceTrackObservable?

    fileprivate var timer: Timer?
    fileprivate var distancesForIdentifiers: [String: Float] = [:]
    fileprivate var status: RaceStatus = .unstarted
    fileprivate let timeInterval = 0.15

    init(racecars: [FFRaceable],
         trackLength: Float,
         observer: RaceTrackObservable) {
        self.racecars = racecars
        self.trackLength = trackLength
        self.observer = observer
        super.init()
        reset()
    }


    func startRace() {
        //Timer
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(updateDistances),
                                     userInfo: nil,
                                     repeats: true)
        
        status = .started
    }

    func endRace() {
        status = .ended
        timer?.invalidate()
        timer = nil
    }

    var winnerExists: Bool {
        return !distancesForIdentifiers.values
            .filter { $0 >= 1 /*self.trackLength*/ }
            .isEmpty
    }

    var winnersIdentifier: String? {
        guard winnerExists else { return nil }
        return distancesForIdentifiers.map { $0 }
            .filter { $0.value >= self.trackLength }
            .sorted { $0.1 < $1.1 }
            .first?
            .key
    }

    @objc fileprivate func updateDistances() {
        guard status != .ended else { return }

        for car in racecars {
            guard let currentDistance = distancesForIdentifiers[car.racecarID]
                else { fatalError("Distances should exist for all cars") }
            distancesForIdentifiers[car.racecarID] = generateNewDistance(for: car) + currentDistance
        }

        if winnerExists {
            endRace()
        }

        observer?.racecarsDidMove(distancesForIdentifiers: distancesForIdentifiers)
    }

    func reset() {
        if status == .started {
            endRace()
        }
        status = .unstarted

        distancesForIdentifiers.removeAll(keepingCapacity: true)
        for car in racecars {
            distancesForIdentifiers[car.racecarID] = 0
        }
    }

    fileprivate func generateNewDistance(for car: FFRaceable) -> Float {

        enum VariabilityLevel: Float {
            case low = 0.9
            case med = 0.8
            case high = 0.7

            static func randomVariability() -> VariabilityLevel {
                switch arc4random_uniform(10) {
                case 0...3: return .high
                case 4...7: return .med
                case 8...9: return .low
                default: return .high
                }
            }
        }

        return car.topSpeed / 10
            * car.durability / 100
            * VariabilityLevel.randomVariability().rawValue
    }
}
