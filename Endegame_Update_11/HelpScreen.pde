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
    String helpText = "Move with Arrow Keys\nShoot with SPACE\nSurvive and destroy enemies!";

    // Split the help text into lines
    String[] helpTextLines = helpText.split("\n");

    // Calculate the width of the longest line to set the box width
    float boxWidth = 0;
    for (String line : helpTextLines) {
      boxWidth = max(boxWidth, textWidth(line));
    }
    boxWidth += 40; // Padding on both sides

    // Calculate the total height of the text block considering ascent and descent for each line
    float boxHeight = 0;
    for (String line : helpTextLines) {
      boxHeight += textAscent() + textDescent();
    }
    boxHeight += 20; // Padding above and below the text

    // Calculate the position of the text box (centered horizontally and vertically)
    float boxX = width / 2 - boxWidth / 2;  // Center horizontally
    float boxY = height / 2 - boxHeight / 2 + 50;  // Center vertically and move down slightly

    // Draw the background rectangle with more contrast (solid black)
    fill(0, 0, 0, 180);  // Slightly darker background
    rect(boxX, boxY, boxWidth, boxHeight, 10);

    // Calculate the Y position to vertically center the text
    float textY = boxY + (boxHeight / 2) + (textAscent() / 2) - 5;

    // Draw the text with a stronger stroke effect for better readability
    stroke(0);  // Dark stroke for the text
    strokeWeight(4);
    fill(255, 255, 255, helpTextAlpha);  // White text with alpha transparency
    noFill();

    // Draw each line of text, adjusting Y position for each line
    float lineY = textY - (helpTextLines.length - 1) * (textAscent() + textDescent()) / 2;
    for (String line : helpTextLines) {
      text(line, width / 2, lineY);  // Draw the current line
      lineY += textAscent() + textDescent();  // Update Y for next line
    }
  }


  void mousePressed() {
    if (backButton != null && backButton.isClicked()) {
      game.triggerTransition(0);
    }
  }
}
