// Definition der WinScreen-Klasse (Gewinnbildschirm des Spiels)

class WinScreen {
  Star[] stars = new Star[150];  // Hintergrundsterne für die Animation
  float alpha = 0;  // Transparenz für pulsierende Texteffekte
  Game game;  // Referenz auf das Game-Objekt, um Übergänge zu verwalten

  // Konstruktor: Initialisiert den Gewinnbildschirm und erstellt die Sterne im Hintergrund
  WinScreen(Game game) {
    this.game = game;  // Speichert die Referenz auf das Game-Objekt

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Jedes Sternobjekt wird in das Array eingefügt
    }
  }

  // Anzeige-Methode für den Gewinnbildschirm
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

  // Zeichnet den Hintergrund mit den bewegenden Sternen
  void drawBackground() {
    background(0);  // Schwarzer Hintergrund
    for (Star s : stars) {
      s.update();  // Aktualisiert die Position der Sterne
      s.show();    // Zeichnet die Sterne
    }
  }

  // Zeichnet den Titel "You Win!" mit pulsierendem Effekt
  void drawTitle() {
    textAlign(CENTER);  // Textzentrierung
    textSize(70);  // Große Schrift für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);  // Sinusfunktion für das Pulsieren

    // Schatten für den Titel (schwarzer Text)
    fill(0, 0, 0, alpha);
    text("YOU WIN!", width / 2 + 4, height / 3 + 4);
    // Haupttitel in gelb
    fill(255, 255, 0, alpha);
    text("YOU WIN!", width / 2, height / 3);
  }

  // Zeichnet den finalen Punktestand des Spiels
  void drawScore(int score) {
    textAlign(CENTER);  // Textzentrierung
    textSize(32);  // Schriftgröße für den Punktestand

    // Punktestand-Anzeige mit Schatteneffekten
    fill(0, 0, 0, 150);
    text("Final Score: " + score, width / 2 + 3, height / 2 + 3);  // Schatten
    fill(255);
    text("Final Score: " + score, width / 2, height / 2);  // Haupttext
  }

  // Zeichnet den Neustart-Hinweis
  void drawRestartText() {
    textAlign(CENTER);  // Textzentrierung
    textSize(30);  // Kleinere Schriftgröße für den Neustart-Hinweis

    // Pulsierender Effekt für den Neustart-Hinweis
    float restartTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Pulsierender Effekt
    fill(0, 0, 0, restartTextAlpha);  // Schwarzer Schatten
    text("Press ENTER to Restart", width / 2 + 3, height * 2 / 3 + 3);
    // Roter Text mit Umrandung
    fill(255, 0, 0, restartTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Press ENTER to Restart", width / 2, height * 2 / 3);

    // Weißer Haupttext
    fill(255, 255, 255, restartTextAlpha);
    noStroke();
    text("Press ENTER to Restart", width / 2, height * 2 / 3);
  }
}
