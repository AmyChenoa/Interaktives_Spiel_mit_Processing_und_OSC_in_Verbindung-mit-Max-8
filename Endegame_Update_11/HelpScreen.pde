class HelpScreen {
  Star[] stars = new Star[150];
  Button backButton;
  float alpha = 0;
  Game game;
  PImage HelpImage;

  // Setup-Methode, um Bilder zu laden und UI zu initialisieren
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
    textSize(80);
    alpha = 150 + 105 * sin(millis() * 0.005);

    fill(0, 0, 0, alpha);
    text("HOW TO PLAY", width / 2 + 5, height / 3 + 5);

    fill(255, 0, 0);
    stroke(255, 0, 0);
    strokeWeight(10);
    text("HOW TO PLAY", width / 2, height / 3);

    fill(255, 255, 0);
    stroke(255, 255, 0);
    strokeWeight(5);
    text("HOW TO PLAY", width / 2, height / 3);

    fill(0, 255, 255, alpha);
    noStroke();
    text("HOW TO PLAY", width / 2, height / 3);
  }

  void drawHelpText() {
    textSize(20);
    float helpTextAlpha = 150 + 105 * sin(millis() * 0.005);

    fill(0, 0, 0, helpTextAlpha);
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2 + 3, height / 2 + 3);

    fill(255, 0, 0, helpTextAlpha);
    stroke(255, 0, 0);
    strokeWeight(4);
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);

    fill(255, 255, 255, helpTextAlpha);
    noStroke();
    text("Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!", width / 2, height / 2);
  }

  void mousePressed() {
    if (backButton != null && backButton.isClicked()) {
      game.triggerTransition(0);
    }
  }
}
