// Klasse zur Darstellung des Level-Auswahlbildschirms
class LevelScreen {
  Game game;  // Referenz auf das Spiel-Objekt
  Star[] stars = new Star[150];  // Array für 150 Sterne als Hintergrund-Animation
  Button backButton;  // Button zum Zurückkehren ins Hauptmenü
  Button[] levels = new Button[9];  // Array für die 9 Level-Buttons
  float alpha = 0;  // Transparenzwert für den Leuchteffekt des Titels
  PImage levelImage;  // Hintergrundbild für den Levelscreen

  // Konstruktor: Initialisiert den LevelScreen mit Spielreferenz
  LevelScreen(Game g) {
    this.game = g;  // Speichert die Referenz zum Game-Objekt
    levelImage = loadImage("./data./Weltall-4.png"); // Laden des Hintergrundbilds

    // Erstellt die Sterne für den animierten Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Erstellt den "BACK"-Button in der oberen linken Ecke
    backButton = new Button(20, 20, 100, 40, "BACK");

    // Platzierung der Level-Buttons in einem 3x3-Raster
    int buttonWidth = 200;   // Breite der Buttons
    int buttonHeight = 50;   // Höhe der Buttons
    int gap = 20;            // Abstand zwischen den Buttons
    int startY = height / 2; // Startposition für die erste Button-Reihe

    // Erzeugt und positioniert die Level-Buttons dynamisch
    for (int i = 0; i < levels.length; i++) {
      int row = i / 3;  // Berechnet die Zeilenposition (0, 1 oder 2)
      int col = i % 3;  // Berechnet die Spaltenposition (0, 1 oder 2)

      // Berechnet die X- und Y-Positionen der Buttons
      int x = (int) (width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);

      // Erstellt den Button mit der berechneten Position und speichert ihn im Array
      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }

  // Zeigt den Levelscreen an, indem alle Elemente gezeichnet werden
  void display() {
    reset();  // Setzt ggf. vorherige Zustände zurück
    drawBackground();  // Zeichnet das Hintergrundbild und die Sterne
    drawTitle();  // Zeichnet den Titel mit Spezialeffekten

    // Zeichnet alle Level-Buttons
    for (Button level : levels) {
      level.display();
    }

    // Zeichnet den "BACK"-Button
    backButton.display();
  }

  // Zeichnet den Hintergrund mit den animierten Sternen
  void drawBackground() {
    image(levelImage, 0, 0, width, height); // Hintergrundbild für den Screen setzen

    // Aktualisiert und zeichnet die Sterne als Animation
    for (Star s : stars) {
      s.update(); // Aktualisiert die Position des Sterns
      s.show();   // Zeichnet den Stern
    }
  }

  // Zeichnet den Titel "CHOOSE A LEVEL" mit einer leuchtenden Animation
  void drawTitle() {
    textAlign(CENTER);  // Zentriert den Text horizontal
    textSize(95);  // Setzt die Schriftgröße

    // Berechnet den Leuchteffekt für die Schriftfarbe (Wert oszilliert zwischen 150 und 255)
    alpha = 150 + 105 * sin(millis() * 0.005);

    // Zeichnet die Umrandung des Titels
    fill(255, 255, 255, 180); // Weiße Schrift mit leicht transparenter Füllung
    stroke(10);  // Setzt die Linienfarbe für den Umriss
    strokeWeight(5);  // Setzt die Linienstärke
    text("CHOOSE A LEVEL", width / 2, height / 3); // Zeichnet den Text in der Mitte

    // Zeichnet den Leuchteffekt mit cyan-blauer Farbe
    fill(0, 255, 255, alpha);
    text("CHOOSE A LEVEL", width / 2, height / 3); // Zeichnet den Text erneut mit Leuchteffekt
  }

  // Behandelt Mausklicks und überprüft, ob ein Button gedrückt wurde
  void mousePressed() {
    // Prüft, ob der "BACK"-Button geklickt wurde
    if (backButton.isClicked()) {
      game.triggerTransition(0); // Wechselt zurück ins Hauptmenü
      reset();  // Setzt den Screen zurück, falls nötig
      return;  // Beendet die Methode, um weitere Prüfungen zu vermeiden
    }

    // Prüft, ob einer der Level-Buttons geklickt wurde
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].isClicked()) {
        println("Level " + (i + 1) + " Start!"); // Konsolenausgabe für Debugging
        game.switchLevel(i + 1);  // Wechselt zum gewählten Level
        game.triggerTransition(3);  // Startet eine Übergangsanimation
        reset();  // Setzt den Screen zurück, um Fehler zu vermeiden
        break;  // Bricht die Schleife ab, um unnötige Checks zu vermeiden
      }
    }
  }

  // Setzt den Levelscreen zurück, um Fehler und unerwartete Zustände zu verhindern
  void reset() {
    alpha = 0;  // Setzt den Leuchteffekt auf den Startwert zurück

    // Erstellt alle Sterne neu, um die Animation zurückzusetzen
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Erstellt den "BACK"-Button erneut (sorgt für eine frische Instanz)
    backButton = new Button(20, 20, 100, 40, "BACK");

    // Erneut die Buttons für die Level setzen, falls sich die Positionen geändert haben
    int buttonWidth = 200, buttonHeight = 50, gap = 20;
    int startY = height / 2;

    for (int i = 0; i < levels.length; i++) {
      int row = i / 3, col = i % 3;
      int x = (int) (width / 2 - (buttonWidth * 1.5) + col * (buttonWidth + gap));
      int y = startY + row * (buttonHeight + gap);
      levels[i] = new Button(x, y, buttonWidth, buttonHeight, "Level " + (i + 1));
    }
  }
}
