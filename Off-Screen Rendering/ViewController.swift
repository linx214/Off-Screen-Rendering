//
//  ViewController.swift
//  Off-Screen Rendering
//
//  Created by linx on 2019/3/5.
//  Copyright © 2019 haoyicn. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    class CellView: UITableViewCell {
        static var reuseIdentifier: String { 
            return "ViewController.CellView"
        }
        var contentImageViews = [UIImageView]()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            setupUI()
            configUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
        
        func setupUI() {  
            let imagesCount = 50
            let baseInset = 30
            (0 ..< imagesCount).forEach { i in 
                let imageView = UIImageView(image: UIImage(named: "image"))
                contentImageViews.append(imageView) 
                addSubview(imageView)
                imageView.snp.makeConstraints({ (make) in
                    make.center.equalTo(self)
                    make.size.equalTo(self).inset(baseInset + i)
                })
            }
        }
        
        func configUI() {
            contentImageViews.forEach {
                $0.layer.shouldRasterize = true
                $0.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupUI()
        configUI()
    }
    
    func setupUI() {
        [tableView].forEach { view.addSubview($0) }
        tableView.snp.makeConstraints { (make) in
            make.center.size.equalTo(self.view)
        }
    }
    
    func configUI() {
        tableView.dataSource = self
        tableView.register(CellView.classForCoder(), forCellReuseIdentifier: CellView.reuseIdentifier)

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2000
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellView.reuseIdentifier, for: indexPath) as! CellView
        
        return cell
    }
}

