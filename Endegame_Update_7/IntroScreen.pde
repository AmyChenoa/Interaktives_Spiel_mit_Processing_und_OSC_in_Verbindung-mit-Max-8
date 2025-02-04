// Definition der Klasse IntroScreen

class IntroScreen {
  Star[] stars = new Star[150];  // Array von Sternen für den Hintergrund
  Game game;  // Referenz auf das Game-Objekt, um die Übergänge zu steuern
  float alpha = 0;  // Transparenzwert für die Textanimationen
  float backgroundShift = 0;  // Wert für die Bewegung des Hintergrunds
  float introProgress = 0;  // Fortschritt des Ladebalkens
  boolean introFinished = false;  // Flag, um zu erkennen, ob das Intro abgeschlossen ist

  // Konstruktor: Initialisiert das Game-Objekt und die Sterne
  IntroScreen(Game game) {
    this.game = game;  // Referenz auf das Game-Objekt zuweisen

    // Initialisiert die Sterne für den Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Erstelle 150 Sterne für den Hintergrund
    }
  }

  // Zeigt das Intro an
  void showIntro() {
    // Hintergrundanimation mit sanften Bewegungen und Farbänderungen
    drawBackground();

    // Animation für den Titeltext
    drawTitle();

    // Start-Text mit pulsierender Transparenz
    drawStartText();

    // Ladebalken ohne Pulsieren, langsam fortschreitend
    if (introProgress < 1) {
      introProgress += 0.005; // Langsame Steigerung des Ladefortschritts
      drawLoadingBar(width / 2 - 100, height * 3 / 4, 200, 20);  // Zeigt den Ladebalken an
    } else {
      // Wenn der Ladebalken voll ist und das Intro noch nicht abgeschlossen ist
      if (!introFinished) {
        introFinished = true;  // Markiere das Intro als abgeschlossen
        delay(500);  // Kurze Pause für einen Übergangseffekt
        game.triggerTransition(3);  // Übergang zum Spiel (Bildschirm 3)
      }
    }
  }

  // Zeichnet den Hintergrund mit sanften Farben und bewegenden Sternen
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

  // Zeichnet den Titeltext "WELTRAUM-ABENTEUER" mit pulsierenden Effekten
  void drawTitle() {
    textAlign(CENTER);  // Text wird zentriert
    textSize(80);  // Setzt die Textgröße auf 80 für den Titel

    // Berechnet eine pulsierende Transparenz für den Titel
    alpha = 150 + 105 * sin(millis() * 0.003);  // Sinusfunktion für dynamische Transparenz

    // Mehrere Schatteneffekte für den Titel
    fill(0, 0, 0, alpha);  // Schatten in Schwarz
    text("WELTRAUM-ABENTEUER", width / 2 + 5, height / 4 + 5);  // Schatten 1
    fill(0, 0, 0, alpha - 50);  // Etwas weniger Transparenz
    text("WELTRAUM-ABENTEUER", width / 2 + 8, height / 4 + 8);  // Schatten 2
    fill(0, 0, 0, alpha - 100);  // Noch weniger Transparenz
    text("WELTRAUM-ABENTEUER", width / 2 + 12, height / 4 + 12);  // Schatten 3

    // Umrandung des Textes mit weichen, leuchtenden Farben
    fill(255, 255, 0);  // Gelbe Farbe
    stroke(255, 255, 0);  // Gelbe Umrandung
    strokeWeight(5);  // Dicke der Umrandung
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);  // Text mit gelber Umrandung

    // Türkisfarbener, leicht transparenter Text ohne Umrandung
    fill(0, 255, 255, alpha);  // Türkis mit pulsierender Transparenz
    noStroke();  // Keine Umrandung
    text("WELTRAUM-ABENTEUER", width / 2, height / 4);  // Endgültiger Text
  }

  // Zeichnet den Start-Text mit pulsierender Transparenz
  void drawStartText() {
    textSize(30);  // Kleinere Schriftgröße für den Starttext
    float startTextAlpha = 150 + 105 * sin(millis() * 0.003);  // Pulsierende Transparenz für den Text

    // Start-Text mit mehreren Effekten (Schatten, Umrandung, Text)
    fill(0, 0, 0, startTextAlpha);  // Schatten in Schwarz
    text("Das Spiel beginnt bald...", width / 2 + 3, height / 2 + 3);  // Schatten
    fill(255, 0, 0, startTextAlpha);  // Rote Umrandung
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Das Spiel beginnt bald...", width / 2, height / 2);  // Text mit roter Umrandung
    fill(255, 255, 255, startTextAlpha);  // Weißer Text
    noStroke();
    text("Das Spiel beginnt bald...", width / 2, height / 2);  // Endgültiger Text
  }

  // Zeichnet einen Ladebalken für den Fortschritt
  void drawLoadingBar(float x, float y, float width, float height) {
    noStroke();
    fill(50, 50, 50);  // Hintergrund des Ladebalkens (dunkelgrau)
    rect(x, y, width, height);  // Zeichnet den Hintergrund des Ladebalkens

    // Ladefortschritt (grün)
    fill(0, 255, 0);
    rect(x, y, width * introProgress, height);  // Füllt den Ladebalken basierend auf dem Fortschritt
  }

  // Wird kontinuierlich aufgerufen, um das Intro anzuzeigen
  void update() {
    showIntro();  // Zeigt das Intro an
  }

  // Startet das Spiel sofort, wenn die ENTER-Taste gedrückt wird
  void keyPressed() {
    if (key == ENTER) {
      introFinished = true;  // Markiert das Intro als abgeschlossen
      delay(500);  // Kurze Pause für einen Übergangseffekt
      game.triggerTransition(3);  // Übergang zum Spiel (Bildschirm 3)
    }
  }
}
