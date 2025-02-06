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

    float boxWidth = 450;
    float boxHeight = helpTextLines.length * (textAscent() + textDescent() + 10) + 40;
    float boxX = width / 2 - boxWidth / 2;
    float boxY = height / 2 - boxHeight / 2 + 10; // Kästchen minimal nach oben verschoben

    fill(0, 0, 0, 180);
    stroke(255);
    strokeWeight(3);
    rect(boxX, boxY, boxWidth, boxHeight, 15);

    fill(255, 255, 255, helpTextAlpha);
    textAlign(CENTER, CENTER);
    float textY = boxY + 20 + 15; // Text um 15 Pixel tiefer verschieben
    for (String line : helpTextLines) {
      text(line, width / 2, textY);
      textY += textAscent() + textDescent() + 10;
    }
  }


  void mousePressed() {
    if (backButton != null && backButton.isClicked()) {
      game.triggerTransition(0);
    }
  }
}
