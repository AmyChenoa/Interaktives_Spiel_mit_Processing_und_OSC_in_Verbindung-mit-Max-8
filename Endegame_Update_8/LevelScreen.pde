class LevelScreen {
  Game game;  // Referenz auf das Game-Objekt, um den Bildschirm zu wechseln
  LevelManager levelManager;  // Referenz auf den LevelManager
  Star[] stars = new Star[150];  // Array für die Hintergrundsterne
  Button backButton;  // Zurück-Button
  Button[] levels = new Button[9];  // Array für die Level-Buttons
  float alpha = 0;  // Transparenz für den Titeltext

  // Konstruktor: Initialisiert die Sterne, Buttons und setzt den Game-Referenz
  LevelScreen(Game g, LevelManager lm) {
    this.game = g;  // Speichert die Instanz von Game

    // Debugging-Ausgabe zur Überprüfung
    if (lm == null) {
      println("LevelManager ist null im LevelScreen-Konstruktor!");
    } else {
      println("LevelManager wurde korrekt übergeben.");
    }

    this.levelManager = lm;  // Speichert die Instanz von LevelManager

    // Rest des Konstruktors bleibt gleich



    // Erstelle die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Zurück-Button: Wird oben links angezeigt
    backButton = new Button(20, 20, 100, 40, "BACK");

    // Positioniere die Level-Buttons in einer 3x3-Anordnung
    int buttonWidth = 200;  // Breite der Level-Buttons
    int buttonHeight = 50;  // Höhe der Level-Buttons
    int gap = 20;  // Abstand zwischen den Buttons

    // Berechne die Startposition der Buttons
    int startY = height / 2;  // Verschiebung der Buttons nach unten, unter den Titel

    // Positioniere die 9 Level-Buttons
    for (int i = 0; i < 9; i++) {
      int row = i / 3;  // Berechnet die Zeile (0, 1 oder 2)
      int col = i % 3;  // Berechnet die Spalte (0, 1 oder 2)

      // Berechne die X- und Y-Position der Buttons
      int x = (int)(width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);  // Vertikale Platzierung

      // Erstelle einen Button für jedes Level
      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }

  // Anzeige der LevelScreen-Komponenten
  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext Animation (Pulsieren des Titels)
    drawTitle();

    // Zeige alle Level-Buttons an
    for (int i = 0; i < 9; i++) {
      levels[i].display();
    }

    // Zeige den Zurück-Button an
    backButton.display();

    // Überprüfen, ob levelManager korrekt initialisiert ist
    if (levelManager != null) {
      levelManager.displayLevel();  // Zeigt das aktuelle Level an
    } else {
      println("Fehler: levelManager ist null, kein Level angezeigt!");
    }
  }

  // Zeichnet den Hintergrund (Schwarzer Hintergrund mit bewegenden Sternen)
  void drawBackground() {
    background(0);  // Schwarzer Hintergrund
    for (Star s : stars) {
      s.update();  // Aktualisiert die Position jedes Sterns
      s.show();    // Zeigt den Stern an
    }
  }

  // Zeichnet den pulsierenden Titeltext "CHOOSE A LEVEL"
  void drawTitle() {
    textAlign(CENTER);  // Text wird zentriert
    textSize(80);  // Größere Schrift für den Titel

    // Berechnet eine pulsierende Transparenz für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);  // Sinusfunktion für dynamische Transparenz

    // Mehrere Schatteneffekte für den Titeltext
    fill(0, 0, 0, alpha);
    text("CHOOSE A LEVEL", width / 2 + 5, height / 3 + 5);  // Schatten 1
    fill(0, 0, 0, alpha - 50);
    text("CHOOSE A LEVEL", width / 2 + 8, height / 3 + 8);  // Schatten 2
    fill(0, 0, 0, alpha - 100);
    text("CHOOSE A LEVEL", width / 2 + 12, height / 3 + 12);  // Schatten 3

    // Umrandung des Textes
    fill(255, 0, 0);  // Rote Farbe
    stroke(255, 0, 0);  // Rote Umrandung
    strokeWeight(10);  // Dicke der Umrandung
    text("CHOOSE A LEVEL", width / 2, height / 3);  // Text mit roter Umrandung

    // Gelbe Umrandung
    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("CHOOSE A LEVEL", width / 2, height / 3);

    // Fetter, leuchtender Türkis Text
    fill(0, 255, 255, alpha);  // Türkis mit pulsierender Transparenz
    noStroke();  // Keine Umrandung
    text("CHOOSE A LEVEL", width / 2, height / 3);  // Endgültiger Text
  }

  // Wird aufgerufen, wenn die Maus geklickt wird
  void mousePressed() {
    // Überprüfe, ob der Zurück-Button geklickt wurde
    if (backButton.isClicked()) {
      game.triggerTransition(0);  // Zurück zum Startbildschirm
    }

    // Überprüfe, ob einer der Level-Buttons geklickt wurde
    for (int i = 0; i < 9; i++) {
      if (levels[i].isClicked()) {
        println("Level " + (i + 1) + " Start!");
        levelManager.currentLevel = i + 1;  // Setze das Level im LevelManager
        game.startLevel(i + 1);  // Starte das ausgewählte Level im Game
      }
    }
  }
}
