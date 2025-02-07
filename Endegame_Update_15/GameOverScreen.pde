// Definition der Klasse GameOverScreen
class GameOverScreen {
  int highScore = 0;  
  int currentScore = 0; 
  Game game;  
  Star[] stars = new Star[150];  
  PImage GameOverImage;

  // Konstruktor
  GameOverScreen(Game game) {
    this.game = game; 
    GameOverImage = loadImage("./data./GameOverScreen.png");  // Statischer Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore();
  }

  // Hintergrund (statisch)
  void drawBackground() {
    image(GameOverImage, 0, 0, width, height); 
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

  // 🎨 Stylischer "GAME OVER"-Text mit Glow & Schatten
  void drawGameOverText(float alpha) {
    textAlign(CENTER);
    textSize(90);
    
    // Mehrere Schattenebenen für einen 3D-Effekt
    for (int i = 12; i > 0; i--) {
      fill(255, 0, 0, alpha - (i * 10));
      text("GAME OVER", width / 2 + i, height / 4 + i);
    }
    
    fill(255, 255, 0);
    text("GAME OVER", width / 2, height / 4);
  }

  // 🏆 Animierte Score-Box (mit mehr Abstand)
  void drawScoreBox(float alpha) {
    rectMode(CENTER);
    float pulsate = 2 * sin(millis() * 0.01);
    
    fill(0, 0, 0, 200);
    stroke(255, 0, 0, 180);
    strokeWeight(3);
    rect(width / 2, height / 2 - 80, 340 + pulsate, 80 + pulsate, 20);

    textSize(35);
    fill(255, 255, 255, alpha);
    text("Score: " + currentScore, width / 2, height / 2 - 75);
  }

  // 🔥 Highscore-Text **deutlich weiter unten**
  void drawHighScoreText() {
    textSize(35);
    float highScoreAlpha = 150 + 105 * sin(millis() * 0.005);
    
    fill(0, 0, 0, highScoreAlpha);
    text("Highscore: " + highScore, width / 2 + 3, height / 2 + 80 + 3);
    
    fill(255, 255, 255, highScoreAlpha);
    text("Highscore: " + highScore, width / 2, height / 2 + 80);
  }

  // 🔄 Restart-Text **noch weiter unten**
  void drawRestartText() {
    textSize(30);
    float restartAlpha = 150 + 105 * sin(millis() * 0.005);
    
    fill(0, 0, 0, restartAlpha);
    text("Press ENTER to Restart", width / 2 + 2, height / 2 + 160 + 2);
    
    fill(255, 255, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height / 2 + 160);
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
