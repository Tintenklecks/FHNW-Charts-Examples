//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import SwiftUI
import Charts

struct ScatterChart: View {

	var isOverview: Bool

    @State private var pointSize = 10.0
    @State private var showLegend = false
    
    var body: some View {
		if isOverview {
			chart
		} else {
			List {
				Section {
					chart
				}

				customisation
			}
			.navigationBarTitle(ChartType.scatter.title, displayMode: .inline)
		}

    }

	private var chart: some View {
		Chart {
			ForEach(LocationData.last30Days) { series in
				ForEach(series.sales, id: \.weekday) { element in
					PointMark(
						x: .value("Day", element.weekday, unit: .day),
						y: .value("Sales", element.sales)
					)
					.accessibilityLabel("\(element.weekday.formatted())")
					.accessibilityValue("\(element.sales)")
				}
				.foregroundStyle(by: .value("City", series.city))
				.symbol(by: .value("City", series.city))
				.symbolSize(pointSize * 5)
			}
		}
		.chartLegend((showLegend && !isOverview) ? .visible : .hidden)
		.chartLegend(position: .bottomLeading)
		.chartYAxis(isOverview ? .hidden : .automatic)
		.chartXAxis(isOverview ? .hidden : .automatic)
		.frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
	}

    private var customisation: some View {
        Section {
            Stepper(value: $pointSize.animation(), in: 1.0...20.0) {
                HStack {
                    Text("Point Width")
                    Spacer()
                    Text("\(String(format: "%.0f", pointSize))")
                }
            }
            
            Toggle("Show Chart Legend", isOn: $showLegend.animation())
        }
    }
}

struct ScatterChart_Previews: PreviewProvider {
	static var previews: some View {
        ScatterChart(isOverview: true)
		ScatterChart(isOverview: false)
    }
}
