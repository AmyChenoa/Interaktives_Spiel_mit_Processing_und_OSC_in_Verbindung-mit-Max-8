class WinScreen {
  Star[] stars = new Star[150]; // Hintergrundsterne für Animation
  float alpha = 0;  // Für pulsierende Texteffekte
  Game game;  // Referenz auf das Game-Objekt

  WinScreen(Game game) {
    this.game = game;

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void display(int score) {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titel "You Win!" mit pulsierenden Effekten
    drawTitle();

    // Zeigt den finalen Punktestand an
    drawScore(score);

    // Zeigt den Neustart-Hinweis an
    drawRestartText();
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
    textSize(70);  // Größere Schrift für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Schatten für den Titel
    fill(0, 0, 0, alpha); 
    text("YOU WIN!", width / 2 + 4, height / 3 + 4);  
    fill(255, 255, 0, alpha); 
    text("YOU WIN!", width / 2, height / 3);
  }

  void drawScore(int score) {
    textAlign(CENTER);
    textSize(32);

    // Punktestand-Anzeige mit leichten Schatteneffekten
    fill(0, 0, 0, 150); 
    text("Final Score: " + score, width / 2 + 3, height / 2 + 3); 
    fill(255); 
    text("Final Score: " + score, width / 2, height / 2);
  }

  void drawRestartText() {
    textAlign(CENTER);
    textSize(30);  

    // Pulsierender Effekt für den Neustart-Hinweis
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(0, 0, 0, restartTextAlpha); 
    text("Press ENTER to Restart", width / 2 + 3, height * 2 / 3 + 3); 
    fill(255, 0, 0, restartTextAlpha); 
    stroke(255, 0, 0); 
    strokeWeight(4); 
    text("Press ENTER to Restart", width / 2, height * 2 / 3); 

    fill(255, 255, 255, restartTextAlpha); 
    noStroke(); 
    text("Press ENTER to Restart", width / 2, height * 2 / 3);  
  }
}
