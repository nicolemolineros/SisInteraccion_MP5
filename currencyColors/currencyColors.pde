import oscP5.*;
import netP5.*;
ArrayList<Ring> rings = new ArrayList<Ring>();

OscP5 oscP5;
float receivedValue = 0;

void setup() {
  size(800, 600);
  oscP5 = new OscP5(this, 12000); // Set up OSC to listen on port 12000
  println("Listening for OSC messages on port 12000");
}

void draw() {
  background(20, 20, 40); // Dark background for contrast

  // Draw all rings
  for (int i = rings.size() - 1; i >= 0; i--) {
    Ring ring = rings.get(i);
    ring.update();
    ring.display();
    if (ring.isFaded()) {
      rings.remove(i);
    }
  }
}

// Handle incoming OSC messages
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/price") && msg.checkTypetag("f")) {
    receivedValue = msg.get(0).floatValue();
    println("Received price: " + receivedValue);
    createRing(receivedValue);
  }
}

// Create a new ring based on the stock price
void createRing(float price) {
  float radius = map(price, 0, 10000, 50, 400); // Map price to radius
  color col = getColor(price); // Determine ring color based on price
  rings.add(new Ring(width / 2, height / 2, radius, col));
}

// Generate a color based on the stock price using mod 255
color getColor(float price) {
  int r = (int)(price % 255); // Red component 
  int g = (int)((price * 2) % 255); // Green component 
  int b = (int)((price * 3) % 255); // Blue component 
  return color(r, g, b); // Return the color
}

// Ring class
class Ring {
  float x, y;
  float radius;
  float maxRadius;
  float alpha = 255;
  color col;
  
  Ring(float x, float y, float maxRadius, color col) {
    this.x = x;
    this.y = y;
    this.radius = 0;
    this.maxRadius = maxRadius;
    this.col = col;
  }

  void update() {
    radius += 2; // Increase radius 
    if (radius > maxRadius) {
      alpha -= 3; // Fade
    }
  }

  void display() {
    noFill();
    stroke(col, alpha);
    strokeWeight(3);
    ellipse(x, y, radius * 2, radius * 2);
  }

  boolean isFaded() {
    return alpha <= 0;
  }
}
