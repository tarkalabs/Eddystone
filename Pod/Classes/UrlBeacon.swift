class UrlBeacon: Beacon {
    
    //MARK: Properties
    var url: NSURL
    
    init(url: NSURL, rssi: Double, txPower: Int) {
        self.url = url
        
        super.init(rssi: rssi, txPower: txPower)
    }
    
    override class func beaconWithBytes(bytes: [Int], rssi: Double, txPower: Int) -> UrlBeacon? {
        
        var urlString = ""
        
        for (offset, byte) in enumerate(bytes) {
            switch offset {
            case 2:
                if byte < Beacon.schemePrefixes.count {
                    urlString += Beacon.schemePrefixes[byte]
                }
            case 3...bytes.count-1:
                if byte < Beacon.urlEncodings.count {
                    urlString += Beacon.urlEncodings[byte]
                } else {
                    var unicode = UnicodeScalar(byte)
                    var character = Character(unicode)
                    urlString.append(character)
                }
            default:
                break
            }

        }
        
        if let url = NSURL(string: urlString) {
            return UrlBeacon(url: url, rssi: rssi, txPower: txPower)
        }
        
        return nil
        
    }
    
}