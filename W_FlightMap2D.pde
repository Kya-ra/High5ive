import java.util.function.Function;
import java.util.function.Consumer;

class FlightMap2DUI extends Widget {

  private PImage m_mapImage;
  
  public FlightMap2DUI(int posX, int posY, int scaleX, int scaleY) {
    super(posX, posY, scaleX, scaleY);
    m_mapImage = loadImage("data/Images/EarthDay8kNoIce.jpg");
  }

  @ Override
    public void draw() {
    super.draw();
       
    m_mapImage = loadImage("data/Images/EarthDay8kNoIce.jpg");
    fill(m_backgroundColour);
    image(m_mapImage, 0, 0, 2048, 1024);
  }
}


// M. Orlowski: Added this to not mess with anything else that uses the W_FlightMap map.
