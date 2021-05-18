//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by James Tapping on 15/04/2021.
//

import UIKit
import Charts

class ProgressViewController: UIViewController {
    
    let dateManager = DateManager()
    let statsHelper = ProgressStatsHelper()
    
    var week = Date()
    var month = Date()
    var year = Date()
    
    var maxYValue = 0
    
    var count = 0
    
    
    @IBOutlet weak var dateDisplay: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var displayChoice: UISegmentedControl!
    
    @IBAction func displayChoiceChanged(_ sender: UISegmentedControl) {
        
        switch displayChoice.selectedSegmentIndex {
        
        case 0:
            
            manageNoDataLabelWeek()
            weekDisplay()
            
        case 1:
            
            manageNoDataLabelMonth()
            monthDisplay()
        
        case 2:
            
            manageNoDataLabelYear()
            yearDisplay()
            
        default:
            
            break
        }
        
    }
    
    @IBAction func leftButton(_ sender: Any) {
        
        switch displayChoice.selectedSegmentIndex {
        
        case 0:
            
            week -= TimeInterval(7 * 24 * 3600)
            
            manageNoDataLabelWeek()
            
            weekDisplay()
            
        case 1:
            
            let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: month)!
            let numberOfDaysInMonth = dateManager.numberOfDaysInMonth(date: previousMonth)
            
            month -= TimeInterval(numberOfDaysInMonth * 24 * 3600)
            
            manageNoDataLabelMonth()
            
            monthDisplay()
            
        case 2:
            
            year -= TimeInterval(365 * 24 * 3600)
            
            manageNoDataLabelYear()
            
            yearDisplay()
            
        default:
            break
        }
        
        
        
    }
    
    @IBAction func rightButton(_ sender: Any) {
        
        switch displayChoice.selectedSegmentIndex {
        
        case 0:
        
            week += TimeInterval(7 * 24 * 3600)
            
            manageNoDataLabelWeek()
            
            weekDisplay()
            
        case 1:
            
            let nextMonth = Calendar.current.date(byAdding: .month, value: +1, to: month)!
            let numberOfDaysInMonth = dateManager.numberOfDaysInMonth(date: nextMonth)
            
            month += TimeInterval(numberOfDaysInMonth * 24 * 3600)
            
            manageNoDataLabelMonth()
            
            monthDisplay()
        
            
        case 2:
            
            year += TimeInterval(365 * 24 * 3600)
            manageNoDataLabelYear()
            
            yearDisplay()
            
        default:
            break
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        weekDisplay()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change navigation bar titles font
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 19)!]
        
        // Add tap capability to dateLabel
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapDateLabel))
        dateDisplay.addGestureRecognizer(tap)
        
        
        graphSetup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manageNoDataLabelWeek()
        
    }
    
    @objc func tapDateLabel() {
        
        switch displayChoice.selectedSegmentIndex {
        
        case 0:
            
            week = dateManager.firstDayOfWeek(for: dateManager.today)
            
            manageNoDataLabelWeek()
            
            weekDisplay()
            
        case 1:
            
            month = dateManager.firstDayOfMonth(for: dateManager.today)
            
            manageNoDataLabelMonth()
            
            monthDisplay()
            
            
        case 2:
            
            year = dateManager.firstDayOfYear(for: dateManager.today)
        
            manageNoDataLabelYear()
            
            yearDisplay()
        
        default:
            break
        }
        
    }
    
    // Manage No Data Label Functions
    
    func manageNoDataLabelWeek() {
        
        let data = statsHelper.returnWeekData(week: week)
        for i in 0 ..< data.count { count += data[i].total }
        noDataLabel.isHidden = count != 0
        dateDisplay.textColor = count == 0 ? UIColor.blueGray : UIColor.midnightBlue
        
        count = 0
    }
    
    func manageNoDataLabelMonth() {
        
        let data = statsHelper.returnMonthData(date: month)
        for i in 0 ..< data.count { count += data[i].total }
        noDataLabel.isHidden = count != 0
        dateDisplay.textColor = count == 0 ? UIColor.blueGray : UIColor.midnightBlue
        
        count = 0
    }
    
    func manageNoDataLabelYear() {
        
        let data = statsHelper.returnYearData(year: year)
        for i in 0 ..< data.count { count += data[i].total }
        noDataLabel.isHidden = count != 0
        dateDisplay.textColor = count == 0 ? UIColor.blueGray : UIColor.midnightBlue
        
        count = 0
    }
    
    func graphSetup() {

        let legend = barChartView.legend
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .horizontal
        legend.font = UIFont.init(name: "Helvetica Neue", size: 16)!
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = 12
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false
        xAxis.drawLabelsEnabled = true
        xAxis.drawAxisLineEnabled = false
        xAxis.labelFont = UIFont.init(name: "Helvetica Neue", size: 12)!

        let leftAxis = barChartView.leftAxis
        leftAxis.axisMinimum = 0.0
        leftAxis.drawGridLinesEnabled = true
        leftAxis.drawZeroLineEnabled = true
        leftAxis.labelFont = UIFont.init(name: "Helvetica Neue", size: 12)!
        
        
    }
    
    
    func weekDisplay() {
        
        dateDisplay.text = statsHelper.buildFirstDayOfWeekLabel(date: week)
        
        displayChoice.selectedSegmentIndex = 0
        
        var completedValues = [BarChartDataEntry]()
        var totalValues = [BarChartDataEntry]()
        
        var data: [(completed: Int, total: Int)] = []
        
        var temp: [Int] = []
        
        data = statsHelper.returnWeekData(week: week)
        
        for i in 0 ... data.count - 1 { temp.append(data[i].total) }
        
        maxYValue = temp.max()!
        
        for i in 0 ... data.count - 1 {
            
            completedValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].completed)))
            
            totalValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].total)))

            
        }
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = 7
        xAxis.labelFont = UIFont.init(name: "Helvetica Neue", size: 12)!
        
        let xAxisLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        let leftAxis = barChartView.leftAxis
        
        leftAxis.labelCount = maxYValue
        leftAxis.axisMaximum = Double(maxYValue) 

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        barChartView.xAxis.granularity = 1
        barChartView.isUserInteractionEnabled = false
        
        let completedSet = BarChartDataSet(entries: completedValues, label: "Completed")
        let totalSet = BarChartDataSet(entries: totalValues, label: "Total")
        
        completedSet.drawValuesEnabled = false
        totalSet.drawValuesEnabled = false
        
        completedSet.setColor(UIColor.serenity!)
        totalSet.setColor(UIColor.blueGray!)
        
        let chartData =  BarChartData(dataSets: [completedSet,totalSet])
        chartData.barWidth = Double(0.43)
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.groupBars(fromX: -0.5, groupSpace: Double(0.10), barSpace: Double(0.00))
        barChartView.invalidateIntrinsicContentSize()
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInCubic)
        
    }
    
    func monthDisplay() {
        
        dateDisplay.text = statsHelper.buildFirstDayOfMonthLabel(date: month)
        
        var completedValues = [BarChartDataEntry]()
        var totalValues = [BarChartDataEntry]()
        var xAxisLabels = [String]()
        
        var temp: [Int] = []
        
        let numberOfDaysInMonth = dateManager.numberOfDaysInMonth(date: month)
        
        var data: [(completed: Int, total: Int)] = []
        
        data = statsHelper.returnMonthData(date: month)
        
        for i in 0 ... data.count - 1 { temp.append(data[i].total) }
        
        maxYValue = temp.max()!
        
        for i in 0 ... data.count - 1 {
            
            completedValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].completed)))
            totalValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].total)))
            
        }
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = numberOfDaysInMonth
        xAxis.labelFont = UIFont.init(name: "Helvetica Neue", size: 6)!
        
        let days = Array(1...numberOfDaysInMonth)
        xAxisLabels = days.map{ String($0) }

        let leftAxis = barChartView.leftAxis
        leftAxis.labelCount = maxYValue
        leftAxis.axisMaximum = Double(maxYValue)
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        barChartView.xAxis.granularity = 1
        
        let completedSet = BarChartDataSet(entries: completedValues, label: "Completed")
        let totalSet = BarChartDataSet(entries: totalValues, label: "Total")
        
        completedSet.drawValuesEnabled = false
        totalSet.drawValuesEnabled = false
        
        completedSet.setColor(UIColor.serenity!)
        totalSet.setColor(UIColor.blueGray!)
        
        let chartData =  BarChartData(dataSets: [completedSet,totalSet])
        chartData.barWidth = Double(0.40)
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.groupBars(fromX: -0.5, groupSpace: Double(0.20), barSpace: Double(0.00))
        barChartView.invalidateIntrinsicContentSize()
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInCubic)
        
    }
    
    
    func yearDisplay() {
        
        dateDisplay.text = statsHelper.buildYearLabel(date: year)
        
        var completedValues = [BarChartDataEntry]()
        var totalValues = [BarChartDataEntry]()
        var data: [(completed: Int, total: Int)] = []
        var temp: [Int] = []
        
        data = statsHelper.returnYearData(year: year)
        
        for i in 0 ... data.count - 1 { temp.append(data[i].total) }
        
        maxYValue = temp.max()!
        
        for i in 0 ... data.count - 1 {
            
            completedValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].completed)))
            totalValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].total)))
            
        }
        
        let xAxisLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = 12
        xAxis.labelFont = UIFont.init(name: "Helvetica Neue", size:12)!

        let leftAxis = barChartView.leftAxis
        leftAxis.labelCount = 10
        leftAxis.axisMaximum = Double(maxYValue)
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        barChartView.xAxis.granularity = 1
        
        let completedSet = BarChartDataSet(entries: completedValues, label: "Completed")
        let totalSet = BarChartDataSet(entries: totalValues, label: "Total")
        
        completedSet.drawValuesEnabled = false
        totalSet.drawValuesEnabled = false
        
        completedSet.setColor(UIColor.serenity!)
        totalSet.setColor(UIColor.blueGray!)
        
        let chartData =  BarChartData(dataSets: [completedSet,totalSet])
        chartData.barWidth = Double(0.43)
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.groupBars(fromX: -0.5, groupSpace: Double(0.10), barSpace: Double(0.00))
        barChartView.invalidateIntrinsicContentSize()
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInCubic)
        
    }
    
}
