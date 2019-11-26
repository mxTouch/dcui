//
//  DCUI
//

import DCFoundation

public class CacheVideoStorageProvider: CacheDiskProvider {

    override public subscript(key: String?) -> Data? {
        get {return super[key]}
        set {
            guard let data = newValue else {super[key] = newValue;return}
            guard let text = String(data: data, encoding: .utf8) else {super[key] = newValue;return}
            guard let url = URL(string: text) else {super[key] = newValue;return}
            if let path = path(key: key) {
                try? FileManager.default.copyItem(at: url, to: URL(fileURLWithPath: path))
            }
        }
    }
    
    override init() {
        super.init(fileExtension: "mp4")
    }
    
}
