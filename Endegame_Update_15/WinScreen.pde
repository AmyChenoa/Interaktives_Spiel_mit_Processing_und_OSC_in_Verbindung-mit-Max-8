class WinScreen {
  Star[] stars = new Star[150];
  float alpha = 0;
  Game game;
  PImage WinImage;
  PFont winFont;
  int highScore = 0;
  int currentScore = 0;
  String name = "";
  Table table;

  WinScreen(Game game) {
    this.game = game;
    WinImage = loadImage("data./WinScreen.png");

    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore();
    table = loadTable("data./new.csv", "header");
  }

  void display(int score) {
    currentScore = score;
    drawBackground();
    drawTitle();
    drawScore(score);
    drawHighScoreText();
    drawRestartText();
    drawNameInput();

    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
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

  void drawScore(int score) {
    textAlign(CENTER);
    textSize(80);
    fill(255);
    text("Final Score: " + score, width / 2, height * 2 / 3);
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

  void drawNameInput() {
    textAlign(CENTER);
    textSize(40);
    fill(255);
    text("Enter Name: " + name, width / 2, height - 100);
  }

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

  void keyPressed() {
    if (key == ENTER) {
      TableRow newRow = table.addRow();
      newRow.setInt("punkte", currentScore);
      newRow.setString("name", name);

      table.sortReverse("punkte");
      if (table.getRowCount() > 10) {
        table.removeRow(table.getRowCount()-1);
      }
      saveTable(table, "data/new.csv");
      game.triggerTransition(1);
    }
    if (key == BACKSPACE && name.length() > 0) {
      name = name.substring(0, name.length() - 1);
    }
    if (name.length() < 10 && key >= 32 && key <= 126) {
      name += key;
    }
  }
}
