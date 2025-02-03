class LevelScreen {
  Star[] stars = new Star[150];  // Hintergrundsterne
  Button backButton;
  Button[] levels = new Button[9];  // Array für die Level-Buttons
  float alpha = 0;

  LevelScreen() {
    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Zurück-Button
    backButton = new Button(20, 20, 100, 40, "BACK");

    // Positioniere die Level-Buttons in einer 3x3-Anordnung
    int buttonWidth = 200;
    int buttonHeight = 50;
    int gap = 20;  // Abstand zwischen den Buttons

    // Berechne die Startposition der Buttons weiter unten
    int startY = height / 2;  // Verschiebung der Buttons nach unten, unter den Titel

    for (int i = 0; i < 9; i++) {
      int row = i / 3;  // Berechnet die Zeile (0, 1 oder 2)
      int col = i % 3;  // Berechnet die Spalte (0, 1 oder 2)

      int x = (int)(width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);  // Buttons weiter unten platzieren

      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }

  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext Animation (Pulsieren des Titels)
    drawTitle();

    // Level-Buttons anzeigen
    for (int i = 0; i < 9; i++) {
      levels[i].display();
    }

    // Zurück-Button anzeigen
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
    textSize(80);  // Größere Schrift für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Text mit mehreren Schatteneffekten
    fill(0, 0, 0, alpha); 
    text("CHOOSE A LEVEL", width / 2 + 5, height / 3 + 5);  
    fill(0, 0, 0, alpha - 50); 
    text("CHOOSE A LEVEL", width / 2 + 8, height / 3 + 8);  
    fill(0, 0, 0, alpha - 100); 
    text("CHOOSE A LEVEL", width / 2 + 12, height / 3 + 12);  

    // Umrandung des Textes
    fill(255, 0, 0); 
    stroke(255, 0, 0); 
    strokeWeight(10);  
    text("CHOOSE A LEVEL", width / 2, height / 3);  

    fill(255, 255, 0); 
    stroke(255, 255, 0); 
    strokeWeight(5);  
    text("CHOOSE A LEVEL", width / 2, height / 3);  

    // Fetter, leuchtender Türkis Text
    fill(0, 255, 255, alpha); 
    noStroke(); 
    text("CHOOSE A LEVEL", width / 2, height / 3);  
  }

  void mousePressed() {
    if (backButton.isClicked()) {
      screen = 0;  // Zurück zum Startscreen
    }

    // Überprüfe, ob einer der Level-Buttons geklickt wurde
    for (int i = 0; i < 9; i++) {
      if (levels[i].isClicked()) {
        println("Level " + (i + 1) + " Start!");
        // Code zum Starten des jeweiligen Levels (i + 1)
      }
    }
  }
}
