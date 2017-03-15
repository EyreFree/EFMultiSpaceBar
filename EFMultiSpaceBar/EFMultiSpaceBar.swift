//
//  EFMultiSpaceBar.swift
//  EFMultiSpaceBar
//
//  Created by EyreFree on 15/4/12.
//  Copyright (c) 2015 EyreFree. All rights reserved.
//

import UIKit
import QuartzCore

// 可动态变长分段数值显示条
class EFMultiSpaceBar: UIView {

    @IBOutlet var containerView: UIView!
    @IBOutlet var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!

    var rightLayer: CATextLayer = CATextLayer()
    var frontColors: NSArray!

    var perNow: CGFloat = CGFloat(0)

    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        Bundle.main.loadNibNamed("EFMultiSpaceBar", owner: self, options: nil)

        //添加主View到目标View
        self.addSubview(self.containerView)

        //添加右边那个会动的文字Layer
        rightLayer.string = "0"
        rightLayer.font = rightLabel.font
        rightLayer.fontSize = 16
        rightLayer.alignmentMode = kCAAlignmentRight
        rightLayer.foregroundColor = rightLabel.textColor.cgColor

        self.layer.addSublayer(rightLayer)
    }

    //设置细节
    func setDetail(_ title: String, backBGColor: UIColor, frontBGColors: NSArray, multi: CGFloat, width: CGFloat, height: CGFloat) {
        //设置文字
        leftLabel.text = title

        //设置颜色
        backView.backgroundColor = backBGColor
        frontColors = frontBGColors
        frontView.backgroundColor = frontBGColors[0] as? UIColor

        //设置大小
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: height)

        //设置Layer位置
        rightLayer.position = rightLabel.layer.position
        rightLayer.bounds = rightLabel.bounds

        //切成几条
        cutWithPoints(backView, number: multi)
    }

    //直接设置内部宽度
    func setContentWidth(_ percentage: CGFloat) {
        if percentage >= 0 && percentage <= 100 {
            let ori: CGRect = backView.frame
            frontView.frame = CGRect(x: 0, y: 0, width: backView.frame.width / 100 * percentage, height: ori.height)
        }
    }

    func changePercentage(_ percentage: CGFloat) {
        if percentage >= 0 && percentage <= 100 && (percentage != perNow) {
            changeLabelAnimation(percentage)
            changeWidthAnimation(percentage)
        }
    }

    //动画改变内部宽度
    func changeWidthAnimation(_ percentage: CGFloat) {
        let ori: CGRect = backView.frame

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        UIView.setAnimationDelegate(self)
        frontView.frame = CGRect(x: 0, y: 0, width: backView.frame.width / 100 * percentage, height: ori.height)
        UIView.commitAnimations()
    }

    //动画改变Label内容
    func changeLabelAnimation(_ percentage: CGFloat) {
        //这是右上角的数字
        let keyAnima: CAKeyframeAnimation = CAKeyframeAnimation()
        keyAnima.keyPath = "string"
        keyAnima.values = [Any]()
        //这是会动的内容物
        let keyAnimaColor: CAKeyframeAnimation = CAKeyframeAnimation()
        keyAnimaColor.keyPath = "backgroundColor"
        keyAnimaColor.values = [Any]()

        if (percentage - perNow) > 0 {
            while perNow < percentage {
                perNow = perNow + 1
                keyAnimaColor.values?.append(changePerNow(perNow).cgColor)
                keyAnima.values?.append(NSString(format: "%.0lf", Double(perNow)))
            }
        } else {
            while perNow > percentage {
                perNow = perNow - 1
                keyAnimaColor.values?.append(changePerNow(perNow).cgColor)
                keyAnima.values?.append(NSString(format: "%.0lf", Double(perNow)))
            }
        }

        //这是右上角的数字
        keyAnima.duration = 1.0
        //keyAnima.delegate = self
        keyAnima.isRemovedOnCompletion = false
        keyAnima.fillMode = kCAFillModeForwards
        rightLayer.add(keyAnima, forKey: "rightLayer")
        rightLayer.string = NSString(format:"%.0lf", Double(percentage))
        //这是会动的内容物
        keyAnimaColor.duration = 1.0
        //keyAnimaColor.delegate = self
        keyAnimaColor.isRemovedOnCompletion = false
        keyAnimaColor.fillMode = kCAFillModeForwards
        frontView.layer.add(keyAnimaColor, forKey: "frontView")
        frontView.layer.backgroundColor = changePerNow(percentage).cgColor
    }

    //剪切
    fileprivate func cutWithPoints(_ view:UIView, number:CGFloat) {
        //切块
        if 1 < number {
            //间距
            let margin = 2 as CGFloat

            //拆分
            let step: CGFloat = self.frame.width / number
            let height: CGFloat = view.frame.height

            //遮罩
            let maskLayer = CAShapeLayer()
            let path = CGMutablePath()

            if number > 0 {
                for index in 0 ..< Int(number) {
                    let i = CGFloat(index)
                    path.addRect(
                        CGRect(
                            x: step * i,
                            y: 0,
                            width: step - ((i + 1) == number ? 0 : margin),
                            height: height
                        )
                    )
                }
            }
            maskLayer.path = path
            view.layer.mask = maskLayer
        }

        //圆角矩形
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 3.0
        view.layer.borderWidth = 0.0
    }

    func changePerNow(_ newPercentage: CGFloat) -> UIColor {
        if newPercentage < 60 {
            return frontColors[0] as! UIColor
        } else if newPercentage >= 85 {
            return frontColors[2] as! UIColor
        }
        return frontColors[1] as! UIColor
    }
}
