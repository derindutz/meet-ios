//
//  DashboardStatisticsTableViewCell.swift
//  Meet
//
//  Created by Derin Dutz on 11/22/15.
//  Copyright © 2015 Derin Dutz. All rights reserved.
//

import UIKit

class DashboardStatisticsTableViewCell: UITableViewCell, LineGraphViewDataSource {
    
    var period: Period = .Week {
        didSet {
            update()
        }
    }
    
    enum Period: String {
        case Week = "week"
        case Month = "month"
        case All = "all"
    }
    
    // MARK: Outlets
    
    
    @IBOutlet weak var hackyDashboardImage: UIImageView!
    
    @IBOutlet weak var currentPeriodLabel: UILabel!
    @IBOutlet weak var timeInCurrentPeriodLabel: UILabel!
    
    // These temporarily represent the dollars saved
    @IBOutlet weak var timeInPrevPeriodLabel: UILabel!
    @IBOutlet weak var prevLabel: UILabel!
    private var previousTimeArcView: ArcView?
    
    @IBOutlet weak var percentDifferenceLabel: UILabel!
    @IBOutlet weak var percentSignLabel: UILabel!
    @IBOutlet weak var percentDifferenceTriangleImageView: UIImageView!
    
    @IBOutlet weak var lineGraphView: LineGraphView! {
        didSet {
            //lineGraphView.dataSource = self
        }
    }
    
    @IBOutlet weak var changePeriodWeekButton: UIButton!
    @IBOutlet weak var changePeriodMonthButton: UIButton!
    @IBOutlet weak var changePeriodAllButton: UIButton!
    
    @IBAction func changePeriod(sender: UIButton) {
        if let buttonLabel = sender.titleLabel?.text {
            if let period = Period(rawValue: buttonLabel) {
                self.period = period
            }
        }
    }
    
    private func getNumDays(period: Period, total: Int) -> Int {
        switch period {
        case .Week:
            return 7
        case .Month:
            return 30
        case .All:
            return total
        }
    }
    
    func update() {
        updateData()
        updateUI()
    }
    
    // TODO: test weirdly large numbers in text fields
    
    func updateArcView() {
//        removeArcView()
//        if let sum = self.currentSum, prevSum = self.previousSum {
//            if sum < prevSum {
//                let startAngle = -CGFloat(M_PI / 2.0)
//                let endAngle = ((CGFloat(sum) / CGFloat(prevSum)) * CGFloat(M_PI * 2.0)) + startAngle
//                self.previousTimeArcView = ArcView(frame: getArcViewFrame())
//                self.previousTimeArcView!.setup(startAngle, endAngle: endAngle)
//            } else {
//                self.previousTimeArcView = ArcView(frame: getArcViewFrame())
//                self.previousTimeArcView!.setup()
//            }
//            self.addSubview(self.previousTimeArcView!)
//            self.previousTimeArcView!.animateArc(1.0)
//        }
    }
    
    private func getArcViewFrame() -> CGRect {
        let circleDiameter = CGFloat(88)
        let circleX = self.frame.origin.x + self.frame.width - circleDiameter - 10
        let circleY = self.frame.origin.y + 10
        return CGRectMake(circleX, circleY, circleDiameter, circleDiameter)
    }
    
    private func shouldArcViewFrameChange() -> Bool {
        if let arcView = self.previousTimeArcView {
            return !CGRectEqualToRect(getArcViewFrame(), arcView.frame)
        }
        return true
    }
    
    private func removeArcView() {
        if let arcView = self.previousTimeArcView {
            arcView.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        if (shouldArcViewFrameChange()) {
            updateArcView()
        }
    }
    
//    @IBOutlet weak var currentPeriodLabel: UILabel!
//    @IBOutlet weak var timeInCurrentPeriodLabel: UILabel!
//    
//    // These temporarily represent the dollars saved
//    @IBOutlet weak var timeInPrevPeriodLabel: UILabel!
//    @IBOutlet weak var prevLabel: UILabel!
//    private var previousTimeArcView: ArcView?
    
    private func updateData() {
//        self.percentDifferenceLabel.hidden = true
//        self.percentSignLabel.hidden = true
//        self.percentDifferenceTriangleImageView.hidden = true
//        self.currentPeriodLabel.hidden = true
//        self.timeInCurrentPeriodLabel.hidden = true
//        self.timeInPrevPeriodLabel.hidden = true
//        self.prevLabel.hidden = true
        
        self.previousSum = nil
        self.timeInPrevPeriodLabel.hidden = true
        self.prevLabel.hidden = true
        //updateArcView()
        
        self.percentDifferenceLabel.hidden = true
        self.percentSignLabel.hidden = true
        self.percentDifferenceTriangleImageView.hidden = true
        
        let allTimeSpentArray = MeetingDatabase.getDailyTimeSpentInMeetings()
        let numDaysInCurrentPeriod = getNumDays(self.period, total: allTimeSpentArray.count)
        self.currentSlice = Array(allTimeSpentArray.suffix(numDaysInCurrentPeriod))
        let slice = self.currentSlice!
        
        self.currentSum = ceil(Double(slice.reduce(0, combine: +)) / 60.0)
        let sum = self.currentSum!
        //self.timeInCurrentPeriodLabel.text = String.localizedStringWithFormat("%.0f", sum)
        self.timeInCurrentPeriodLabel.text = ""
        
//        if (numDaysInCurrentPeriod * 2 <= allTimeSpentArray.count) {
//            let prevSlice = allTimeSpentArray[(allTimeSpentArray.count - numDaysInCurrentPeriod * 2)..<(allTimeSpentArray.count - numDaysInCurrentPeriod)]
//            self.previousSum = ceil(Double(prevSlice.reduce(0, combine: +)) / 60.0)
//            let prevSum = self.previousSum!
//            
//            self.timeInPrevPeriodLabel.text = String.localizedStringWithFormat("%.0f", prevSum)
//            self.timeInPrevPeriodLabel.hidden = false
//            self.prevLabel.hidden = false
//            //updateArcView()
//            
//            if sum < prevSum {
//                let percentDifference = Int(round(((prevSum / sum) - 1.0) * 100))
//                self.percentDifferenceLabel.text = "\(percentDifference)"
//                self.percentDifferenceTriangleImageView.image = UIImage(named: "triangle_down")
//            } else {
//                let percentDifference = Int(round(((sum / prevSum) - 1.0) * 100))
//                self.percentDifferenceLabel.text = "\(percentDifference)"
//                self.percentDifferenceTriangleImageView.image = UIImage(named: "triangle_up")
//            }
//            self.percentDifferenceLabel.hidden = false
//            self.percentSignLabel.hidden = false
//            self.percentDifferenceTriangleImageView.hidden = false
//        } else {
//            self.previousSum = nil
//            self.timeInPrevPeriodLabel.hidden = true
//            self.prevLabel.hidden = true
//            //updateArcView()
//            
//            self.percentDifferenceLabel.hidden = true
//            self.percentSignLabel.hidden = true
//            self.percentDifferenceTriangleImageView.hidden = true
//        }
        
        if let maxVal = slice.maxElement() {
            lineGraphView.maxYValue = CGFloat(maxVal)
        }
        
        lineGraphView.maxXValue = CGFloat(slice.count - 1)
        
        print(slice)
    }
    
    private var prevX = -1
    
    func yValueForLineGraphView(xValue: CGFloat) -> CGFloat? {
        if let slice = self.currentSlice {
            let floorX = Int(floor(xValue))
            if floorX != self.prevX {
                self.prevX = floorX
                if floorX == slice.count - 1 {
                    self.prevX = -1
                }
                if floorX >= 0 && floorX < slice.count {
                    let yValue = slice[floorX]
                    return CGFloat(yValue)
                }
            }
        }

        return nil
    }
    
    // MARK: GUI
    
    private func updateUI() {
        switch self.period {
        case .Week:
            print("WEEK")
            hackyDashboardImage.image = UIImage(named: "ThisWeek")
            self.currentPeriodLabel.text = "last 7 days"
            self.changePeriodWeekButton.setTitleColor(Constants.SelectedButtonColor, forState: .Normal)
            self.changePeriodMonthButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
            self.changePeriodAllButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
        case .Month:
            print("MONTH")
            hackyDashboardImage.image = UIImage(named: "ThisMonth")
            self.currentPeriodLabel.text = "last 30 days"
            self.changePeriodWeekButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
            self.changePeriodMonthButton.setTitleColor(Constants.SelectedButtonColor, forState: .Normal)
            self.changePeriodAllButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
        case .All:
            print("ALL TIME")
            hackyDashboardImage.image = UIImage(named: "ThisYear")
            self.currentPeriodLabel.text = "all time"
            self.changePeriodWeekButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
            self.changePeriodMonthButton.setTitleColor(Constants.DeselectedButtonColor, forState: .Normal)
            self.changePeriodAllButton.setTitleColor(Constants.SelectedButtonColor, forState: .Normal)
        }
    }
    
    private var currentSlice: [Int]?
    private var currentSum: Double?
    private var previousSum: Double?
    
    // MARK: Constants
    
    private struct Constants {
        static let SelectedButtonColor = MeetColor.LightHighlight
        static let DeselectedButtonColor = MeetColor.LightBackground
    }
}