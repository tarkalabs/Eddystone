import CoreBluetooth

public class Beacon {
    
    //MARK: Constants
    static let schemePrefixes = [
        "http://www.",
        "https:/www.",
        "http://",
        "https://"
    ]
    
    static let urlEncodings = [
        ".com/",
        ".org/",
        ".edu/",
        ".net/",
        ".info/",
        ".biz/",
        ".gov/",
        ".com",
        ".org",
        ".edu",
        ".net",
        ".info",
        ".biz",
        ".gov"
    ]
    
    //MARK: Enumerations
    enum Type {
        case URL, UID, TLM
    }
    
    public enum SignalStrength: Int {
        case Excellent = 6
        case VeryGood = 5
        case Good = 4
        case Low = 3
        case VeryLow = 2
        case NoSignal = 1
        case Unknown = 0
    }
    
    //MARK: Properties
    var delegate: BeaconDelegate?
    
    var txPower: Int
    
    var rssi: Double
    var previousRssis = [Double]()
    
    var accuracy: Double {
        get {
            return Beacon.calculateAccuracy(txPower: self.txPower, rssi: self.rssi)
        }
    }
    var signalStrength: SignalStrength = .Unknown {
        didSet {
            self.notifyChange()
        }
    }
    
    //MARK: Initializations
    init(rssi: Double, txPower: Int) {
        self.rssi = rssi
        self.txPower = txPower
    }
    
    //MARK: Functions
    func updateRssi(newRssi: Double) -> Bool {
        var rssis = [Double]()
        rssis.append(newRssi)
        
        let max = 20
        for (index, previousRssi) in enumerate(self.previousRssis) {
            if index < max - 1 {
                rssis.append(previousRssi)
            }
        }
        
        var totalRssi: Double = 0
        for rssi in rssis {
            totalRssi += rssi
        }
        
        var average: Double = totalRssi / Double(rssis.count)
        
        self.rssi = average
        
        self.previousRssis = rssis
        
        var signalStrength = Beacon.calculateSignalStrength(self.accuracy)
        
        if signalStrength != self.signalStrength {
            self.signalStrength = signalStrength
        }
        
        return false
    }
    
    class func calculateAccuracy(#txPower: Int, rssi: Double) -> Double {
        
        
        if rssi == 0 {
            return 0
        }
        
        var ratio: Double = rssi / Double(txPower)
        if ratio < 1 {
            return pow(ratio, 10)
        } else {
            return 0.89976 * pow(ratio, 7.7095) + 0.111
        }
        
    }
    
    class func calculateSignalStrength(accuracy: Double) -> SignalStrength {
        
        switch accuracy {
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
    
    func notifyChange() {
        self.delegate?.beaconDidChange()
    }

    
    //MARK: Class
    class func beaconWithBytes(bytes: [Int], rssi: Double, txPower: Int) -> Beacon? {
        //fix with protocol methods in Swift 2.0
        
        return nil
    }
    
    class func beaconWithAdvertisementData(advertisementData: [NSObject : AnyObject], rssi: Double) -> Beacon? {
        
        var txPower: Int?
        var url: NSURL?
        var type: Type?

        if let serviceData = advertisementData[CBAdvertisementDataServiceDataKey] as? [NSObject: AnyObject] {
            if let urlData = serviceData[Scanner.eddystoneServiceUUID] as? NSData {
                
                let count = urlData.length / sizeof(Int8)
                var rawBytes = [Int8](count: count, repeatedValue: 0)
                urlData.getBytes(&rawBytes, length:count * sizeof(Int8))
                
                var urlString = ""
                
                var bytes = [Int]()
                for rawByte in rawBytes {
                    bytes.append(Int(rawByte))
                }
                
                var offset = 0
                for byte in bytes {
                    
                    switch offset {
                    case 0:
                        switch byte {
                        case 0:
                            type = .UID
                        case 16:
                            type = .URL
                        case 32:
                            type = .TLM
                        default:
                            break
                        }
                        
                    case 1:
                        txPower = byte
                        
                    default: break
                    }
                    
                    offset++
                }
                
                if let type = type, txPower = txPower {
                    
                    switch type {
                    case .URL:
                        return UrlBeacon.beaconWithBytes(bytes, rssi: rssi, txPower: txPower)
                    case .UID:
                        log("UID Beacon not yet supported")
                    case .TLM:
                        log("TLM Beacon not yet supported")
                    }

                }
                
            }
        }
        
        return nil
    }
    
}

protocol BeaconDelegate {
    
    func beaconDidChange()
    
}