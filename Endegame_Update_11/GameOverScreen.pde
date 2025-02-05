// Definition der Klasse GameOverScreen
class GameOverScreen {
  float alpha = 0;  // Variable für die Transparenz des Textes
  Star[] stars = new Star[150];  // Array für Sterne, die den Hintergrund bilden
  int highScore = 0;  // Highscore des Spiels
  int currentScore = 0; // Der aktuelle Score nach dem Spiel
  Game game;  // Referenz auf das Game-Objekt (wird aktuell nicht verwendet)

  // Konstruktor: Initialisiert die Sterne und lädt den Highscore
  GameOverScreen() {
    // Initialisiert das Sterne-Array
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Für jeden Stern ein neues Star-Objekt erzeugen
    }
    loadHighScore();  // Highscore aus der Datei laden
  }

  // Zeichnet den Hintergrund und lässt die Sterne bewegen
  void drawBackground() {
    background(0);  // Setzt den Hintergrund auf schwarz
    for (Star s : stars) {  // Aktualisiert und zeigt jeden Stern
      s.update();  // Position des Sterns anpassen
      s.show();  // Stern anzeigen
    }
  }

  // Zeigt den Game Over Screen an
  void display(int finalScore) {
    currentScore = finalScore;  // Setzt den aktuellen Score

    // Zeichnet den Hintergrund und die Sterne
    drawBackground();

    // Zeichnet die verschiedenen Texte auf dem Bildschirm
    drawGameOverText();
    drawScoreBox();
    drawHighScoreText();
    drawRestartText();

    // Wenn der aktuelle Score höher als der Highscore ist, wird der Highscore aktualisiert
    if (currentScore > highScore) {
      highScore = currentScore;
      saveHighScore();  // Speichert den neuen Highscore in der Datei
    }
  }

  // Zeichnet den "GAME OVER"-Text mit verschiedenen Effekten
  void drawGameOverText() {
    textAlign(CENTER);  // Text zentriert ausrichten
    textSize(80);  // Setzt die Textgröße

    // Berechnet eine dynamische Transparenz basierend auf der Zeit
    alpha = 150 + 105 * sin(millis() * 0.005);  // Sinusfunktion für Pulsieren

    // Zeichnet mehrere Schatteneffekte für den Text
    fill(0, 0, 0, alpha);
    text("GAME OVER", width / 2 + 5, height / 3 + 5);
    fill(0, 0, 0, alpha - 50);
    text("GAME OVER", width / 2 + 8, height / 3 + 8);
    fill(0, 0, 0, alpha - 100);
    text("GAME OVER", width / 2 + 12, height / 3 + 12);

    // Zeichnet den Haupttext in Rot und Gelb mit verschiedenen Effekten
    fill(255, 0, 0);  // Rote Farbe
    stroke(255, 0, 0);  // Rote Umrandung
    strokeWeight(10);  // Dicke der Umrandung
    text("GAME OVER", width / 2, height / 3);

    fill(255, 255, 0);  // Gelbe Farbe
    stroke(255, 255, 0);  // Gelbe Umrandung
    strokeWeight(5);
    text("GAME OVER", width / 2, height / 3);

    fill(0, 255, 255, alpha);  // Cyan Farbe für die letzte Textschicht
    noStroke();
    text("GAME OVER", width / 2, height / 3);
  }

  // Zeichnet das Score-Box für den aktuellen Score
  void drawScoreBox() {
    // Transparentes Rechteck für den Score
    fill(0, 0, 0, 150);  // Halbtransparentes Schwarz
    noStroke();  // Keine Umrandung für das Rechteck
    rectMode(CENTER);  // Setzt den Ursprung des Rechtecks auf die Mitte
    rect(width / 2, height / 2, 300, 70);  // Rechteck für den Score

    // Score Text mit pulsierender Transparenz
    textSize(30);  // Textgröße
    float scoreTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Berechnet die pulsierende Transparenz
    fill(255, 0, 0, scoreTextAlpha);  // Rote Farbe für den Text
    text("Score: " + currentScore, width / 2, height / 2);  // Zeigt den aktuellen Score an
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
    String[] data = loadStrings("highscore.txt");  // Versucht, die Highscore-Datei zu laden
    if (data != null && data.length > 0) {
      highScore = Integer.parseInt(data[0]);  // Falls Daten vorhanden sind, Highscore setzen
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
    if (key == ENTER) {
      resetGame();  // Setzt das Spiel zurück
    }
  }
}
