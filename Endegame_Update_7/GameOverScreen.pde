// Definition der Klasse GameOverScreen

// Definition der Klasse GameOverScreen

class GameOverScreen {
  Star[] stars = new Star[150];  // Array von Sternen für den Hintergrund
  Game game;  // Referenz auf das Game-Objekt, um die Übergänge zu steuern
  float alpha = 0;  // Transparenzwert für die Textanimationen
  float backgroundShift = 0;  // Wert für die Bewegung des Hintergrunds
  float introProgress = 0;  // Fortschritt der Animation
  boolean introFinished = false;  // Flag, um zu erkennen, ob das GameOver abgeschlossen ist
  int currentScore;  // Punktestand für das GameOver


  GameOverScreen(Game game, int score) {
    this.game = game;  // Referenz auf das Game-Objekt zuweisen
    this.currentScore = score;  // Den Punktestand übergeben und speichern
    // Initialisiert die Sterne für den Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
  }

  void showGameOver() {
    // Hintergrundanimation mit sanften Bewegungen und Farbänderungen
    drawBackground();

    // GameOver Text mit pulsierender Transparenz
    drawGameOverText();

    // Score Text und Highscore Text mit pulsierenden Effekten
    drawScoreBox();
    drawHighScoreText();

    // Restart Text für Neustart-Option
    drawRestartText();

    // Ladebalken für den Fortschritt der Spielauswertung
    if (introProgress < 1) {
      introProgress += 0.005; // Langsame Steigerung des Ladefortschritts
      drawLoadingBar(width / 2 - 100, height * 3 / 4, 200, 20);  // Zeigt den Ladebalken an
    } else {
      if (!introFinished) {
        introFinished = true;  // Markiere das GameOver als abgeschlossen
        delay(500);  // Kurze Pause für einen Übergangseffekt
        game.triggerTransition(3);  // Übergang zum Hauptmenü oder nächsten Bildschirm
      }
    }
  }

  void drawBackground() {
    // Sanfter Farbverlauf, der mit der Zeit leicht verändert wird
    float r = 20 + 30 * sin(backgroundShift * 0.003);
    float g = 20 + 30 * cos(backgroundShift * 0.003);
    float b = 40 + 20 * sin(backgroundShift * 0.005);
    background(r, g, b);  // Setzt den Hintergrund auf den berechneten Farbverlauf

    // Bewegt und zeigt die Sterne an
    for (Star s : stars) {
      s.update();  // Aktualisiert die Position jedes Sterns
      s.show();    // Zeigt den Stern an
    }

    // Langsame Bewegung des Hintergrunds für den Nebeleffekt
    backgroundShift += 0.1;  // Erhöht den Wert, um eine sanfte Bewegung zu erzeugen
  }

  void drawGameOverText() {
    textAlign(CENTER);  // Text wird zentriert
    textSize(90);  // Setzt die Textgröße auf 90 für den Game Over Titel

    // Berechnet eine pulsierende Transparenz für den Titel
    alpha = 150 + 105 * sin(millis() * 0.003);  // Sinusfunktion für dynamische Transparenz

    // Schatteneffekte für den Titel
    fill(0, 0, 0, alpha);  // Schatten in Schwarz
    text("GAME OVER", width / 2 + 5, height / 4 + 5);  // Schatten 1
    fill(0, 0, 0, alpha - 50);  // Etwas weniger Transparenz
    text("GAME OVER", width / 2 + 8, height / 4 + 8);  // Schatten 2
    fill(0, 0, 0, alpha - 100);  // Noch weniger Transparenz
    text("GAME OVER", width / 2 + 12, height / 4 + 12);  // Schatten 3

    // Leuchtende Umrandung und Farbe für den Text
    fill(255, 255, 0);  // Gelbe Farbe
    stroke(255, 255, 0);  // Gelbe Umrandung
    strokeWeight(5);  // Dicke der Umrandung
    text("GAME OVER", width / 2, height / 4);  // Text mit gelber Umrandung

    // Türkisfarbener, leicht transparenter Text ohne Umrandung
    fill(0, 255, 255, alpha);  // Türkis mit pulsierender Transparenz
    noStroke();  // Keine Umrandung
    text("GAME OVER", width / 2, height / 4);  // Endgültiger Text
  }

  void drawScoreBox() {
    // Abgerundete Box mit Schimmer-Effekt
    fill(0, 0, 0, 180);
    noStroke();
    rectMode(CENTER);
    rect(width / 2, height / 2 + 80, 330, 90, 25);

    // Pulsierender Score-Text
    textSize(50);
    float scoreTextAlpha = 150 + 105 * sin(millis() * 0.005);
    fill(255, 255, 255, scoreTextAlpha);
    text("Score: " + currentScore, width / 2, height / 2 + 80);
  }

  void saveHighScore(int highScore) {
    String filename = "highscore.txt";  // The file name to save the high score
    String[] highScoreArray = {Integer.toString(highScore)};  // Convert high score to string and store in an array
    saveStrings(filename, highScoreArray);  // Save the array to the file
  }

  int loadHighScore() {
    String filename = "highscore.txt";  // The file name to load the high score from
    String[] lines = loadStrings(filename);  // Load the content of the file into an array of strings

    if (lines != null && lines.length > 0) {
      return Integer.parseInt(lines[0]);  // Return the first line (the high score) as an integer
    } else {
      return 0;  // Return 0 if the file doesn't exist or is empty
    }
  }

  void drawHighScoreText() {
    int highScore = Math.max(currentScore, loadHighScore()); // Calculate high score
    textSize(45);
    float highScoreTextAlpha = 150 + 105 * sin(millis() * 0.005);

    // Highscore Text with pulsing effect
    fill(255, 255, 255, highScoreTextAlpha);
    stroke(0, 255, 255);
    strokeWeight(4);
    text("Highscore: " + highScore, width / 2, height / 2 - 50);
    noStroke();
  }

  void drawRestartText() {
    textSize(45);
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);

    // Text für Restart-Hinweis in pulsierender Weise
    fill(0, 255, 255, restartTextAlpha);
    text("Press ENTER to Restart", width / 2 + 3, height / 2 + 200 + 3);
    fill(255, 255, 255, restartTextAlpha);
    stroke(255, 255, 255);
    strokeWeight(4);
    text("Press ENTER to Restart", width / 2, height / 2 + 200);
    noStroke();
  }

  void drawLoadingBar(float x, float y, float width, float height) {
    noStroke();
    fill(50, 50, 50);  // Hintergrund des Ladebalkens (dunkelgrau)
    rect(x, y, width, height);  // Zeichnet den Hintergrund des Ladebalkens

    // Ladefortschritt (grün)
    fill(0, 255, 0);
    rect(x, y, width * introProgress, height);  // Füllt den Ladebalken basierend auf dem Fortschritt
  }

  // Wird kontinuierlich aufgerufen, um das GameOver anzuzeigen
  void update() {
    showGameOver();  // Zeigt das Game Over an
  }

  // Startet das Spiel sofort, wenn die ENTER-Taste gedrückt wird
  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;  // Markiert das Game Over als abgeschlossen
      delay(500);  // Kurze Pause für einen Übergangseffekt
      game.triggerTransition(3);  // Übergang zum nächsten Bildschirm oder zum Spiel
    }
  }
}
