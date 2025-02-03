class WinScreen {
  void display(int score) { // Accepts score as a parameter
    background(0);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text("You Win!", width / 2, height / 3);
    text("Final Score: " + score, width / 2, height / 2);
    text("Press ENTER to Restart", width / 2, height * 2 / 3);
  }
}
