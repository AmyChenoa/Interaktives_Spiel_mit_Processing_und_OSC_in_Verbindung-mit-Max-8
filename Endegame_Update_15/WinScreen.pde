class WinScreen {
  Star[] stars = new Star[150];
  float alpha = 0;
  Game game;
  PImage WinImage;
  int highScore = 0;
  int currentScore = 0;



  WinScreen(Game game) {
    this.game = game;
    WinImage = loadImage("data./WinScreen.png");

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void display(int score) {
    currentScore = score;
    drawBackground();
    drawTitle();
    drawScore();
    drawHighScoreText();
    drawRestartText();
    updateHighScore();
  }

  void updateHighScore() {
    if (currentScore > game.highScore) {
      game.highScore = currentScore;
      game.saveHighScore();
    }
  }

  void drawBackground() {
    image(WinImage, 0, 0, width, height);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(130);
    alpha = 150 + 105 * sin(millis() * 0.005);

    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(16);
    text("YOU WIN!", width / 2, height / 4);

    fill(0, 255, 255, alpha);
    noStroke();
    text("YOU WIN!", width / 2, height / 4);
  }

  void drawScore() {
    fill(255);
    textSize(20);
    text("Your Score: " + currentScore, width / 2, height / 2);
  }

  void drawHighScoreText() {
    textSize(30);
    fill(0, 180, 255, 180);
    text("Highscore: " + highScore, width / 2, height / 2 + 50);
    fill(255);
    text("Highscore: " + highScore, width / 2, height / 2 + 47);
  }

  void drawRestartText() {
    textAlign(CENTER);
    textSize(30);
    float restartAlpha = 150 + 80 * sin(millis() * 0.008);
    fill(0, 180, 255, restartAlpha);
    text("Press ENTER to Restart", width / 2, height * 2 / 3 + 140);
  }
}
