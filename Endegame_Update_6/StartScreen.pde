class StartScreen {
  Star[] stars = new Star[150];
  Button levelButton, helpButton;
  float alpha = 0;
  Game game;  // Referenz auf das Game-Objekt

  StartScreen(Game game) {
    this.game = game;  // Weist die Game-Referenz zu

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  
    // Achte darauf, dass die Buttons korrekt relativ zur Bildschirmgröße positioniert sind
    levelButton = new Button(width / 2 - 250, height / 2 + 100, 200, 50, "LEVELS");
    helpButton = new Button(width / 2 + 50, height / 2 + 100, 200, 50, "HELP");
  }

  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext Animation (Pulsieren des Titels)
    drawTitle();

    // Start-Text mit pulsierender Transparenz
    drawStartText();

    // Buttons zeichnen
    levelButton.display();
    helpButton.display();
  }

  void drawBackground() {
    background(0);
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
    text("SPACE SHOOTER", width / 2 + 5, height / 3 + 5);  
    fill(0, 0, 0, alpha - 50); 
    text("SPACE SHOOTER", width / 2 + 8, height / 3 + 8);  
    fill(0, 0, 0, alpha - 100); 
    text("SPACE SHOOTER", width / 2 + 12, height / 3 + 12);  

    // Umrandung (Zweifache Umrandung mit verschiedenen Farben)
    fill(255, 0, 0); 
    stroke(255, 0, 0); 
    strokeWeight(10);  
    text("SPACE SHOOTER", width / 2, height / 3);  

    fill(255, 255, 0); 
    stroke(255, 255, 0); 
    strokeWeight(5);  
    text("SPACE SHOOTER", width / 2, height / 3);  

    // Fetter, leuchtender Türkis Text
    fill(0, 255, 255, alpha); 
    noStroke(); 
    text("SPACE SHOOTER", width / 2, height / 3);  
  }

  void drawStartText() {
    textSize(30);  
    float startTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Pulsierender Starttext
    fill(0, 0, 0, startTextAlpha); 
    text("Press ENTER to Start", width / 2 + 3, height / 2 + 3); 
    fill(255, 0, 0, startTextAlpha); 
    stroke(255, 0, 0); 
    strokeWeight(4); 
    text("Press ENTER to Start", width / 2, height / 2); 

    fill(255, 255, 255, startTextAlpha); 
    noStroke(); 
    text("Press ENTER to Start", width / 2, height / 2);  
  }

  void mousePressed() {
    if (levelButton.isClicked()) {
      game.triggerTransition(1);
    }
    if (helpButton.isClicked()) {
      game.triggerTransition(2);
    }
  }
}
