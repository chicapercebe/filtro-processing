import processing.video.*;

int numPixels;
int[] fondoPixels;
// las variables que estan en mayusculas las robe de otro codigo, omitilas si queres xD
float TINT_CONTROL = 0; // chroma shift, range: (0.0,360.0) 
float BRIGHTNESS_CONTROL = 0.05; // brightness, range: (0.0,0.5)
float COLOR_CONTROL = 0.7; // color, range: (0.0,5.0)
float CONTRAST_CONTROL = 1.5; // contrast, range (0.0,5.0)
float SQUISH_CONTROL = 0.05; // squeeze right side of the screen, range (0.0,0.3)
float HORIZ_DESYNC = 5; // shift top of the screen, range (-5,5)
boolean FLUTTER_HORIZ_DESYNC = true; // flutter of top side of the screen
//capture actua como clase, su objeto sera video
Capture video;

void setup() {
  size(640, 480);
  // en java un objeto es creado desde una clase. esta clase puede ser public o private + sunombre
  // un objeto de esta clase se crea especificando NombreDeClase NombreObjeto = new Nombredeclase();
  //yo defino aca el nombredeobjeto video igual a new nombredeclase
  video = new Capture(this, width, height);
  // al empezar, toma el objeto video y le da la funcion de empezar
  video.start(); 
  //numero de pixeles toma el objeto video por su ancho y lo multiplica por su alto, para objetener el lienzo total
  numPixels = video.width * video.height;
  // crea un array basado en numpixels
  fondoPixels = new int[numPixels];
  //esto supuestamente lo deja disponible al array para manipular directamente D:
  loadPixels();
}

void draw() {
  float TINT_CONTROL = 0; // chroma shift, range: (0.0,360.0) 
float BRIGHTNESS_CONTROL = 0.05; // brightness, range: (0.0,0.5)
float COLOR_CONTROL = 0.7; // color, range: (0.0,5.0)
float CONTRAST_CONTROL = 1.5; // contrast, range (0.0,5.0)
float SQUISH_CONTROL = 0.05; // squeeze right side of the screen, range (0.0,0.3)
boolean FLUTTER_HORIZ_DESYNC = true; // flutter of top side of the screen

  
 
  if (video.available()) {
    video.read(); // lee cada frame del video
    video.loadPixels(); // hace que los pixeles del video esten disponibles
    // diferencia entre la frame actual y la que guarde en fondopixels
    
    int sumaColor = 0;
    for (int i = 0; i < numPixels; i++) { // es decir recorro cada pixel desde 0 a el total de la pantalla que es la variable num pixels
    TINT_CONTROL = random(1)<0.1?random(360):0;
  BRIGHTNESS_CONTROL = random(0.01,0.2);
  COLOR_CONTROL = random(3);
  CONTRAST_CONTROL = random(0.5,2);
  SQUISH_CONTROL = random(0.05);
  FLUTTER_HORIZ_DESYNC = random(1)<0.5;

      //busca el color actual de el pixel actual y el pixel de el array del fondo
      color ColorActual = video.pixels[i]; //al pixel actual le estoy dando elcolor, del objeto de video y su instruccion de pixel. es decir , tomo el pixel del video no? xD
      color ColorFondo = fondoPixels[i];
      // Del color actual del pixel, extraigo su rojo verde y azul. por eso defino 3 variables para los 3 colores primarios, y les saco su valor
      int actualR = (ColorActual >> 16) & 0xFF;  //0xff es un int literal (00 00 00 ff).
      int actualG = (ColorActual >> 8) & 0xFF;  // el & se aplica para producir el valor deseado para actualR/G/B.
      int actualB = ColorActual & 0xFF;
      // idem para el del fondo, extraigo sus colores primarios
      int fondoR = (ColorFondo >> 116) & 0xFF;
      int fondoG = (ColorFondo >> 208) & 0xFF;
      int fondoB = ColorFondo & 0xFF;
      // ABS computaba la diferencia entre parametros
      float diferenciaR = map(TINT_CONTROL - BRIGHTNESS_CONTROL,CONTRAST_CONTROL,video.pixelWidth,0,0);
      //float diferenciaR = map(actualR - fondoR,video.pixelHeight,video.pixelWidth,0,0);
      float diferenciaG = map(actualG - fondoG,width,height,mouseX,mouseY);
     // float diferenciaG = abs(actualG - fondoG);
      float diferenciaB = abs(actualB - fondoB);
      
      // estas diferencias van a sumarse en la cuenta (tally=cuenta)
      sumaColor += diferenciaR + diferenciaG + diferenciaB;
      
      // entonces pixels que era cada pixel de mi video, ahora va a llenar con la funcion de color que recibe las diferencias de colores
      pixels[i] = color(RGB - ( random( TINT_CONTROL) * diferenciaG -  diferenciaG));
      //   pixels[i] = color(#DB07C3 + (sumaColor/(diferenciaR - diferenciaG- diferenciaB)));
      // pixels[i] = color(tan(sumaColor/(diferenciaR - diferenciaG- diferenciaB)));
      //    pixels[i] = color(diferenciaR, diferenciaG, diferenciaB);
      // bakap
      //pixels[i] = 0xFF000000 | (diferenciaR << 16) | (diferenciaG << 8) | diferenciaB;
    //point(diferenciaR,diferenciaG);    
    //  stroke(#FAD9D9);
  
  
  }
    updatePixels(); // notifica que el array de pixeles cambio
   
  }
}
// cuando presiona una tecla, captura el fondo para guardarlo en el array de fondo
void keyPressed() {
  video.loadPixels();
  arraycopy(video.pixels, fondoPixels);
}
