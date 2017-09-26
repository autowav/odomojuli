float [][][] a;
float [][][] b;
float [][][] c;

float c_a = random(1);
float c_b = random(1);
float c_c = random(1);

int r = 0, q = 1;

void keyPressed()
{
  saveFrame("data/###.png"); // Press key to Save
}

void setup()
{

  size(256, 256); // adjust resolution

  colorMode(RGB, 1.0); // constrain color range to 1.0
  //colorMode(HSB, 1.0); 


  frameRate(60); // fix frameRate

  a = new float [width][height][2]; //float array
  b = new float [width][height][2];
  c = new float [width][height][2];
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) { // initialize grid with random amounts of chemicals
      a[x][y][r] = random(0, (1));
      b[x][y][r] = random(0, (1));
      c[x][y][r] = random(0, (1));
    }
  }
}
void draw()
{      


  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      for (int i = x - 1; i <= x+1; i++) {
        for (int j = y - 1; j <= y+1; j++) {
          c_a += a[(i+width)%width][(j+height)%height][r]; // toroidal wrap
          c_b += b[(i+width)%width][(j+height)%height][r];
          c_c += c[(i+width)%width][(j+height)%height][r];
        }
      }
      c_a /= 9; //Moore Neighborhood
      c_b /= 9;
      c_c /= 9;
      //Standard Belousov-Zhabotinsky Model
      //a[x][y][q] = constrain((c_a) + (c_a) * (c_b - c_c), 0, 1);
      //b[x][y][q] = constrain((c_b) + (c_b) * (c_c - c_a), 0, 1);
      //c[x][y][q] = constrain((c_c) + (c_c) * (c_a - c_b), 0, 1);

/    //spectral modification
      a[x][y][q] = constrain((c_a) + (c_a) * (c_b - c_c), 0, (c_c + (c_b%c_a))); //
      b[x][y][q] = constrain((c_b) + (c_b) * (c_c - c_a), 0, (c_a + (c_c%c_b)));
      c[x][y][q] = constrain((c_c) + (c_c) * (c_a - c_b), 0, (c_b + (c_a%c_c)));

//
      set(x, y, color(a[x][y][q], b[x][y][q], c[x][y][q])); // set RGB to each chemical

      ;
    }
  }
  if (r == 0) { // flip flop states
    r = 1;
    q = 0;
  } else {
    r = 0; 
    q = 1;
  }
  println(frameCount); // print current Frame
  saveFrame("newmovie/######.png"); // save per each frame
}