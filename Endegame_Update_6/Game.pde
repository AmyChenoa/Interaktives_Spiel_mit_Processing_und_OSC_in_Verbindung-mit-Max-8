// Definition der Klasse Game

class Game {
  // Aktueller Bildschirmstatus:
  // 0 = Start, 1 = Level, 2 = Hilfe, 3 = Spiel, 4 = Game Over, 5 = Win, 6 = Intro
  int screen = 0;

  // Hintergrundbild und Listen für Spielobjekte:
  PImage ImageBackground_1;
  ArrayList<Enemy> enemies; // Feinde im Spiel
  ArrayList<Bullet> playerBullets; // Schüsse des Spielers
  ArrayList<Bullet> enemyBullets; // Schüsse der Feinde
  ArrayList<PowerUp> powerUps; // PowerUps

  // Spielobjekte und Bildschirme
  Player player;
  StartScreen startScreen;
  LevelScreen levelScreen;
  HelpScreen helpScreen;
  GameOverScreen gameOverScreen;
  WinScreen winScreen;
  IntroScreen introScreen;

  // Übergangslogik:
  float transitionProgress = 0; // Fortschritt der Bildschirmübergangsanimation
  boolean isTransitioning = false; // Ist ein Übergang aktiv?
  int nextScreen = 0; // Nächster Bildschirm

  // Konstruktor
  Game() {
    // Initialisieren der Listen für Feinde, Schüsse, PowerUps
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();

    // Initialisieren der Bildschirmobjekte
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen();
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);
    player = new Player(); // Spieler erstellen
  }

  // Setup-Methode: Initialisierung des Spiels
  void setup() {
    // Hintergrundbild laden und auf Bildschirmgröße anpassen
    ImageBackground_1 = loadImage("./data./Weltall-1.png");
    ImageBackground_1.resize(width, height);

    resetGame(); // Spiel zurücksetzen
    frameRate(60); // Bildwiederholrate auf 60 FPS setzen
  }

  // Draw-Methode: Zeichnet den aktuellen Bildschirm
  void draw() {
    if (isTransitioning) {
      renderTransition(); // Wenn ein Übergang läuft, rendern wir die Übergangsanimation
    } else {
      renderScreen(); // Ansonsten den aktuellen Bildschirm rendern
    }
  }

  // Rendern des Übergangs zwischen Bildschirmen
  void renderTransition() {
    // Übergangsgeschwindigkeit (Interpolation)
    transitionProgress = lerp(transitionProgress, 1, 0.1);

    // Wenn der Übergang fast abgeschlossen ist, Bildschirm wechseln
    if (transitionProgress > 0.99) {
      isTransitioning = false;
      screen = nextScreen;
      transitionProgress = 0;
    }

    // Berechnen des Alpha-Werts für den Übergangseffekt
    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);

    pushStyle();

    // Aktuellen Bildschirm mit Fade-Out zeichnen
    tint(255, fadeOutAlpha);
    renderScreenContent(screen);

    // Nächsten Bildschirm mit Fade-In zeichnen
    tint(255, fadeInAlpha);
    renderScreenContent(nextScreen);

    popStyle();
  }

  // Zeichnet den aktuellen Bildschirminhalt
  void renderScreen() {
    renderScreenContent(screen);
  }

  // Zeigt den Inhalt des aktuellen Bildschirms basierend auf dem aktuellen Screen-Index
  void renderScreenContent(int currentScreen) {
    switch (currentScreen) {
    case 0:
      startScreen.display(); // Startbildschirm anzeigen
      break;
    case 1:
      levelScreen.display(); // Levelbildschirm anzeigen
      break;
    case 2:
      helpScreen.display(); // Hilfebildschirm anzeigen
      break;
    case 3:
      playGame(); // Spiel starten
      break;
    case 4:
      gameOverScreen.display(player.score); // Game Over-Bildschirm mit Punktzahl anzeigen
      break;
    case 5:
      winScreen.display(player.score); // Gewinn-Bildschirm mit Punktzahl anzeigen
      break;
    case 6:
      introScreen.update();  // Intro aktualisieren und anzeigen
      break;
    }
  }

  // Ereignis, wenn die Maus gedrückt wird (für Bildschirminteraktionen)
  void mousePressed() {
    if (screen == 0) startScreen.mousePressed();
    else if (screen == 1) levelScreen.mousePressed();
    else if (screen == 2) helpScreen.mousePressed();
    else if (screen == 6) introScreen.keyPressed();  // Intro bei Tastendruck reagieren
  }

  // Ereignis, wenn eine Taste gedrückt wird
  void keyPressed() {
    // Übergänge zu verschiedenen Bildschirmen basierend auf der gedrückten Taste
    if (screen == 0 && key == ENTER) {
      triggerTransition(6); // Übergang zum Intro-Bildschirm
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3); // Übergang zum Spiel nach dem Intro
    }
    if ((screen == 4 || screen == 5) && key == ENTER) {
      resetGame(); // Zurück zum Startbildschirm nach dem Spielende
      triggerTransition(0);
    }

    // Wenn der Spieler im Spiel ist und die Leertaste drückt, schießt er
    if (screen == 3 && key == ' ') {
      playerShoot(); // Spieler schießt
    }
  }

  // Initiieren eines Bildschirmübergangs
  void triggerTransition(int newScreen) {
    isTransitioning = true; // Übergang aktivieren
    nextScreen = newScreen; // Nächsten Bildschirm festlegen
  }

  // Spiel zurücksetzen
  void resetGame() {
    player.reset(); // Spieler zurücksetzen
    enemies.clear(); // Alle Feinde entfernen
    playerBullets.clear(); // Alle Spieler-Schüsse entfernen
    enemyBullets.clear(); // Alle Feind-Schüsse entfernen
    powerUps.clear(); // Alle PowerUps entfernen
    screen = 0; // Zum Startbildschirm wechseln
  }

  // Spieler schießt eine Kugel
  void playerShoot() {
    Bullet b = new Bullet(player.x, player.y, 0, -10, color(255, 0, 0)); // Neue Kugel erstellen
    playerBullets.add(b); // Zur Liste der Spieler-Schüsse hinzufügen
  }

  // Spiel-Logik: Update für das Spielgeschehen
  void playGame() {
    image(ImageBackground_1, 0, 0); // Hintergrundbild anzeigen
    player.update(); // Spieler-Update durchführen
    player.display(); // Spieler anzeigen
    drawHUD(); // HUD (Benutzeroberfläche) zeichnen

    // Feinde spawnen (jede Sekunde)
    if (frameCount % 60 == 0) {
      enemies.add(new Enemy(random(30, width - 30), random(20, 100))); // Neuen Feind hinzufügen
    }

    // Boss spawnen (alle 30 Sekunden)
    if (frameCount % (60 * 30) == 0) {
      enemies.add(new Boss(width / 2, 80, 50)); // Neuen Boss hinzufügen
    }

    // PowerUps spawnen (alle 500 Frames)
    if (frameCount % 500 == 0) {
      powerUps.add(new PowerUp(random(50, width - 50), random(50, height - 200), (int) random(1, 3)));
    }

    // PowerUps verwalten
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p); // PowerUp vom Spieler einsammeln
        powerUps.remove(i); // PowerUp entfernen
      }
    }

    // Feinde verwalten
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update(); // Feind-Update durchführen
      e.display(); // Feind anzeigen
      if (frameCount % 30 == 0) e.shoot(enemyBullets); // Feind schießt (alle 30 Frames)
      if (e.y > height) enemies.remove(i); // Feind ist aus dem Bildschirm, entfernen

      // Boss-Feinde speziell behandeln
      if (e instanceof Boss) {
        Boss boss = (Boss) e;
        boss.takeDamage(); // Schaden an Boss zufügen
        if (boss.isDead()) {
          enemies.remove(i); // Boss entfernen
          player.score += 500; // Bonuspunkte für den Boss-Kill
          triggerTransition(5); // Zum Gewinnbildschirm wechseln
        }
      }
    }

    // Spieler-Schüsse verwalten
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update(); // Schuss aktualisieren
      b.display(); // Schuss anzeigen
      // Kollision mit Feinden prüfen
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy e = enemies.get(j);
        if (dist(b.x, b.y, e.x, e.y) < e.size / 2) { // Kollision erkannt
          enemies.remove(j); // Feind entfernen
          player.score += 10; // Punkte für getöteten Feind
          playerBullets.remove(i); // Schuss entfernen
          break;
        }
      }
      if (b.y < 0) playerBullets.remove(i); // Schüsse, die den Bildschirm verlassen, entfernen
    }

    // Feind-Schüsse verwalten
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update(); // Schuss aktualisieren
      b.display(); // Schuss anzeigen
      // Kollision mit dem Spieler prüfen
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--; // Leben des Spielers verlieren
        enemyBullets.remove(i); // Feind-Schuss entfernen
        if (player.lives <= 0) {
          triggerTransition(4); // Game Over, Übergang zum Game Over-Bildschirm
        }
      }
      if (b.y > height) enemyBullets.remove(i); // Schüsse, die den Bildschirm verlassen, entfernen
    }
  }

  // Zeichnet die verbleibenden Leben des Spielers in Herzform
  void drawLives(float x, float y, float width, int lives) {
    for (int i = 0; i < lives; i++) {
      float xPos = x + i * (width + 8); // Position für jedes Herz berechnen

      fill(255, 0, 0); // Herzfarbe rot
      noStroke(); // Kein Rand

      // Beginne das Herz zu zeichnen
      beginShape();
      // Oben links
      vertex(xPos, y);
      bezierVertex(xPos - width / 2, y - width / 2, xPos - width, y + width / 2, xPos, y + width); // linke Seite des Herzens
      // Oben rechts
      bezierVertex(xPos + width, y + width / 2, xPos + width / 2, y - width / 2, xPos, y); // rechte Seite des Herzens
      endShape(CLOSE);
    }
  }

  // Zeichnet das HUD (Benutzeroberfläche im Spiel)
  void drawHUD() {
    fill(40, 40, 40, 200); // Hintergrund für das HUD
    noStroke();
    rect(10, 10, 270, 120, 20); // Rechteck für das HUD
    fill(0, 255, 255); // Textfarbe
    textSize(24); // Textgröße
    textAlign(CENTER, TOP);
    text("Punkte: " + player.score, 145, 20); // Punktestand anzeigen
    drawLives(100, 50, 22, player.lives); // Leben des Spielers anzeigen
  }
}  // <-- Ende der Game-Klasse
