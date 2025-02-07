// Definition der Klasse GameOverScreen
class GameOverScreen {
  int highScore = 0;  
  int currentScore = 0; 
  Game game;  
  Star[] stars = new Star[150];  
  PImage gameOverImage;
  PFont gameOverFont;

  // Konstruktor
  GameOverScreen(Game game) {
    this.game = game; 
    gameOverImage = loadImage("data./GameOverScreen.png");  // Statischer Hintergrund
    gameOverFont = createFont("Arial Black", 48); // Kräftige Schrift für "GAME OVER"

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    loadHighScore();
  }

  // Hintergrund mit Sternen
  void drawBackground() {
    image(gameOverImage, 0, 0, width, height); 
    for (Star s : stars) {  
      s.update();  
      s.show();  
    }
  }

  // Anzeige des Game Over Screens
  void display(int finalScore) {
    currentScore = finalScore;
    drawBackground();
    
    float dynamicAlpha = 150 + 105 * sin(millis() * 0.005);
    drawGameOverText(dynamicAlpha);
    drawScoreBox(dynamicAlpha);
    drawHighScoreText();
    drawRestartText();

    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
    }
  }

  // 🎨 "GAME OVER"-Text mit Glow & sanften Schatten
  void drawGameOverText(float alpha) {
    textAlign(CENTER);
    textFont(gameOverFont);
    textSize(90);

    float glowOffset = 6;
    for (int i = 3; i > 0; i--) { 
      fill(255, 0, 0, alpha - (i * 40)); 
      text("GAME OVER", width / 2 + i * glowOffset, height / 4 + i * glowOffset);
    }

    fill(255, 255, 0);
    text("GAME OVER", width / 2, height / 4);
  }

  // 🏆 Animierte Score-Box mit Glow-Effekt
  void drawScoreBox(float alpha) {
    rectMode(CENTER);
    float pulsate = 2 * sin(millis() * 0.01);

    // Box mit weichem Glow
    fill(0, 0, 0, 180);
    stroke(255, 0, 0, 150);
    strokeWeight(4);
    rect(width / 2, height / 2 - 80, 360 + pulsate, 90 + pulsate, 20);

    textSize(38);
    fill(255, 255, 255, alpha);
    text("Score: " + currentScore, width / 2, height / 2 - 75);
  }

  // 🔥 Highscore-Text, jetzt mit leuchtendem Effekt
  void drawHighScoreText() {
    textSize(35);
    float highScoreAlpha = 150 + 105 * sin(millis() * 0.005);

    for (int i = 3; i > 0; i--) {
      fill(255, 215, 0, highScoreAlpha - (i * 30));
      text("Highscore: " + highScore, width / 2 + i, height / 2 + 90 + i);
    }

    fill(255, 255, 255, highScoreAlpha);
    text("Highscore: " + highScore, width / 2, height / 2 + 90);
  }

  // 🔄 Blinkender "Press ENTER to Restart"-Text
  void drawRestartText() {
    textSize(30);
    float restartAlpha = 150 + 105 * sin(millis() * 0.01);

    for (int i = 2; i > 0; i--) {
      fill(0, 0, 0, restartAlpha - (i * 30));
      text("Press ENTER to Restart", width / 2 + i, height / 2 + 170 + i);
    }

    fill(255, 255, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height / 2 + 170);
  }

  // Highscore speichern/laden
  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt");
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim());
      }
    }
    catch (Exception e) {
      println("Fehler beim Laden des Highscores: " + e.getMessage());
      highScore = 0;
    }
  }

  void saveHighScore() {
    String[] data = {str(highScore)};
    saveStrings("highscore.txt", data);
  }

  // Spiel zurücksetzen
  void resetGame() {
    currentScore = 0;  
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  // Neustart per ENTER-Taste
  void keyPressed() {
    if (keyCode == ENTER) {
      resetGame();
      game.triggerTransition(1);
    }
  }
}
