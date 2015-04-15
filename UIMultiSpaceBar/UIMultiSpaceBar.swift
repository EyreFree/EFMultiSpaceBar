//
//  MultiSpaceBar.swift
//  fourTiaoZhuangWu
//
//  Created by EyreFree on 15/4/12.
//  Copyright (c) 2015 EyreFree. All rights reserved.
//

import UIKit
import QuartzCore

// 可动态变长分段数值显示条
class UIMultiSpaceBar:UIView
{
    @IBOutlet var containerView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    var rightLayer:CATextLayer = CATextLayer()
    var frontColors:NSArray!
    
    var perNow:CGFloat = CGFloat(0)
    
    //这好像是一个初始化
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("UIMultiSpaceBar", owner: self, options: nil)
        
        //添加主View到目标View
        self.addSubview(self.containerView)
        
        //添加右边那个会动的文字Layer
        rightLayer.string = "0";
        rightLayer.font = rightLabel.font
        rightLayer.fontSize = 16
        rightLayer.alignmentMode = kCAAlignmentRight
        rightLayer.foregroundColor = rightLabel.textColor.CGColor
        
        self.layer.addSublayer(rightLayer)
    }
    
    //设置细节
    func setDetail(title:String, backBGColor:UIColor, frontBGColors:NSArray, multi:CGFloat, width:CGFloat, height:CGFloat)
    {
        //设置文字
        leftLabel.text = title
        
        //设置颜色
        backView.backgroundColor = backBGColor
        frontColors = frontBGColors
        frontView.backgroundColor = frontBGColors[0] as UIColor
        
        //设置大小
        containerView.frame = CGRectMake(0, 0, width, height)
        
        //设置Layer位置
        rightLayer.position = rightLabel.layer.position
        rightLayer.bounds = rightLabel.bounds
        
        //切成几条
        cutWithPoints(backView, number: multi)
    }
    
    //直接设置内部宽度
    func setContentWidth(percentage:CGFloat)
    {
        if(percentage >= 0 && percentage <= 100)
        {
            var ori:CGRect = backView.frame
            frontView.frame = CGRectMake(0, 0, backView.frame.width / 100 * percentage, ori.height)
        }
    }
    
    func changePercentage(percentage:CGFloat)
    {
        if(percentage >= 0 && percentage <= 100 && (percentage != perNow))
        {
            changeLabelAnimation(percentage)
            changeWidthAnimation(percentage)
        }
    }
    
    //动画改变内部宽度
    func changeWidthAnimation(percentage:CGFloat)
    {
        var ori:CGRect = backView.frame

        UIView.beginAnimations(nil, context:nil)
        UIView.setAnimationDuration(1)
        UIView.setAnimationDelegate(self)
        frontView.frame = CGRectMake(0, 0, backView.frame.width / 100 * percentage, ori.height)
        UIView.commitAnimations()
    }
    
    //动画改变Label内容
    func changeLabelAnimation(percentage:CGFloat)
    {
        //这是右上角的数字
        var keyAnima:CAKeyframeAnimation = CAKeyframeAnimation()
        keyAnima.keyPath = "string"
        keyAnima.values = NSMutableArray()
        //这是会动的内容物
        var keyAnimaColor:CAKeyframeAnimation = CAKeyframeAnimation()
        keyAnimaColor.keyPath = "backgroundColor"
        keyAnimaColor.values = NSMutableArray()

        if((percentage - perNow) > 0)
        {
            for(; perNow < percentage; 0)
            {
                keyAnimaColor.values.append(changePerNow(++perNow).CGColor)
                keyAnima.values.append(NSString(format:"%.0lf", Double(perNow)))
            }
        }
        else
        {
            for(; perNow > percentage; 0)
            {
                keyAnimaColor.values.append(changePerNow(--perNow).CGColor)
                keyAnima.values.append(NSString(format:"%.0lf", Double(perNow)))
            }
        }

        //这是右上角的数字
        keyAnima.duration = 1.0
        keyAnima.delegate = self
        keyAnima.removedOnCompletion = false
        keyAnima.fillMode = kCAFillModeForwards
        rightLayer.addAnimation(keyAnima, forKey: "rightLayer")
        rightLayer.string = NSString(format:"%.0lf", Double(percentage))
        //这是会动的内容物
        keyAnimaColor.duration = 1.0
        keyAnimaColor.delegate = self
        keyAnimaColor.removedOnCompletion = false
        keyAnimaColor.fillMode = kCAFillModeForwards
        frontView.layer.addAnimation(keyAnimaColor, forKey: "frontView")
        frontView.layer.backgroundColor = changePerNow(percentage).CGColor
    }
    
    //剪切
    private func cutWithPoints(view:UIView, number:CGFloat)
    {
        //切块
        if(1 < number)
        {
            //间距
            var margin = 2 as CGFloat
            
            //拆分
            var step:CGFloat = view.frame.width / number
            var height:CGFloat = view.frame.height
            
            //遮罩
            var maskLayer = CAShapeLayer()
            var path = CGPathCreateMutable()
            for(var i = 0 as CGFloat; i < number; ++i)
            {
                CGPathAddRect(path, nil, CGRectMake(step * i, 0, step - ((i + 1) == number ? 0 : margin), height))
            }
            maskLayer.path = path
            view.layer.mask = maskLayer
        }
        
        //圆角矩形
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 0.0
    }

    func changePerNow(newPercentage:CGFloat)->UIColor
    {
        if(newPercentage < 60)
        {
            return frontColors[0] as UIColor
        }
        else if(newPercentage >= 85)
        {
            return frontColors[2] as UIColor
        }
        return frontColors[1] as UIColor
    }
}