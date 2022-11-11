import { Controller } from 'stimulus';
// import ApexCharts from 'apexcharts'

export default class extends Controller {
  connect() {
    alert('chart-controller.js');

    const dates = JSON.parse(this.data.get('dates'));
    const values = JSON.parse(this.data.get('values'));

    const options = {
      chart: {
        type: 'area',
        fontFamily: 'inherit',
        height: 40.0,
        sparkline: {
          enabled: true,
        },
        animations: {
          enabled: false,
        },
      },
      dataLabels: {
        enabled: false,
      },
      fill: {
        opacity: 0.16,
        type: 'solid',
      },
      stroke: {
        width: 2,
        lineCap: 'round',
        curve: 'smooth',
      },
      series: [{
        name: 'Profits',
        data: values,
      }],
      grid: {
        strokeDashArray: 4,
      },
      xaxis: {
        labels: {
          padding: 0,
        },
        tooltip: {
          enabled: false,
        },
        axisBorder: {
          show: false,
        },
        type: 'datetime',
      },
      yaxis: {
        labels: {
          padding: 4,
        },
      },
      labels: dates,
      colors: ['#206bc4'],
      legend: {
        show: false,
      },
    };

    const chart = new ApexCharts(this.element, options);

    chart.render();
  }
}
