import { Controller } from "stimulus"
// import ApexCharts from 'apexcharts'

export default class extends Controller {
    connect() {
        alert('chart-controller.js')

        let dates = JSON.parse(this.data.get('dates'));
        let values = JSON.parse(this.data.get('values'));

        let options = {
            chart: {
                type: "area",
                fontFamily: 'inherit',
                height: 40.0,
                sparkline: {
                    enabled: true
                },
                animations: {
                    enabled: false
                },
            },
            dataLabels: {
                enabled: false,
            },
            fill: {
                opacity: .16,
                type: 'solid'
            },
            stroke: {
                width: 2,
                lineCap: "round",
                curve: "smooth",
            },
            series: [{
                name: "Profits",
                data: values
            }],
            grid: {
                strokeDashArray: 4,
            },
            xaxis: {
                labels: {
                    padding: 0
                },
                tooltip: {
                    enabled: false
                },
                axisBorder: {
                    show: false,
                },
                type: 'datetime',
            },
            yaxis: {
                labels: {
                    padding: 4
                },
            },
            labels: dates,
            colors: ["#206bc4"],
            legend: {
                show: false,
            },
        }

        var chart = new ApexCharts(this.element, options);

        chart.render();
    }
}
