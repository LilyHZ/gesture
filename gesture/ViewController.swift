//
//  ViewController.swift
//  gesture
//
//  手势识别(双击、捏、旋转、拖动、划动、长按）
//  滑动手势和拖手势冲突，两个选一个测试
//
//  Created by xly on 15-4-14.
//  Copyright (c) 2015年 Lily. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIActionSheetDelegate,UIAlertViewDelegate{

    @IBOutlet weak var im: UIImageView!
    
    var lasrScaleFactor:CGFloat = 1//放大、缩小
    var netRotation:CGFloat = 1;//旋转
    var netTranslation:CGPoint!//平移
    
    var images:NSArray = ["1.png","2.png","3.png","4.png","5.png","6.png"]//图片数组
    var imageIndex:Int = 0//数组下标
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        netTranslation = CGPoint(x: 0, y: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //许多控件,默认是不接受用户交互的
        im.userInteractionEnabled = true

        im.image = UIImage(named: images[imageIndex] as! String)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        //设置手势点击次数，双击：点2下
        tapGesture.numberOfTapsRequired = 2
        im.addGestureRecognizer(tapGesture)
//        self.view.addGestureRecognizer(tapGesture)
        
        //手势为捏的姿势:按住option按钮配合鼠标来做这个动作在虚拟器上
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinchGesture:")
        im.addGestureRecognizer(pinchGesture)
//        self.view.addGestureRecognizer(pinchGesture)
        
        //旋转手势:按住option按钮配合鼠标来做这个动作在虚拟器上 
        var rotateGesture = UIRotationGestureRecognizer(target: self, action: "handleRotateResture:")
        im.addGestureRecognizer(rotateGesture)
//        self.view.addGestureRecognizer(rotateGesture)
        
        //拖手势
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
//        im.addGestureRecognizer(panGesture)
//        self.view.addGestureRecognizer(panGesture)
        
        //滑动手势
        //右滑
        var swipeGestrue = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        im.addGestureRecognizer(swipeGestrue)
//        self.view.addGestureRecognizer(swipeGestrue)
        //左滑
        var swipeLeftGestrue = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGestrue.direction = UISwipeGestureRecognizerDirection.Left//不设置是右
        im.addGestureRecognizer(swipeLeftGestrue)
//        self.view.addGestureRecognizer(swipeLeftGestrue)
        
        //长按手势
        var longpressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongpressGesture:")
        //长按时间为1秒
        longpressGesture.minimumPressDuration = 1
        //允许5秒运动 指5秒之后开始调用方法longpressGesture
        longpressGesture.allowableMovement = 5
        //所需触摸一次
        longpressGesture.numberOfTouchesRequired = 1
        im.addGestureRecognizer(longpressGesture)
//        self.view.addGestureRecognizer(longpressGesture)
        
    }
    
//  双击屏幕时会调用此方法，放大和缩小图片
    func handleTapGesture(sender:UITapGestureRecognizer){
        println("双击")
        
        //判断imageView的内容模式是否是UIViewContentModeScaleAspectFit,该模式是原比例，按照图片原时比例显示大小 
        if im.contentMode == UIViewContentMode.ScaleAspectFit{
            //把imageView模式改成UIViewContentModeCenter，按照图片原先的大小显示中心的一部分在imageView
            im.contentMode = UIViewContentMode.Center
        }else{
            im.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
//  捏的手势，使图片放大和缩小，捏的动作是一个连续的动作
    func handlePinchGesture(sender:UIPinchGestureRecognizer){
        println("捏的手势，使图片放大和缩小")
        var factor = sender.scale
        if factor > 1{
            //图片放大
            im.transform = CGAffineTransformMakeScale(lasrScaleFactor+factor-1, lasrScaleFactor+factor-1)
        }else{
            //缩小
            im.transform = CGAffineTransformMakeScale(lasrScaleFactor*factor, lasrScaleFactor*factor)
        }
        
        //状态是否结束，如果结束保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            if factor > 1{
                lasrScaleFactor = lasrScaleFactor + factor - 1
            }else{
                lasrScaleFactor = lasrScaleFactor * factor
            }
        }
    }
//旋转手势
    func handleRotateResture(sender: UIRotationGestureRecognizer){
         println("旋转手势")
        //浮点类型，得到sender的旋转度数
        var rotation : CGFloat = sender.rotation
        //旋转角度CGAffineTransformMakeRotation,改变图像角度
        im.transform = CGAffineTransformMakeRotation(rotation+netRotation)
        //状态结束，保存数据
        if sender.state == UIGestureRecognizerState.Ended{
            netRotation += rotation
        }
    }
//  拖手势
    func handlePanGesture(sender:UIPanGestureRecognizer){
        println("拖手势")
        //得到拖的过程中的xy坐标
        var translation:CGPoint = sender.translationInView(im)
        //平移图片CGAffineTransformMakeTranslation
        im.transform = CGAffineTransformMakeTranslation(netTranslation.x + translation.x, netTranslation.y + translation.y)
        
        if sender.state == UIGestureRecognizerState.Ended{
            netTranslation.x += translation.x
            netTranslation.y += translation.y
        }
    }
//  滑动手势
    func handleSwipeGesture(sender:UISwipeGestureRecognizer){
        println("滑动手势")
        // 滑动的方向
        var direction = sender.direction
        //判断是上下左右
        switch(direction){
        case UISwipeGestureRecognizerDirection.Left:
            println("Left")
            imageIndex++
        case UISwipeGestureRecognizerDirection.Right:
            println("Right")
            imageIndex--
        case UISwipeGestureRecognizerDirection.Up:
            println("Up")
        case UISwipeGestureRecognizerDirection.Down:
            println("Down")
        default:
            break
        }
        
        //得到不越界不<0的下标
        imageIndex = imageIndex < 0 ? images.count - 1 : imageIndex % images.count
        
        //imageView显示图片
        im.image = UIImage(named: images[imageIndex] as! String)
    }
    
//  长按手势
    func handleLongpressGesture(sender:UILongPressGestureRecognizer){
        /*  //在tableView中哪行选择长按手势
        var point = sender.locationInView(self.tb)
        var indexPath:NSIndexPath = self.tb.indexPathForRowAtPoint(point)!
        
        if indexPath.isEqual(nil) {
            return
        }
        */

        println("长按手势")
        if sender.state == UIGestureRecognizerState.Began{
            
            var alertView = UIAlertView()
            alertView.title = "是否确认退出?"
            alertView.delegate = self
            alertView.addButtonWithTitle("是")
            alertView.addButtonWithTitle("否")
            
            alertView.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

