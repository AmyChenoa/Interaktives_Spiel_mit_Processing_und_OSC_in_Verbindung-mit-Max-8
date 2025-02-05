// Definition der Klasse HelpScreen
class HelpScreen {
  Star[] stars = new Star[150];  // Array für Sterne im Hintergrund
  Button backButton;  // Zurück-Button, um zum vorherigen Bildschirm zu wechseln
  float alpha = 0;  // Variable für die pulsierende Transparenz der Texte
  Game game;  // Referenz auf das Game-Objekt, um den Bildschirm zu wechseln

  // Konstruktor: Initialisiert die Sterne im Hintergrund und den Zurück-Button
  HelpScreen(Game game) {
    this.game = game;  // Referenz auf das Game-Objekt speichern, um den Bildschirm zu wechseln

    // Initialisiert die Sterne im Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();  // Erstellt 150 Sterne für den Hintergrund
    }

    // Erstellt den Zurück-Button
    backButton = new Button(width / 2 - 100, height - 100, 200, 50, "BACK");  // Button für den Zurück-Button
  }

  // Zeigt den Hilfe-Bildschirm an
  void display() {
    // Hintergrundanimation (Sterne bewegen sich)
    drawBackground();

    // Titeltext mit pulsierendem Effekt
    drawTitle();

    // Hilfe-Text mit pulsierender Transparenz
    drawHelpText();

    // Button anzeigen
    backButton.display();  // Zeigt den Zurück-Button an
  }

  // Zeichnet den Hintergrund mit bewegenden Sternen
  void drawBackground() {
    background(0);  // Setzt den Hintergrund auf schwarz
    for (Star s : stars) {
      s.update();  // Aktualisiert die Position jedes Sterns
      s.show();    // Zeigt den Stern an
    }
  }

  // Zeichnet den Titeltext "HOW TO PLAY" mit pulsierenden Effekten
  void drawTitle() {
    textAlign(CENTER);  // Zentriert den Text
    textSize(80);  // Setzt die Textgröße auf 80 für den Titel

    // Pulsierender Effekt für den Titel
    alpha = 150 + 105 * sin(millis() * 0.005);  // Sinusfunktion für pulsierende Transparenz

    // Mehrere Schatteneffekte für den Titel
    fill(0, 0, 0, alpha);
    text("HOW TO PLAY", width / 2 + 5, height / 3 + 5);  // Schatten 1
    fill(0, 0, 0, alpha - 50);
    text("HOW TO PLAY", width / 2 + 8, height / 3 + 8);  // Schatten 2
    fill(0, 0, 0, alpha - 100);
    text("HOW TO PLAY", width / 2 + 12, height / 3 + 12);  // Schatten 3

    // Umrandung des Textes
    fill(255, 0, 0);  // Rote Farbe
    stroke(255, 0, 0);  // Rote Umrandung
    strokeWeight(10);  // Dicke der Umrandung
    text("HOW TO PLAY", width / 2, height / 3);  // Text mit roter Umrandung

    fill(255, 255, 0);  // Gelbe Farbe für die Umrandung
    stroke(255, 255, 0);  // Gelbe Umrandung
    strokeWeight(5);  // Dünnere Umrandung
    text("HOW TO PLAY", width / 2, height / 3);  // Text mit gelber Umrandung

    // Fetter, leuchtender türkiser Text ohne Umrandung
    fill(0, 255, 255, alpha);  // Türkis mit pulsierender Transparenz
    noStroke();  // Keine Umrandung
    text("HOW TO PLAY", width / 2, height / 3);  // Endgültiger Text
  }

  // Zeichnet den Hilfetext mit Anweisungen
  void drawHelpText() {
    textSize(20);  // Kleinere Schrift für die Hilfestellung
    float helpTextAlpha = 150 + 105 * sin(millis() * 0.005);  // Pulsierender Effekt für den Hilfetext

    // Hilfetext mit mehreren Effekten (Schatten, Umrandung und Text)
    fill(0, 0, 0, helpTextAlpha);
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2 + 3, height / 2 + 3);  // Schatten

    fill(255, 0, 0, helpTextAlpha);
    stroke(255, 0, 0);  // Rote Umrandung
    strokeWeight(4);
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);  // Text mit roter Umrandung

    fill(255, 255, 255, helpTextAlpha);
    noStroke();  // Keine Umrandung
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);  // Haupttext ohne Umrandung
  }

  // Überprüft, ob der Zurück-Button geklickt wurde
  void mousePressed() {
    if (backButton.isClicked()) {
      game.triggerTransition(0);  // Wechselt zum Hauptbildschirm (Index 0)
    }
  }
}
