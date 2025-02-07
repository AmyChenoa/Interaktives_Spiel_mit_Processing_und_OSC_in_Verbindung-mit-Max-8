// 🌌 Game Over Screen mit Sci-Fi Feeling
class GameOverScreen {
  int highScore = 0;
  int currentScore = 0;
  Game game;
  Star[] stars = new Star[200];
  PImage gameOverImage;
  PFont gameFont;

  // 🎮 Konstruktor
  GameOverScreen(Game game) {
    this.game = game;
    gameOverImage = loadImage("data./GameOverScreen.png");  // Sternenhintergrund
    gameFont = createFont("Orbitron-Bold", 50); // Futuristische Schriftart

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    loadHighScore();
  }


  // 🌠 Hintergrund mit Sternen
  void drawBackground() {
    image(gameOverImage, 0, 0, width, height);

    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // 🔥 Hauptanzeige
  void display(int finalScore) {
    currentScore = finalScore;
    drawBackground();

    float glowIntensity = 100 + 80 * sin(millis() * 0.005);
    drawGameOverText(glowIntensity);
    drawScoreBox();
    drawHighScoreText();
    drawRestartText();

    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
    }
  }

  // ✨ "GAME OVER" mit sanftem Glow
  void drawGameOverText(float alpha) {
    textAlign(CENTER);
    textFont(gameFont);
    textSize(90);

    // Sanfter Glow
    fill(0, 200, 255, alpha);
    text("GAME OVER", width / 2, height / 4);

    fill(255);
    text("GAME OVER", width / 2, height / 4 - 3);
  }

  // 🏆 Dezente Score-Box
  void drawScoreBox() {
    rectMode(CENTER);

    fill(10, 10, 30, 200);
    stroke(0, 200, 255, 150);
    strokeWeight(2);
    rect(width / 2, height / 2 - 70, 320, 70, 15);

    textSize(35);
    fill(255);
    text("Score: " + currentScore, width / 2, height / 2 - 55);
  }

  // 🌟 Highscore-Anzeige mit dezentem Neon-Effekt
  void drawHighScoreText() {
    textSize(30);
    fill(0, 180, 255, 180);
    text("Highscore: " + highScore, width / 2, height / 2 + 50);

    fill(255);
    text("Highscore: " + highScore, width / 2, height / 2 + 47);
  }

  // 🔄 Sanfter, pulsierender Restart-Text
  void drawRestartText() {
    textSize(28);
    float restartAlpha = 150 + 80 * sin(millis() * 0.008);

    fill(0, 180, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height / 2 + 130);
  }

  // 🛸 Highscore-System
  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt");
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim());
      }
    }
    catch (Exception e) {
      println("⚠ Fehler beim Laden des Highscores: " + e.getMessage());
      highScore = 0;
    }
  }

  void saveHighScore() {
    String[] data = {str(highScore)};
    saveStrings("highscore.txt", data);
  }

  // 🚀 Spiel zurücksetzen
  void resetGame() {
    currentScore = 0;
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  // 🕹 Neustart per ENTER-Taste
  void keyPressed() {
    if (keyCode == ENTER) {
      resetGame();
      game.triggerTransition(1);
    }
  }
}
