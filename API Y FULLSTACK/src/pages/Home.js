import React, { Component } from 'react';
import AppBar from '@material-ui/core/AppBar';
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import Grid from '@material-ui/core/Grid';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';
import { Link } from 'react-router-dom';
import Axios from 'axios';

function Copyright() {
  return (
    <Typography variant="body2" color="textSecondary" align="center">
      {'Copyright © '}

      STEGONOMONO
      {new Date().getFullYear()}
      {'.'}
    </Typography>
  );
}


const useStyles = makeStyles(theme => ({
  icon: {
    marginRight: theme.spacing(2),
  },
  heroContent: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(8, 0, 6),
  },
  heroButtons: {
    marginTop: theme.spacing(4),
  },
  cardGrid: {
    paddingTop: theme.spacing(8),
    paddingBottom: theme.spacing(8),
  },
  card: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
  },
  cardMedia: {
    paddingTop: '56.25%', // 16:9
  },
  cardContent: {
    flexGrow: 1,
  },
  footer: {
    backgroundColor: theme.palette.background.paper,
    padding: theme.spacing(6),
  },
}));

export default class Album extends Component {
  constructor(props) {
    super(props);
    this.state = {
      image: ""
    };
    this.handleSubmit = this.handleSubmit.bind(this)
    this.sendImage = this.sendImage.bind(this);
  }
  handleChange = event => {
    this.setState({
      [event.target.name]: event.target.value
    })
  }
  handleSubmit = event => {
    event.preventDefault()
  }
  sendImage() {

    var formData= new FormData();
    formData.append("image",this.state.image)


    Axios.post('http://stegonomono.bucaramanga.upb.edu.co/API/image/',formData,{"Content-Type": "multipart/form-data"}).then(res => {
      console.log(res);
      localStorage.setItem("resulto",res.result)
      window.location = "/reportes"

    }).catch(err => {
      console.log(err);

    })

  }
  render() {

    return (
      <React.Fragment>
        <CssBaseline />
        <AppBar position="relative">
          <Toolbar>
            <Typography variant="h6" color="inherit" noWrap>
              Stegonomono
          </Typography>
          </Toolbar>
        </AppBar>
        <main>
          {/* Hero unit */}
          <div >
            <Container maxWidth="sm">
              <Typography
                component="h1"
                variant="h2"
                align="center"
                color="textPrimary"
                gutterBottom
              >
                STEGONOMONO
            </Typography>
              <Typography
                variant="h5"
                align="center"
                color="textSecondary"
                paragraph
              >
                Bienvenido a STEGONOMONO. Esta herramienta permite detectar
                imágenes, que hallan sido alteradas usando esteganografía. Adjunte
                la imagen que desea escanear y presione el botón de Enviar para
                empezar el análisis.
            </Typography>
              <div >

                <Grid container spacing={2} justify="center">
                  <form onSubmit={this.handleSubmit}>


                    <input
                      accept="image/*"
                      id="contained-button-file"
                      multiple
                      type="file"
                      name="image"
                      value={this.state.picture}
                    />

                    <label htmlFor="contained-button-file">
                      <Button
                        variant="outlined"
                        component="span"
                        color="primary"
                      >
                        Upload
                    </Button>
                    </label>



                    <Button
                      variant="contained"
                      color="primary"
                      type="submit"
                      onClick={this.sendImage}
                      component = {Link} to="/reportes"
                    >
                      Submit
                  </Button>

                  </form>
                </Grid>

              </div>
            </Container>
          </div>
        </main>
        {/* Footer */}
        <footer >
          <Typography variant="h6" align="center" gutterBottom>
            Footer
        </Typography>
          <Typography
            variant="subtitle1"
            align="center"
            color="textSecondary"
            component="p"
          >
            Este es un proyecto integrador de estudiantes de la Universidad
            Pontificia Bolivariana
        </Typography>
          <Copyright />
        </footer>
        {/* End footer */}
      </React.Fragment>
    );
  }
}
