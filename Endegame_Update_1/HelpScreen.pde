class HelpScreen {
  Star[] stars = new Star[150];  // Hintergrundsterne
  Button backButton;
  float alpha = 0;

  HelpScreen() {
    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Zurück-Button
    backButton = new Button(width / 2 - 100, height - 100, 200, 50, "BACK");
  }

  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext Animation (Pulsieren des Titels)
    drawTitle();

    // Hilfe Text mit pulsierender Transparenz
    drawHelpText();

    // Button anzeigen
    backButton.display();
  }

  void drawBackground() {
    background(0);  // Schwarzer Hintergrund
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(80);  // Große Schrift für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Text mit mehreren Schatteneffekten
    fill(0, 0, 0, alpha); 
    text("HOW TO PLAY", width / 2 + 5, height / 3 + 5);  
    fill(0, 0, 0, alpha - 50); 
    text("HOW TO PLAY", width / 2 + 8, height / 3 + 8);  
    fill(0, 0, 0, alpha - 100); 
    text("HOW TO PLAY", width / 2 + 12, height / 3 + 12);  

    // Umrandung des Textes
    fill(255, 0, 0); 
    stroke(255, 0, 0); 
    strokeWeight(10);  
    text("HOW TO PLAY", width / 2, height / 3);  

    fill(255, 255, 0); 
    stroke(255, 255, 0); 
    strokeWeight(5);  
    text("HOW TO PLAY", width / 2, height / 3);  

    // Fetter, leuchtender Türkis Text
    fill(0, 255, 255, alpha); 
    noStroke(); 
    text("HOW TO PLAY", width / 2, height / 3);  
  }

  void drawHelpText() {
    textSize(20);  // Kleinere Schrift für die Anweisungen
    float helpTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Pulsierender Effekt für den Text

    // Hilfetext mit mehreren Effekten
    fill(0, 0, 0, helpTextAlpha); 
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2 + 3, height / 2 + 3);  // Schatten

    fill(255, 0, 0, helpTextAlpha); 
    stroke(255, 0, 0); 
    strokeWeight(4); 
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);  // Umrandung

    fill(255, 255, 255, helpTextAlpha); 
    noStroke(); 
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);  // Haupttext
  }

  void mousePressed() {
    if (backButton.isClicked()) {
      screen = 0;  // Zurück zum Startscreen
    }
  }
}
