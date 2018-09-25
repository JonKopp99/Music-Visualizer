import ddf.minim.*;
import ddf.minim.analysis.*;
import controlP5.*;
Minim minim;
AudioPlayer song;
AudioMetaData meta;


ControlP5 cp5;

float color1 = (int)random(0,255);
float color2 = (int)random(0,255);
float color3 = (int)random(0,255);
float color4 = (int)random(0,255);
int mode;
float thesize,eRadius;
BeatDetect beat;
float cue,sliderValue,max;
Slider c;
int clearfps;
void setup() {
  fullScreen();
  //size(1280,720);
  frameRate(60);
  background(0);
  cue=0;
  sliderValue=0;
  colorMode(HSB,100,100,100,100);
  mode=0;
  minim = new Minim(this);
  selectInput("Select a song to play:", "fileSelected");
  song = minim.loadFile("Deorro - Five Hours.mp3", 1024);
  meta = song.getMetaData();
  song.play();
  thesize=(width/3);
  cp5 = new ControlP5(this);
  clearfps=0;
  c=cp5.addSlider("Song")
     .setRange(0,song.length()/1000)
     .setValue(sliderValue)
     .setPosition(0,height-10)
     .setSize(width,10) 
     ;
  

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(600);  
  ellipseMode(RADIUS);
  eRadius = 20;
  //smooth();
  max=0;
}


void draw() {
  
  noStroke();
  colorMode(HSB,100,100,100,100);
  
  fill(0, 5);
  rect(0,0,width,height);  
  c.setValue(song.position()*.001);    
  
  
 // fill(0,100);
  //rect(10,height-65,150,50);
  fill(60,100);
  textSize(15);
  text(meta.fileName(),10,height-20);
  if(mode==0)
  {
  pushMatrix();
  translate(width/2, height/2);
  rotate(radians(frameCount % 360 * 2));
    for(int j = 0; j < 360; j++) {
      if(song.mix.get(j)>.5)
      {
       
        
      }
      if(song.mix.get(j)*200 > 50) {
        stroke(color1,100,100);
      }
      else {
        stroke(color2,100,100);
      }
      
      line(cos(j)*50, sin(j)*50, cos(j)*abs(song.left.get(j))*thesize + cos(j)*50, sin(j)*abs(song.right.get(j))*thesize + sin(j)*50);
    }
    for(int k = 360; k > 0; k--) {
      
      
      if(song.mix.get(k)*200 > 25) {
        stroke(color3,100,100);
      }
      else {
        stroke(color4,100,100);
      }
      
      
      line(cos(k)*50, sin(k)*50, cos(k)*abs(song.right.get(k))*thesize + cos(k)*50, sin(k)*abs(song.left.get(k))*thesize + sin(k)*50);   
    }
    
    
  popMatrix();
  }
  
  beat.detect(song.mix);
  float a = map(eRadius, 20, 80, 60, 255);
  fill(60, 255, 0, a);
  if (beat.isOnset()||beat.isKick()||beat.isSnare()||beat.isHat())
  {
    eRadius = 80;
    color1 = (int)random(0,100);
    color2 = (int)random(0,100);
    color3 = (int)random(0,100);
    color4 = (int)random(0,100);
    for(int k=0;k<=100;k++)
    {
    fill((int)random(0,100),100,100);
    stroke((int)random(0,100),100,100);
    int tempsize=(int)random(0,3);
    ellipse((int)random(0,width),(int)random(0,height),tempsize,tempsize);
    }
    

  }
  ellipse(width/2, height/2, eRadius, eRadius);
  eRadius *= 0.95;
  if ( eRadius < 20 ) {
    eRadius = 20;

  }
  clearfps++;
    if(clearfps>=120)
     {
       fill(0,100);
       rect(-100,-100,width*2,height*2);
       clearfps=0;
     }
}

void mousePressed() {
  
    color1 = (int)random(0,100);
    color2 = (int)random( 0,100);
    color3 = (int)random(0,100);
    color4 = (int)random(0,100);
  
}
void keyReleased()
{
  if(key=='l')
    selectInput("Select a file to process:", "fileSelected");
  else
  {
  fill(0,100);
  rect(-100,-100,width*2,height*2);
  if(thesize==width/3)
    thesize=width/20;
    else if(thesize==width/20)
    thesize=width/40;
       else if(thesize==width/40)
          thesize=width;
            else if(thesize==width)
          thesize=width/3;
  }
}

void stop() {
  
  song.close();
  minim.stop();
  super.stop();
  
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.getController().getName()=="Song"&&mousePressed) {
    cue=cp5.getController("Song").getValue()*1000;
    song.cue((int)cue);
  }
  
  
  
  
  
  
}
void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println(selection.getPath());
    song.pause();
    song = minim.loadFile(selection.getAbsolutePath(), 1024);
    song=minim.loadFile(selection.getAbsolutePath());
    song.rewind();
    c.setValue(0); 
    c.setRange(0,song.length()/1000);
    sliderValue=0;
    cue=0;
    song.play();
    meta = song.getMetaData();
  }
}
