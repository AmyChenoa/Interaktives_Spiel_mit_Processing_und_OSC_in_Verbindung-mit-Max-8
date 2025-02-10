class HelpScreen {
  Star[] stars = new Star[150];
  Button backButton;
  float alpha = 0;
  Game game;
  PImage HelpImage;

  HelpScreen(Game game) {
    this.game = game;
    HelpImage = loadImage("./data./HelpScreen.png");
    for (int i = 0; i < stars.length; i++) {
      stars[i] = new Star();
    }
    backButton = new Button(width / 2 - 100, height - 100, 200, 50, "BACK");
  }

  void display() {
    drawBackground();
    drawTitle();
    drawHelpText();
    backButton.display();
  }

  void drawBackground() {
    image(HelpImage, 0, 0, width, height);
    for (Star s : stars) {
      s.update();
      s.show();
    }
  }

  void drawTitle() {
    textAlign(CENTER);
    textSize(90);
    alpha = 150 + 105 * sin(millis() * 0.005);

    float textY = height / 3 - 50; // Verschiebt den Text nach oben

    fill(0, 0, 0, alpha);
    text("HOW TO PLAY", width / 2 + 5, textY + 5);

    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("HOW TO PLAY", width / 2, textY);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("HOW TO PLAY", width / 2, textY);

    fill(0, 255, 255, alpha);
    noStroke();
    text("HOW TO PLAY", width / 2, textY);
  }

  void drawHelpText() {
    textSize(28);
    float helpTextAlpha = 200;
    String[] helpTextLines = {
      "Move with Arrow Keys",
      "Shoot with SPACE",
      "Survive and destroy enemies!"
    };

    // Breite der längsten Zeile berechnen
    float maxTextWidth = 0;
    for (String line : helpTextLines) {
      maxTextWidth = max(maxTextWidth, textWidth(line));
    }

    // Padding für die Box
    float paddingX = 40;
    float paddingY = 30;

    // Höhe pro Zeile berechnen
    float lineHeight = textAscent() + textDescent() + 10;
    float boxWidth = maxTextWidth + paddingX * 2;
    float boxHeight = helpTextLines.length * lineHeight + paddingY * 2;

    // Position der Box
    float boxX = width / 2;
    float boxY = height / 2;

    // Hintergrund-Box zeichnen
    rectMode(CENTER); // Mitte als Bezugspunkt setzen
    fill(0, 0, 0, 180);
    stroke(255);
    strokeWeight(3);
    rect(boxX, boxY, boxWidth, boxHeight, 15);

    // Text ausrichten
    fill(255, 255, 255, helpTextAlpha);
    textAlign(CENTER, CENTER);

    // Erste Textzeile mittig setzen
    float textY = boxY - (helpTextLines.length * lineHeight) / 2 + lineHeight / 2;

    for (String line : helpTextLines) {
      text(line, boxX, textY);
      textY += lineHeight;
    }
  }
  void mousePressed() {
    if (backButton != null && backButton.isClicked()) {
      game.triggerTransition(0);
    }
  }
}
