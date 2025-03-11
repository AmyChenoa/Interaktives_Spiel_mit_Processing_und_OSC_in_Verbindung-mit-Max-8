// Klasse für den Intro-Bildschirm
class IntroScreen {
  Star[] stars = new Star[150]; // Array für animierte Sterne im Hintergrund
  Game game; // Referenz auf das Hauptspielobjekt
  float alpha = 0; // Transparenz für den Titeltext-Effekt
  float backgroundShift = 0; // Variabler Wert für Farbverlauf im Notfall (ohne Bild)
  float introProgress = 0; // Fortschritt des Ladebalkens (0 bis 1)
  boolean introFinished = false; // Kontrollvariable für das Ende des Intros
  PImage backgroundImage;  // Hintergrundbild für das Intro

  // Konstruktor: Initialisiert Sterne und lädt das Hintergrundbild
  IntroScreen(Game game) {
    this.game = game;

    // Sterne für den animierten Hintergrund initialisieren
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Hintergrundbild laden (ersetze ggf. den Dateinamen)
    backgroundImage = loadImage("data./intro_background.png");
  }

  // Zeigt das Intro an und steuert die Ladeanimation
  void showIntro() {

    drawBackground(); // Hintergrund mit Sternen animieren
    drawTitle(); // Titel "WELTRAUM-ABENTEUER" zeichnen
    drawStartText(); // Text "Das Spiel beginnt bald..." anzeigen

    // Ladebalken-Animation
    if (introProgress < 1) {
      introProgress += 0.005; // Fortschritt erhöhen
      drawLoadingBar(); // Ladebalken zeichnen
    } else {
      // Sobald der Ladebalken voll ist, beende das Intro
      if (!introFinished) {
        introFinished = true;
        delay(500); // Kurze Verzögerung für besseren Übergang
        game.triggerTransition(3); // Wechsel zur nächsten Szene (Spielstart)
      }
    }
  }

  // Zeichnet den Hintergrund mit Bild oder Farbverlauf
  void drawBackground() {
    if (backgroundImage != null) {
      image(backgroundImage, 0, 0, width, height); // Hintergrundbild skalieren
    } else {
      // Falls kein Bild vorhanden ist, nutze einen dynamischen Farbverlauf
      float r = 20 + 30 * sin(backgroundShift * 0.003);
      float g = 20 + 30 * cos(backgroundShift * 0.003);
      float b = 40 + 20 * sin(backgroundShift * 0.005);
      background(r, g, b);
    }

    // Sterne zeichnen
    for (Star s : stars) {
      s.update();
      s.show();
    }

    backgroundShift += 0.1; // Farbverlauf über Zeit leicht ändern
  }

  // Zeichnet den Titel "WELTRAUM-ABENTEUER" mit Blinkeffekt
  void drawTitle() {
    textAlign(CENTER);
    textSize(80);
    alpha = 150 + 105 * sin(millis() * 0.003); // Pulsierender Transparenzeffekt

    // Schwarzer Schatten für besseren Kontrast
    fill(0, 0, 0, alpha);
    text("SPACE-SHOOTER", width / 2 + 5, height / 4 + 5);

    // Haupttext in Gelb mit Umrandung
    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("SPACE-SHOOTER", width / 2, height / 4);

    // Leichtes cyanfarbenes Leuchten
    fill(0, 255, 255, alpha);
    noStroke();
    text("SPACE-SHOOTER", width / 2, height / 4);
  }

  // Zeigt den Hinweistext "Das Spiel beginnt bald..."
  void drawStartText() {
    textSize(40);
    float startTextAlpha = 150 + 105 * sin(millis() * 0.003); // Blinkeffekt

    float textX = width / 2;
    float textY = (height - 20) / 2 + 180; // Positionierung leicht nach unten

    // Schwarzer Schatten für den Text
    fill(0, 0, 0, startTextAlpha);
    text("Let the game begin...", textX + 3, textY + 3);

    // Rote Umrandung für bessere Lesbarkeit
    fill(255, 0, 0, startTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Let the game begin...", textX, textY);

    // Weißer Text als Hauptanzeige
    fill(255, 255, 255, startTextAlpha);
    noStroke();
    text("Let the game begin...", textX, textY);
  }

  // Zeichnet den Ladebalken für das Intro
  void drawLoadingBar() {
    float barWidth = 300;  // Breite des Balkens
    float barHeight = 20;  // Höhe des Balkens

    // Zentrierte Position mit leichter Verschiebung nach unten
    float x = (width - barWidth) / 2 + 150;
    float y = (height - barHeight) / 2 + 230;

    // Rahmen des Ladebalkens
    fill(50, 50, 50, 180); // Dunkler Hintergrund für den Balken
    stroke(255); // Weißer Rand für bessere Sichtbarkeit
    strokeWeight(2);
    rect(x, y, barWidth, barHeight, 10);

    // Fortschrittsbalken in Grün
    noStroke();
    fill(0, 255, 0);
    rect(x, y, barWidth * introProgress, barHeight, 10);
  }

  // Aktualisiert das Intro (wird regelmäßig aufgerufen)
  void update() {
    showIntro();
  }
  
  // Setzt das Intro auf den Anfangszustand zurück
void reset() {
    alpha = 0; 
    backgroundShift = 0;
    introProgress = 0;
    introFinished = false;

    // Sterne neu initialisieren (optional)
    for (int i = 0; i < stars.length; i++) {
        stars[i] = new Star();
    }
}

  // Falls der Spieler ENTER drückt, wird das Intro sofort beendet
  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;
      delay(500);
      game.triggerTransition(3); // Direkt zum Spiel starten
    }
  }
}
