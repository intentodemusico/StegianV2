import React from 'react';

function Risk(props) {
  const risk = props.risk;
  if (risk <= 30) {
    return <div>RIESGO: BAJO</div>;
  } else if (risk > 30 && risk < 70) {
    return <div>RIESGO: MEDIO</div>;
  } else if (risk >= 70) {
    return <div>RIESGO: ALTO</div>;
  }
}

export default Risk;
