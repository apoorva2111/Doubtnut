//
//  LandingpageVC.swift
//  doubtnut
//
//  Created by Apoorva Gangrade on 04/03/21.
//

import UIKit

class LandingpageVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollview: UIScrollView!{
        didSet{
            scrollview.delegate = self
        }
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(identifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        let vc = FlowController().instantiateViewController(identifier: "LoginwithPincode", storyBoard: "Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBOutlet weak var pageControl: UIPageControl!
   
    let nibNamewalkthrough = "LandingPageSlider"
    var walkthroughslides:[LandingPageSlider] = [];

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setView()
    }
    func setView(){
        pageControl.numberOfPages = walkthroughslides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        walkthroughslides = createSlides()
        setupSlideScrollView(slides: walkthroughslides)

        Timer.scheduledTimer(timeInterval: 5.0,
        target: self,
        selector: #selector(LandingpageVC.update),
        userInfo: nil,
        repeats: true)
        
    }
    
    @objc func update() {
                
        let pageWidth:CGFloat = self.scrollview.frame.width
        let maxWidth:CGFloat = pageWidth * 2
        let contentOffset:CGFloat = self.scrollview.contentOffset.x
                
        var slideToX = contentOffset + pageWidth
                
        if  contentOffset + pageWidth == maxWidth
        {
              slideToX = 0
        }
        self.scrollview.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollview.frame.height), animated: true)
    }
  
    func createSlides() -> [LandingPageSlider] {
        let slide1:LandingPageSlider = Bundle.main.loadNibNamed(nibNamewalkthrough, owner: self, options: nil)?.first as! LandingPageSlider
        slide1.imgView.image = UIImage(named: "Slider")
        
        let slide2:LandingPageSlider = Bundle.main.loadNibNamed(nibNamewalkthrough, owner: self, options: nil)?.first as! LandingPageSlider
        slide2.imgView.image = UIImage(named: "Slider")
        
        
        
        return [slide1, slide2]
    }
    
    func setupSlideScrollView(slides : [LandingPageSlider]) {
            
        
        // if UtilesSwift.shared.getPhoneScreen() == .iphoneXSMax{
        scrollview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 515.0)
        scrollview.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 515.0)
        scrollview.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: 515.0)
            scrollview.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            
            walkthroughslides[0].imgView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            walkthroughslides[1].imgView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)

        }
        
    }
    
    
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
        if(pageControl.currentPage == 0) {
            let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.pageIndicatorTintColor = pageUnselectedColor
            
            let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            walkthroughslides[pageControl.currentPage].backgroundColor = bgColor
            
            let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
            pageControl.currentPageIndicatorTintColor = pageSelectedColor
        }
    }
    
    func fade(fromRed: CGFloat, fromGreen: CGFloat, fromBlue: CGFloat,fromAlpha: CGFloat, toRed: CGFloat, toGreen: CGFloat, toBlue: CGFloat, toAlpha: CGFloat,withPercentage percentage: CGFloat) -> UIColor {
        
        let red: CGFloat = (toRed - fromRed) * percentage + fromRed
        let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
        let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
        let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
