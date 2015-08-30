import CoreBluetooth

public class Beacon {
    
    //MARK: Enumerations
    public enum SignalStrength: Int {
        case Excellent
        case VeryGood
        case Good
        case Low
        case VeryLow
        case NoSignal
        case Unknown
    }
    
    //MARK: Frames
    var frames: (
        url: UrlFrame?,
        uid: UidFrame?,
        tlm: TlmFrame?
    ) = (nil,nil,nil)
    
    //MARK: Properties
    var txPower: Int
    var identifier: String
    var rssi: Double {
        get {
            var totalRssi: Double = 0
            for rssi in self.rssiBuffer {
                totalRssi += rssi
            }
            
            let average: Double = totalRssi / Double(self.rssiBuffer.count)
            return average
        }
    }
    var signalStrength: SignalStrength = .Unknown
    var rssiBuffer = [Double]()
    var distance: Double {
        get {
            return Beacon.calculateAccuracy(txPower: self.txPower, rssi: self.rssi)
        }
    }
    
    //MARK: Initializations
    init(rssi: Double, txPower: Int, identifier: String) {
        self.txPower = txPower
        self.identifier = identifier
        
        self.updateRssi(rssi)
    }
    
    //MARK: Delegate
    var delegate: BeaconDelegate?
    func notifyChange() {
        self.delegate?.beaconDidChange()
    }
    
    //MARK: Functions
    func updateRssi(newRssi: Double) -> Bool {
        self.rssiBuffer.insert(newRssi, atIndex: 0)
        if self.rssiBuffer.count >= 20 {
            self.rssiBuffer.removeLast()
        }
        
        let signalStrength = Beacon.calculateSignalStrength(self.distance)
        if signalStrength != self.signalStrength {
            self.signalStrength = signalStrength
            self.notifyChange()
        }
        
        return false
    }
    
    //MARK: Calculations
    class func calculateAccuracy(txPower txPower: Int, rssi: Double) -> Double {
        if rssi == 0 {
            return 0
        }
        
        let ratio: Double = rssi / Double(txPower)
        if ratio < 1 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
        
    }
    
    class func calculateSignalStrength(distance: Double) -> SignalStrength {
        switch distance {
        case 0...24999:
            return .Excellent
        case 25000...49999:
            return .VeryGood
        case 50000...74999:
            return .Good
        case 75000...99999:
            return .Low
        default:
            return .VeryLow
        }
    }

    //MARK: Advertisement Data
    func parseAdvertisementData(advertisementData: [NSObject : AnyObject], rssi: Double) {
        self.updateRssi(rssi)
        
        if let bytes = Beacon.bytesFromAdvertisementData(advertisementData) {
            if let type = Beacon.frameTypeFromBytes(bytes) {
                switch type {
                case .URL:
                    if let frame = UrlFrame.frameWithBytes(bytes) {
                        if frame.url != self.frames.url?.url {
                            self.frames.url = frame
                            log("Parsed URL Frame with url: \(frame.url)")
                            self.notifyChange()
                        }
                    }
                case .UID:
                    if let frame = UidFrame.frameWithBytes(bytes) {
                        if frame.uid != self.frames.uid?.uid {
                            self.frames.uid = frame
                            log("Parsed UID Frame with uid: \(frame.uid)")
                            self.notifyChange()
                        }
                    }
                case .TLM:
                    if let frame = TlmFrame.frameWithBytes(bytes) {
                        self.frames.tlm = frame
                        log("Parsed TLM Frame with battery: \(frame.batteryVolts) temperature: \(frame.temperature) advertisement count: \(frame.advertisementCount) on time: \(frame.onTime)")
                        self.notifyChange()
                    }
                }
            }
        }
    }
    
    //MARK: Bytes
    class func beaconWithAdvertisementData(advertisementData: [NSObject : AnyObject], rssi: Double, identifier: String) -> Beacon? {
        var txPower: Int?
        var url: NSURL?
        var type: FrameType?

        if let bytes = Beacon.bytesFromAdvertisementData(advertisementData) {
            type = Beacon.frameTypeFromBytes(bytes)
            txPower = Beacon.txPowerFromBytes(bytes)
            
            if let type = type, txPower = txPower {
                let beacon = Beacon(rssi: rssi, txPower: txPower, identifier: identifier)
                beacon.parseAdvertisementData(advertisementData, rssi: rssi)
                return beacon
            }
            
        }
        
        return nil
    }
    
    class func bytesFromAdvertisementData(advertisementData: [NSObject : AnyObject]) -> [Byte]? {
        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [NSObject: AnyObject] {
            if let urlData = serviceData[Scanner.eddystoneServiceUUID] as? NSData {
                let count = urlData.length / sizeof(UInt8)
                var bytes = [UInt8](count: count, repeatedValue: 0)
                urlData.getBytes(&bytes, length:count * sizeof(UInt8))
                return bytes.map { byte in
                    return Byte(byte)
                }
            }
        }
        
        return nil
    }
    
    class func frameTypeFromBytes(bytes: [Byte]) -> FrameType? {
        if bytes.count >= 1 {
            switch bytes[0] {
            case 0:
                return .UID
            case 16:
                return .URL
            case 32:
                return .TLM
            default:
                break
            }
        }
        
        return nil
    }
    
    class func txPowerFromBytes(bytes: [Byte]) -> Int? {
        if bytes.count >= 2 {
            if let type = Beacon.frameTypeFromBytes(bytes) {
                if type == .UID || type == .URL {
                    return Int(bytes[1])
                }
            }
        }
        
        return nil
    }
}

protocol BeaconDelegate {
    func beaconDidChange()
}