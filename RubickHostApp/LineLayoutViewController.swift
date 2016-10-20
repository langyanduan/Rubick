//
//  LineLayoutViewController.swift
//  Rubick
//
//  Created by WuFan on 2016/10/20.
//
//

import UIKit
import Rubick

class LineLayoutViewController: UIViewController {
    
    var contentView: UIView!
    
    var type: Int = 0
    
    @IBOutlet weak var switchButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        edgesForExtendedLayout = []
        handlePressedSwitch()
    }
    
    @IBAction func handlePressedSwitch() {
        switch type {
        case 0:
           layout0()
        case 1:
           layout1()
        case 2:
           layout2()
        case 3:
           layout3()
        case 4:
           layout4()
        default:
            break
        }
        
        type = (type + 1) % 5
    }
    
    func layout0() {
        contentView?.removeFromSuperview()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        view.addSubview(contentView)
        activateLayoutConstraints([
            contentView.top == view.top,
            contentView.bottom == view.bottom,
            contentView.left == view.left,
            contentView.right == view.right,
        ])
        
        let v1 = UIView()
        v1.backgroundColor = .red
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        
        let v4 = UIView()
        v4.backgroundColor = .black
        
        let v5 = UIView()
        v5.backgroundColor = .brown
        
        contentView.addSubview(v1)
        contentView.addSubview(v2)
        contentView.addSubview(v3)
        contentView.addSubview(v4)
        contentView.addSubview(v5)
        
        let options: [LineLayoutOption] = [
            .alignCenter(to: contentView),
            .widthEqual(to: 40)
        ]
        
        activateVerticalLayout(in: contentView, options: options, items: [
            ==40, v1 == 20, ==20, v2 == 10, ==5, v3 == v4, v4, v5 == 50
        ])
    }
    
    func layout1() {
        contentView?.removeFromSuperview()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        view.addSubview(contentView)
        activateLayoutConstraints([
            contentView.top == view.top,
            contentView.bottom == view.bottom,
            contentView.left == view.left,
            contentView.right == view.right,
        ])
        
        let v1 = UIView()
        v1.backgroundColor = .red
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        
        let v4 = UIView()
        v4.backgroundColor = .black
        
        let v5 = UIView()
        v5.backgroundColor = .brown
        
        contentView.addSubview(v1)
        contentView.addSubview(v2)
        contentView.addSubview(v3)
        contentView.addSubview(v4)
        contentView.addSubview(v5)
        
        let options: [LineLayoutOption] = [
            .alignHead(to: contentView),
        ]
        
        activateLayoutConstraints([
            v1.width == 20,
            v2.width == 10,
            v3.width == 80,
            v4.width == 30,
            v5.width == 100,
        ])
        
        activateVerticalLayout(in: contentView, options: options, items: [
            ==40, v1 == 20, ==20, v2 == 10, ==5, v3 == v4, v4, v5 == 50
        ])
    }
    
    func layout2() {
        contentView?.removeFromSuperview()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        view.addSubview(contentView)
        activateLayoutConstraints([
            contentView.top == view.top,
            contentView.bottom == view.bottom,
            contentView.left == view.left,
            contentView.right == view.right,
        ])
        
        let v1 = UIView()
        v1.backgroundColor = .red
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        
        let v4 = UIView()
        v4.backgroundColor = .black
        
        let v5 = UIView()
        v5.backgroundColor = .brown
        
        contentView.addSubview(v1)
        contentView.addSubview(v2)
        contentView.addSubview(v3)
        contentView.addSubview(v4)
        contentView.addSubview(v5)
        
        let options: [LineLayoutOption] = [
            .alignHead(to: contentView),
            .alignCenter(to: contentView),
        ]
        
        activateVerticalLayout(in: contentView, options: options, items: [
            ==40, v1 == 20, ==20, v2 == 10, ==5, v3 == v4, v4, v5 == 50
        ])
    }
    func layout3() {
        contentView?.removeFromSuperview()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        view.addSubview(contentView)
        activateLayoutConstraints([
            contentView.top == view.top,
            contentView.bottom == view.bottom,
            contentView.left == view.left,
            contentView.right == view.right,
        ])
        
        let v1 = UIView()
        v1.backgroundColor = .red
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        
        let v4 = UIView()
        v4.backgroundColor = .black
        
        let v5 = UIView()
        v5.backgroundColor = .brown
        
        contentView.addSubview(v1)
        contentView.addSubview(v2)
        contentView.addSubview(v3)
        contentView.addSubview(v4)
        contentView.addSubview(v5)
        
        let options: [LineLayoutOption] = [
            .alignTail(to: contentView),
            .widthEqual(to: switchButton),
        ]
        
        activateVerticalLayout(in: contentView, options: options, items: [
            ==40, v1 == 20, ==20, v2 == 10, ==5, v3 == v4, v4, v5 == 50
        ])
    }
    func layout4() {
        contentView?.removeFromSuperview()
        contentView = UIView()
        contentView.isUserInteractionEnabled = false
        view.addSubview(contentView)
        activateLayoutConstraints([
            contentView.top == view.top,
            contentView.bottom == view.bottom,
            contentView.left == view.left,
            contentView.right == view.right,
        ])
        
        let v1 = UIView()
        v1.backgroundColor = .red
        
        let v2 = UIView()
        v2.backgroundColor = .blue
        
        let v3 = UIView()
        v3.backgroundColor = .yellow
        
        let v4 = UIView()
        v4.backgroundColor = .black
        
        let v5 = UIView()
        v5.backgroundColor = .brown
        
        contentView.addSubview(v1)
        contentView.addSubview(v2)
        contentView.addSubview(v3)
        contentView.addSubview(v4)
        contentView.addSubview(v5)
        
        let options: [LineLayoutOption] = [
            .alignTail(to: contentView),
            .widthEqual(to: switchButton),
            .heightEqual(to: 60),
        ]
        
        activateVerticalLayout(in: contentView, options: options, items: [
            ==40, v1, ==20, v2, ==5, v3, v4, v5, >=30
        ])
    }
}
