import React from 'react';
import { Pie } from 'react-chartjs-2';
import { MDBContainer } from 'mdbreact';
import Risk from './Risk';
import Typography from '@material-ui/core/Typography';

const inseguro = localStorage.resulto
const seguro = 100 - inseguro;

class PieChart extends React.Component {
  state = {
    dataPie: {
      labels: ['Riesgo', 'Seguro'],
      datasets: [
        {
          data: [inseguro, seguro],
          backgroundColor: ['#F7464A', '#46BFBD'],
          hoverBackgroundColor: ['#FF5A5E', '#5AD3D1'],
        },
      ],
    },
  };

  render() {
    return (
      <MDBContainer>
        <Pie data={this.state.dataPie} options={{ responsive: true }} />
        <Typography variant="h5" align="center" color="textSecondary" paragraph>
          <h1>
            <Risk risk={inseguro} />
          </h1>
        </Typography>
      </MDBContainer>
    );
  }
}

export default PieChart;