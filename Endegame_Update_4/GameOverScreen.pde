class GameOverScreen {
  Game game;
  float alpha = 0;
  Star[] stars;
  int highScore = 0;
  int currentScore = 0;
  Button restartButton;  

  // Konstruktor
  GameOverScreen(Game game) {
    this.game = game;
    stars = new Star[150];

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    
    loadHighScore();  
  }

  // Hintergrund zeichnen
  void drawBackground() {
    background(0);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // Anzeige des Game Over Screens
  void display(int finalScore) {
    currentScore = finalScore;
    drawBackground();
    drawGameOverText();
    drawScoreBox();
    drawHighScoreText();

    // Restart Button anzeigen
    if (restartButton == null) {
      restartButton = new Button(width / 2 - 100, height / 2 + 100, 200, 50, "Press ENTER to Restart");
    }
    restartButton.display();

    // Highscore aktualisieren
    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
    }
  }

  // Game Over Text anzeigen
  void drawGameOverText() {
    textAlign(CENTER);
    textSize(80);
    
    alpha = 150 + 105 * sin(millis() * 0.005);
    
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("GAME OVER", width / 2, height / 3);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("GAME OVER", width / 2, height / 3);

    fill(0, 255, 255, alpha);
    noStroke();
    text("GAME OVER", width / 2, height / 3);
  }

  // Score Box
  void drawScoreBox() {
    fill(0, 0, 0, 150);
    noStroke();
    rectMode(CENTER);
    rect(width / 2, height / 2, 300, 70);

    textSize(30);
    float scoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(255, 0, 0, scoreTextAlpha);
    text("Score: " + currentScore, width / 2, height / 2);
  }

  // Highscore anzeigen
  void drawHighScoreText() {
    textSize(30);
    float highScoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    
    fill(255, 0, 0, highScoreTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Highscore: " + highScore, width / 2, height / 2 - 50);

    fill(255, 255, 255, highScoreTextAlpha);
    noStroke();
    text("Highscore: " + highScore, width / 2, height / 2 - 50);
  }

  // Highscore laden
  void loadHighScore() {
    String[] data = loadStrings("highscore.txt");
    if (data != null && data.length > 0) {
      try {
        highScore = Integer.parseInt(data[0]);
      } catch (NumberFormatException e) {
        highScore = 0;
      }
    } else {
      highScore = 0;
    }
  }

  // Highscore speichern
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
    restartButton = new Button(width / 2 - 100, height / 2 + 100, 200, 50, "Press ENTER to Restart");
    game.startNewGame(); 
  }
}
