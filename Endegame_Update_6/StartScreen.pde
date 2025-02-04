// Definition der StartScreen-Klasse (Startbildschirm des Spiels)

class StartScreen {
  Star[] stars = new Star[150];  // Array für die Sterne im Hintergrund
  Button levelButton, helpButton;  // Buttons für die Level-Auswahl und Hilfe
  float alpha = 0;  // Transparenz für den Titeltext
  Game game;  // Referenz auf das Game-Objekt, um Übergänge zu verwalten

  // Konstruktor: Initialisiert den Startbildschirm und die Buttons
  StartScreen(Game game) {
    this.game = game;  // Speichert die Referenz auf das Game-Objekt

    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Jedes Sternobjekt wird in das Array eingefügt
    }

    // Erstelle die Buttons für Level-Auswahl und Hilfe
    levelButton = new Button(width / 2 - 250, height / 2 + 100, 200, 50, "LEVELS");
    helpButton = new Button(width / 2 + 50, height / 2 + 100, 200, 50, "HELP");
  }

  // Anzeige-Methode für den Startbildschirm
  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext mit Pulsieren
    drawTitle();

    // Start-Text mit pulsierender Transparenz
    drawStartText();

    // Anzeigen der Buttons
    levelButton.display();
    helpButton.display();
  }

  // Zeichnet den Hintergrund mit den bewegenden Sternen
  void drawBackground() {
    background(0);  // Schwarzer Hintergrund
    for (Star s : stars) {
      s.update();  // Aktualisiert die Position der Sterne
      s.show();    // Zeichnet die Sterne
    }
  }

  // Zeichnet den Titel des Spiels mit verschiedenen Effekten
  void drawTitle() {
    textAlign(CENTER);  // Textzentrierung
    textSize(80);  // Setzt die Schriftgröße für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);  // Verwenden der Sinusfunktion für das Pulsieren

    // Titel mit mehreren Schatteneffekten (faded)
    fill(0, 0, 0, alpha);
    text("SPACE SHOOTER", width / 2 + 5, height / 3 + 5);
    fill(0, 0, 0, alpha - 50);
    text("SPACE SHOOTER", width / 2 + 8, height / 3 + 8);
    fill(0, 0, 0, alpha - 100);
    text("SPACE SHOOTER", width / 2 + 12, height / 3 + 12);

    // Umrandung (Zweifache Umrandung mit verschiedenen Farben)
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("SPACE SHOOTER", width / 2, height / 3);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("SPACE SHOOTER", width / 2, height / 3);

    // Fetter, leuchtender Türkis Text
    fill(0, 255, 255, alpha);
    noStroke();
    text("SPACE SHOOTER", width / 2, height / 3);  // Haupttext ohne Rand
  }

  // Zeichnet den Start-Text (mit pulsierender Transparenz)
  void drawStartText() {
    textSize(30);  // Kleinere Schrift für den Starttext
    float startTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Pulsierender Effekt für den Text
    fill(0, 0, 0, startTextAlpha);
    text("Press ENTER to Start", width / 2 + 3, height / 2 + 3);  // Schatteneffekt
    fill(255, 0, 0, startTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Press ENTER to Start", width / 2, height / 2);  // Umrandung

    fill(255, 255, 255, startTextAlpha);  // Haupttext in Weiß
    noStroke();
    text("Press ENTER to Start", width / 2, height / 2);
  }

  // Überprüft, ob einer der Buttons geklickt wurde
  void mousePressed() {
    if (levelButton.isClicked()) {
      game.triggerTransition(1);  // Übergang zum Level-Auswahl-Bildschirm
    }
    if (helpButton.isClicked()) {
      game.triggerTransition(2);  // Übergang zum Hilfe-Bildschirm
    }
  }
}
