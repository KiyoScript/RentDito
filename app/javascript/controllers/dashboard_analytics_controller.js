import { Controller } from "@hotwired/stimulus"
import { FetchRequest } from "@rails/request.js"
import "apexcharts"

// Connects to data-controller="dashboard-analytics"
export default class extends Controller {

  static targets = [
    "monthly",
    "getMonthly",
    "totalPaid",
    "totalAmount",
    "totalAmountPercentage",
    "waterTotalPaid",
    "waterTotalAmount",
    "electricityTotalPaid",
    "electricityTotalAmount",
    "wifiTotalPaid",
    "wifiTotalAmount",
    "monthlyRentalTotalPaid",
    "monthlyRentalTotalAmount",
    "waterPercentage",
    "electricityPercentage",
    "wifiPercentage",
    "monthlyRentalPercentage",
    "billingDonutChart"
  ]

  async updateCard(event){
    const yearMonth = event.currentTarget.dataset.dashboardAnalyticsBillingMonth;

    const clickedBillingMonth = event.currentTarget.innerText.trim()
    this.monthlyTarget.innerText = clickedBillingMonth


    const request = new FetchRequest("get", `/dashboard/billings/billing_data?year_month=${yearMonth}`, { responseKind: "json" });

    const response = await request.perform()

    if (response.ok) {
      const data = await response.json
      this.totalPaidTarget.textContent = `₱${data.total_paid}`
      this.totalAmountTarget.textContent = `₱${data.total_amount}`
      this.waterTotalPaidTarget.textContent = `₱${data.total_water_billing_paid_amount}`
      this.waterTotalAmountTarget.textContent = `₱${data.total_water_billing_amount}`
      this.electricityTotalPaidTarget.textContent = `₱${data.total_electricity_billing_paid_amount}`
      this.electricityTotalAmountTarget.textContent = `₱${data.total_electricity_billing_amount}`
      this.wifiTotalPaidTarget.textContent = `₱${data.total_wifi_billing_paid_amount}`
      this.wifiTotalAmountTarget.textContent = `₱${data.total_wifi_billing_amount}`
      this.monthlyRentalTotalPaidTarget.textContent = `₱${data.total_monthly_rental_billing_paid_amount}`
      this.monthlyRentalTotalAmountTarget.textContent = `₱${data.total_monthly_rental_billing_amount}`

      this.waterPercentageTarget.textContent = `${this._percentage(data.total_water_billing_paid_amount, data.total_water_billing_amount)}%`
      this.electricityPercentageTarget.textContent = `${this._percentage(data.total_electricity_billing_paid_amount, data.total_electricity_billing_amount)}%`
      this.wifiPercentageTarget.textContent = `${this._percentage(data.total_wifi_billing_paid_amount, data.total_wifi_billing_amount)}%`
      this.monthlyRentalPercentageTarget.textContent = `${this._percentage(data.total_monthly_rental_billing_paid_amount, data.total_monthly_rental_billing_amount)}%`

      this._render_billing_statistics_chart(
        this._percentage(data.total_water_billing_paid_amount, data.total_water_billing_amount),
        this._percentage(data.total_electricity_billing_paid_amount, data.total_electricity_billing_amount),
        this._percentage(data.total_wifi_billing_paid_amount, data.total_wifi_billing_amount),
        this._percentage(data.total_monthly_rental_billing_paid_amount, data.total_monthly_rental_billing_amount)
      )
    }
  }

  _percentage(divisor, dividend) {
    if (dividend == 0) {
      return 100.00
    }
    const result = (divisor / dividend) * 100;
    return Math.round(result);
  }


  _render_billing_statistics_chart(water, electricity, wifi, monthly_rental) {
    const currentTime = new Date();
    const hours = currentTime.getHours();

    const isDarkTheme = hours >= 20 || hours < 5;

    let cardColor, headingColor, legendColor, labelColor;

    if (isDarkTheme) {
      cardColor = config.colors_dark.cardColor;
      labelColor = config.colors_dark.textMuted;
      legendColor = config.colors_dark.bodyColor;
      headingColor = config.colors_dark.headingColor;
    } else {
      cardColor = config.colors.cardColor;
      labelColor = config.colors.textMuted;
      legendColor = config.colors.bodyColor;
      headingColor = config.colors.headingColor;
    }

    const billingChartStatistics = this.billingDonutChartTarget;

    if (this.statisticsChart) {
      this.statisticsChart.destroy();
    }

    const orderChartConfig = {
      chart: {
        height: 145,
        width: 110,
        type: 'donut'
      },
      labels: ['Water', 'Electricity', 'Wi-Fi', 'Rental'],
      series: [water, electricity, wifi, monthly_rental],
      colors: ["#00E396", "#008FFB", "#FEB019", "#FF4560"],
      stroke: {
        width: 5,
        colors: [cardColor]
      },
      dataLabels: {
        enabled: false
      },
      legend: {
        show: false
      },
      grid: {
        padding: {
          top: 0,
          bottom: 0,
          right: 15
        }
      },
      states: {
        hover: {
          filter: { type: 'none' }
        },
        active: {
          filter: { type: 'none' }
        }
      },
      plotOptions: {
        pie: {
          donut: {
            size: '75%',
            labels: {
              show: true,
              value: {
                fontSize: '18px',
                fontFamily: 'Public Sans',
                fontWeight: 500,
                color: headingColor,
                offsetY: -17,
                formatter: function (val) {
                  return `${Math.round(val)}%`;
                }
              },
              name: {
                offsetY: 17,
                fontFamily: 'Public Sans'
              },
              total: {
                show: true,
                fontSize: '11px',
                color: legendColor,
                label: 'Average',
                formatter: function (w) {
                  return `${Math.round(w.globals.series.reduce((a, b) => a + b, 0) / 4)}%`;
                }
              }
            }
          }
        }
      }
    };

    this.statisticsChart = new ApexCharts(billingChartStatistics, orderChartConfig);
    this.statisticsChart.render();

  }
}
