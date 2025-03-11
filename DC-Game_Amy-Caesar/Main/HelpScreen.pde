// Klasse für den Hilfe-Bildschirm (Anleitung zum Spiel)
class HelpScreen {
  Star[] stars = new Star[150]; // Array für animierte Sterne im Hintergrund
  Button backButton; // Button zum Zurückkehren zum Hauptmenü
  float alpha = 0; // Variable für Transparenzeffekte beim Titeltext
  Game game; // Referenz auf das Hauptspielobjekt
  PImage HelpImage; // Hintergrundbild für den Hilfe-Bildschirm

  // Konstruktor: Initialisiert die Hilfe-Seite mit Hintergrund, Sternen und Zurück-Button
  HelpScreen(Game game) {
    this.game = game;
    HelpImage = loadImage("./data./HelpScreen.png"); // Lädt das Hilfe-Bild

    // Initialisiert die Sterne für den animierten Hintergrund
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }

    // Erstellt den "BACK"-Button in der unteren Mitte des Bildschirms
    backButton = new Button(width / 2 - 100, height - 100, 200, 50, "BACK");
  }

  // Zeichnet den gesamten Hilfebildschirm
  void display() {
    drawBackground(); // Zeichnet den Hintergrund und die Sterne
    drawTitle(); // Zeichnet den "HOW TO PLAY"-Titel mit Leuchteffekt
    drawHelpText(); // Zeigt die Steuerungshinweise an
    backButton.display(); // Zeichnet den Zurück-Button
  }

  // Zeichnet den Hintergrund mit dem Hilfe-Bild und animierten Sternen
  void drawBackground() {
    image(HelpImage, 0, 0, width, height); // Zeichnet das Bild über den gesamten Bildschirm

    // Aktualisiert und zeichnet alle Sterne für den Hintergrundeffekt
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  // Zeichnet den Titel "HOW TO PLAY" mit einem Blink- und Schatteneffekt
  void drawTitle() {
    textAlign(CENTER); // Zentrierte Ausrichtung
    textSize(90); // Große Schrift für Aufmerksamkeit
    alpha = 150 + 105 * sin(millis() * 0.005); // Blink-Effekt basierend auf Zeit

    float textY = height / 3 - 50; // Positioniert den Text weiter oben

    // Schwarzer Schatten hinter dem Text für bessere Lesbarkeit
    fill(0, 0, 0, alpha);
    text("HOW TO PLAY", width / 2 + 5, textY + 5);

    // Haupttext in Rot mit roter Umrandung
    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("HOW TO PLAY", width / 2, textY);

    // Gelbe Umrandung für einen 3D-Effekt
    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("HOW TO PLAY", width / 2, textY);

    // Transparente cyanfarbene Schicht für ein Leuchten
    fill(0, 255, 255, alpha);
    noStroke();
    text("HOW TO PLAY", width / 2, textY);
  }

  // Zeigt die Steuerungsanweisungen in einer zentralen Box
  void drawHelpText() {
    textSize(28);
    float helpTextAlpha = 200; // Transparenz für den Text

    // Anweisungen für die Steuerung
    String[] helpTextLines = {
      "Move with Arrow Keys",
      "Shoot with SPACE",
      "Survive and destroy enemies!"
    };

    // Berechnet die Breite der längsten Textzeile
    float maxTextWidth = 0;
    for (String line : helpTextLines) {
      maxTextWidth = max(maxTextWidth, textWidth(line));
    }

    // Abstand für die Hintergrundbox
    float paddingX = 40;
    float paddingY = 30;

    // Höhe einer Textzeile inklusive Abstand
    float lineHeight = textAscent() + textDescent() + 10;
    float boxWidth = maxTextWidth + paddingX * 2;
    float boxHeight = helpTextLines.length * lineHeight + paddingY * 2;

    // Position der Box
    float boxX = width / 2;
    float boxY = height / 2;

    // Zeichnet die schwarze Hintergrundbox mit abgerundeten Ecken
    rectMode(CENTER);
    fill(0, 0, 0, 180); // Halbtransparente schwarze Box
    stroke(255);
    strokeWeight(3);
    rect(boxX, boxY, boxWidth, boxHeight, 15);

    // Zeichnet den weißen Text in der Box
    fill(255, 255, 255, helpTextAlpha);
    textAlign(CENTER, CENTER);

    // Positioniert die erste Textzeile
    float textY = boxY - (helpTextLines.length * lineHeight) / 2 + lineHeight / 2;
    for (String line : helpTextLines) {
      text(line, boxX, textY);
      textY += lineHeight; // Verschiebt die nächste Zeile nach unten
    }
  }

  // Überprüft, ob der Zurück-Button angeklickt wurde, und geht zurück zum Hauptmenü
  void mousePressed() {
    if (backButton != null && backButton.isClicked()) {
      game.triggerTransition(0); // Wechselt zum Hauptmenü
    }
  }
}
