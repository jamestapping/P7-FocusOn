//
//  ProgressViewController.swift
//  FocusOn
//
//  Created by James Tapping on 15/04/2021.
//

import UIKit
import Charts

class ProgressViewController: UIViewController {

    let midnightBlue = UIColor(named: "MidnightBlue")
    let blueGray = UIColor(named: "BlueGray")
    let serenity = UIColor(named: "Serenity")
    
    let statsHelper = ProgressStatsHelper()
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var displayChoice: UISegmentedControl!
    
    @IBAction func displayChoiceChanged(_ sender: UISegmentedControl) {
        
        switch displayChoice.selectedSegmentIndex {
        
        case 0:
            
            weekDisplay()
            
        case 1:
            
            print ("Case 1 Month Day")
        
        case 2:

            yearDisplay()
            
        default:
            
            break
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Change navigation bar titles font
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue Bold", size: 19)!]
        
        setData()
        
    }
    
    func setData() {

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
        
        var completedValues = [BarChartDataEntry]()
        var totalValues = [BarChartDataEntry]()
        
        var data: [(completed: Int, total: Int)] = []
        
        data = statsHelper.returnWeekData(week: Date())
     
        print ("Week data count", data.count)
        
        for i in 0 ... data.count - 1 {
            
            completedValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].completed)))
            
            // print (data[i].completed)
            
            totalValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].total)))
            
            // print (data[i].total)
            
        }
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = 7
        
        let xAxisLabels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]

        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        barChartView.xAxis.granularity = 1
        
        let completedSet = BarChartDataSet(entries: completedValues, label: "Completed")
        let totalSet = BarChartDataSet(entries: totalValues, label: "Total")
        
        completedSet.drawValuesEnabled = false
        totalSet.drawValuesEnabled = false
        
        completedSet.setColor(serenity!)
        totalSet.setColor(blueGray!)
        
        let chartData =  BarChartData(dataSets: [completedSet,totalSet])
        chartData.barWidth = Double(0.43)
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.groupBars(fromX: -0.5, groupSpace: Double(0.10), barSpace: Double(0.00))
        barChartView.invalidateIntrinsicContentSize()
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInCubic)
        
    }
    
    
    func yearDisplay() {
        
        var completedValues = [BarChartDataEntry]()
        var totalValues = [BarChartDataEntry]()
        
        var data: [(completed: Int, total: Int)] = []
        
        data = statsHelper.returnYearData(year: Date())
        
        for i in 0 ... data.count - 1 {
            
            completedValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].completed)))
            totalValues.append(BarChartDataEntry(x: Double(i), y: Double(data[i].total)))
            
        }
        
        let xAxisLabels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let xAxis = barChartView.xAxis
        xAxis.labelCount = 12

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels)
        barChartView.xAxis.granularity = 1
        
        let completedSet = BarChartDataSet(entries: completedValues, label: "Completed")
        let totalSet = BarChartDataSet(entries: totalValues, label: "Total")
        
        completedSet.drawValuesEnabled = false
        totalSet.drawValuesEnabled = false
        
        completedSet.setColor(serenity!)
        totalSet.setColor(blueGray!)
        
        let chartData =  BarChartData(dataSets: [completedSet,totalSet])
        chartData.barWidth = Double(0.43)
        barChartView.data = chartData
        barChartView.rightAxis.enabled = false
        barChartView.groupBars(fromX: -0.5, groupSpace: Double(0.10), barSpace: Double(0.00))
        barChartView.invalidateIntrinsicContentSize()
        barChartView.animate(yAxisDuration: 0.5, easingOption: .easeInCubic)
        
    }
    
}
