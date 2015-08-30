public class Object: Equatable {
    
    //MARK: Properties
    private(set) public var signalStrength: Beacon.SignalStrength
    private(set) public var identifier: String
    
    private(set) public var battery: Double?
    private(set) public var temperature: Double?
    private(set) public var advertisementCount: Int?
    private(set) public var onTime: NSTimeInterval?
    private(set) public var beacon: Beacon
    //MARK: Initilizations
    init (signalStrength: Beacon.SignalStrength, identifier: String, beacon: Beacon) {
        self.beacon = beacon
        self.signalStrength = signalStrength
        self.identifier = identifier
    }
    
    func parseTlmFrame(frame: TlmFrame) {
        self.battery = Object.batteryLevelInPercent(frame.batteryVolts)
        self.temperature = frame.temperature
        self.advertisementCount = frame.advertisementCount
        self.onTime = NSTimeInterval(frame.onTime)
    }
    
    //MARK: Class
    class func batteryLevelInPercent(mvolts: Int) -> Double
    {
        var batteryLevel: Double
        let mvoltsDouble = Double(mvolts)
        
        if (mvolts >= 3000) {
            batteryLevel = 100
        } else if (mvolts > 2900) {
            batteryLevel = 100 - ((3000 - mvoltsDouble) * 58) / 100
        } else if (mvolts > 2740) {
            batteryLevel = 42 - ((2900 - mvoltsDouble) * 24) / 160
        } else if (mvolts > 2440) {
            batteryLevel = 18 - ((2740 - mvoltsDouble) * 12) / 300
        } else if (mvolts > 2100) {
            batteryLevel = 6 - ((2440 - mvoltsDouble) * 6) / 340
        } else {
            batteryLevel = 0
        }
        
        return batteryLevel
    }
    
}

public func ==(lhs: Object, rhs: Object) -> Bool {
    return lhs.identifier == rhs.identifier
}