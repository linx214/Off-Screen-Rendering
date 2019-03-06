#1. 什么是离屏渲染
---
三种不同的渲染方式：屏幕渲染、离屏渲染和CPU渲染。
屏幕渲染，在用于显示的屏幕缓冲区中进行，不需要额外创建新的缓存，也不需要开启新的上下文，所以性能较好，但是收到缓存大小限制等因素，一些复杂的操作无法完成。
离屏渲染，指的是在GPU的当前屏幕缓冲区外开辟新的缓冲区进行操作。
离屏渲染的过程分解：
	a. 创建新的缓冲区
	b. 切换上下文到离屏缓冲区**(消耗资源较大)**
	c. 在离屏缓冲区进行渲染
	d. 切换上下文到显示屏幕上**(消耗资源较大)**
	e. 将离屏缓冲区的渲染结果显示到屏幕上

#2. 如何制造一个离屏渲染
---
a. 创建一个UITableView，设置其Cell固定row有2000个。
b. Cell的里面创建一个UIImageView数组，每个UIImageView固定加载同一张图片，在布局的时候，每张图片大小比之前一张图片的size减1，形成汉诺塔的叠加样子
![image.png](https://upload-images.jianshu.io/upload_images/1627220-cbb8c0fd5ce462bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
c. 开启UIImageView的光栅化，这样整张UIImage显示的图片都将成为离屏渲染的区域
![IMG_0005.png](https://upload-images.jianshu.io/upload_images/1627220-6d23b69e909b87a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
我们最终在手机上得到的效果：
![IMG_0006.png](https://upload-images.jianshu.io/upload_images/1627220-a84bbceedfd5f7b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

ViewController代码如下：
```
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
```

demo工程地址：
https://github.com/linx214/Off-Screen-Rendering.git

在Instuments中调试工程

![image.png](https://upload-images.jianshu.io/upload_images/1627220-2da9d363c577be6b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
Touch5，真机调试，在cell滑动时，最大帧数3帧，GPU利用率92%~95%，CPU利用率平均在6%
#3. 如何优化离屏渲染
---

#4. 结语
---

---
参考文章：
https://objccn.io/issue-3-1/
