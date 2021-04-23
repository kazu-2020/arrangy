<script>
import { Radar } from 'vue-chartjs';

export default {
  extends: Radar,
  props: {
    chartData: {
      type: Object,
      required: true,
    },
  },
  computed: {
    chart() {
      return {
        data: {
          labels: ['美味さ', '甘さ', '食べ応え', '辛さ'],
          datasets: [
            {
              label: '',
              backgroundColor: 'rgba(255,99,132,0.2)',
              borderColor: 'rgba(255,99,132,1)',
              pointBackgroundColor: 'rgba(255,99,132,1)',
              pointBorderColor: '#fff',
              pointHoverBackgroundColor: '#fff',
              pointHoverBorderColor: 'rgba(255,99,132,1)',
              data: [
                this.chartData.taste,
                this.chartData.sweetness,
                this.chartData.satisfaction,
                this.chartData.spiciness,
              ],
            },
          ],
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          scale: {
            ticks: {
              max: 5,
              min: 0,
              stepSize: 1,
              backdropColor: '#eeeeee',
            },
          },
          legend: {
            display: false,
          },
        },
      };
    },
  },
  watch: {
    chartData() {
      this.renderChart(this.chart.data, this.chart.options);
    },
  },
  mounted() {
    this.renderChart(this.chart.data, this.chart.options);
  },
};
</script>
