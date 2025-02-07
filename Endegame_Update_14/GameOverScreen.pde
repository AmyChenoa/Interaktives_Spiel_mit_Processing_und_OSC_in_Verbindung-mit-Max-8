// Definition der Klasse GameOverScreen
class GameOverScreen {
  float alpha = 0;  // Transparenz für den Titeltext  Star[] stars = new Star[150];  // Array für Sterne, die den Hintergrund bilden
  int highScore = 0;  // Highscore des Spiels
  int currentScore = 0; // Der aktuelle Score nach dem Spiel
  Game game;  // Referenz auf das Game-Objekt (wird aktuell nicht verwendet)
  Star[] stars = new Star[150];  // Array für die Sterne im Hintergrund
  PImage GameOverImage;

  // Konstruktor: Initialisiert die Sterne und lädt den Highscore
  GameOverScreen(Game game) {
    this.game = game; // Initialisierung der game-Referenz
    GameOverImage = loadImage("./data./GameOverScreen.png");
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    loadHighScore();
  }


  // Zeichnet den Hintergrund und lässt die Sterne bewegen
  void drawBackground() {
    image(GameOverImage, 0, 0, width, height); // Hintergrundbild einmal zeichnen
    for (Star s : stars) {  // Aktualisiert und zeigt jeden Stern
      s.update();  // Position des Sterns anpassen
      s.show();  // Stern anzeigen
    }
  }

  // Zeigt den Game Over Screen an
  void display(int finalScore) {
    currentScore = finalScore;
    drawBackground();
    float dynamicAlpha = 150 + 105 * sin(millis() * 0.005); // Einmal berechnen

    drawGameOverText(dynamicAlpha);
    drawScoreBox(dynamicAlpha);
    drawHighScoreText();
    drawRestartText();

    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();
    }
  }


  // Zeichnet den "GAME OVER"-Text mit verschiedenen Effekten
  void drawGameOverText(float alpha) {
    textAlign(CENTER);
    textSize(80);

    fill(0, 0, 0, alpha);
    text("GAME OVER", width / 2 + 5, height / 3 + 5);
    fill(0, 0, 0, alpha - 50);
    text("GAME OVER", width / 2 + 8, height / 3 + 8);
    fill(0, 0, 0, alpha - 100);
    text("GAME OVER", width / 2 + 12, height / 3 + 12);

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


  // Zeichnet das Score-Box für den aktuellen Score
  void drawScoreBox(float alpha) {
    rectMode(CENTER);
    fill(0, 0, 0, 150);
    noStroke();
    rect(width / 2, height / 2, 300, 70);

    textSize(30);
    fill(255, 0, 0, alpha);
    text("Score: " + currentScore, width / 2, height / 2);
  }

  // Zeichnet den Text für den Highscore
  void drawHighScoreText() {
    textSize(30);  // Textgröße
    float highScoreTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Berechnet die pulsierende Transparenz
    fill(0, 0, 0, highScoreTextAlpha);  // Schatten des Textes
    text("Highscore: " + highScore, width / 2, height / 2 - 50);  // Zeigt den Highscore als Schatten an
    fill(255, 0, 0, highScoreTextAlpha);  // Rote Umrandung
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Highscore: " + highScore, width / 2, height / 2 - 50);  // Zeichnet die rote Umrandung des Textes

    fill(255, 255, 255, highScoreTextAlpha);  // Weißer Text
    noStroke();  // Keine Umrandung für den Text
    text("Highscore: " + highScore, width / 2, height / 2 - 50);  // Zeigt den Highscore an
  }

  // Zeichnet den Text für den Restart-Hinweis
  void drawRestartText() {
    textSize(30);  // Textgröße
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Berechnet die pulsierende Transparenz
    fill(0, 0, 0, restartTextAlpha);  // Schatten des Textes
    text("Press ENTER to Restart", width / 2 + 3, height / 2 + 50 + 3);  // Zeigt den Schatten des Restart-Textes an
    fill(255, 0, 0, restartTextAlpha);  // Rote Umrandung
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Press ENTER to Restart", width / 2, height / 2 + 50);  // Zeigt den roten Restart-Text an

    fill(255, 255, 255, restartTextAlpha);  // Weißer Text
    noStroke();  // Keine Umrandung für den Text
    text("Press ENTER to Restart", width / 2, height / 2 + 50);  // Zeigt den Restart-Text an
  }

  // Lädt den Highscore aus einer Datei
  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt");
      if (data != null && data.length > 0) {
        highScore = Integer.parseInt(data[0].trim());
      }
    }
    catch (Exception e) {
      println("Fehler beim Laden des Highscores: " + e.getMessage());
      highScore = 0; // Standardwert setzen
    }
  }


  // Speichert den Highscore in einer Datei
  void saveHighScore() {
    String[] data = {str(highScore)};  // Wandelt den Highscore in einen String um
    saveStrings("highscore.txt", data);  // Speichert den Highscore in einer Datei
  }

  // Setzt das Spiel zurück (z.B. bei einem Neustart)
  void resetGame() {
    currentScore = 0;  // Setzt den aktuellen Score auf 0
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Setzt alle Sterne zurück
    }
  }

  // Überprüft, ob die ENTER-Taste gedrückt wurde, um das Spiel zurückzusetzen
  void keyPressed() {
    if (keyCode == ENTER) {
      resetGame();
      game.triggerTransition(1);
    }
  }
}
