//
//  ViewController.swift
//  TestApp
//
//  Created by Igor Danich on 26.10.16.
//  Copyright © 2016 Igor Danich. All rights reserved.
//

import DCUI

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        testVideo()
        
        
        
    }
    
    func testVideo() {
        let cache = Cache.initialize("Videos", options: CacheOptions(storage: CacheDiskProvider(fileExtension: "mp4"), converter: CacheVideoConverter()))
        
        let link = "https://r3---sn-25ge7nls.googlevideo.com/videoplayback?key=yt6&mt=1478541015&nh=IgpwcjAyLnBhcjAxKg03Mi4xNC4yMTguMTgz&sparams=dur%2Cei%2Cid%2Cinitcwndbps%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cnh%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cupn%2Cusequic%2Cexpire&ipbits=0&requiressl=yes&ratebypass=yes&source=youtube&mv=m&mime=video%2Fmp4&ms=au&dur=237.958&initcwndbps=6945000&id=o-AF9zG3H81T634hyZ7sltv6NDfcH0amX760xry0HdPpOM&pl=19&usequic=no&itag=22&mm=31&ip=62.210.36.218&mn=sn-25ge7nls&expire=1478562906&upn=4DuaiG6Vz_s&ei=-r8gWPiNKoz8ccHcn4AN&lmt=1472624086462590&signature=040A0F9FD1A5AE3606E6BFA752101D20CFE0BEFE.76C067179C8371508BB69F813FE2EE5E01898320&title=Ariana%20Grande%20-%20Side%20To%20Side%20ft%20Nicki%20Minaj"
        
        let task = cache.perform(key: link)
        task?.onUpdate = { (ready,total) in
            print(String(format: "%3.1f%%", (ready/total)*100.0))
            print(String(format: "%3.1f MB", ready/(1024.0*1024.0)), "/", String(format: "%3.1f MB", total/(1024.0*1024.0)))
        }
        task?.onComplete = { (object,_) in
            print((object as? Data)?.count ?? "")
        }
    }
    
    func testImages() {
        let images = [
            "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcR-hrJDg7M9_8N_eoLt1_7ji2WfY5O0S3fECqkIim1rN4mov6S-_VyiA6M5",
            "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcT-WdTmG2anS0rUgtQmcACe8pQ8dvN3Fh8iK_KI1cAV9V0SIggf",
            "https://www.planwallpaper.com/static/images/ZhGEqAP.jpg",
            //            "http://www.planwallpaper.com/static/images/wallpaper-photos-61.jpg",
            //            "https://images3.alphacoders.com/675/675273.jpg",
            //            "http://i.imgur.com/eWtfMME.png"
        ]
        
        Cache.initialize("Images", options: CacheOptions(converter: CacheImageConverter()))
        //        cache.options.storage?.clear()
        
        for _ in 0...100 {
            items << images[Int(arc4random()%UInt32(images.count))]
        }
    }
    
    // MARK - UICollectionViewDataSource, UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MediaCollectionViewCell = collectionView.dequeueReusableCell(identifier: "cell", indexPath: indexPath)
        cell.mediaView.indicatorColor = UIColor.red
        cell.mediaView.url = items[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

}

