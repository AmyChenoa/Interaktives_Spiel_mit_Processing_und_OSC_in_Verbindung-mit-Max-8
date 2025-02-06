// Die Game-Klasse verwaltet das gesamte Spiel: Bildschirmwechsel, Spiellogik, Gegner, Spieler, Power-Ups und so weiter.
class Game {
  int screen = 0;  // Der aktuelle Bildschirm (0 = Startbildschirm, 1 = Level, etc.)
  PImage backgroundImage;  // Hintergrundbild für das Spiel
  ArrayList<Enemy> enemies;  // Liste der Gegner im Spiel
  ArrayList<Bullet> playerBullets;  // Liste der Spieler-Projektile
  ArrayList<Bullet> enemyBullets;  // Liste der Gegner-Projektile
  ArrayList<PowerUp> powerUps;  // Liste der Power-Ups im Spiel

  Player player;  // Das Spielerobjekt
  StartScreen startScreen;  // Startbildschirm
  LevelScreen levelScreen;  // Levelbildschirm
  HelpScreen helpScreen;  // Hilfe-Bildschirm
  GameOverScreen gameOverScreen;  // Game Over-Bildschirm
  WinScreen winScreen;  // Win-Bildschirm
  IntroScreen introScreen;  // Intro-Bildschirm

  Level level;  // Das aktuelle Level
  float transitionProgress = 0;  // Fortschritt der Übergangsanimation
  boolean isTransitioning = false;  // Gibt an, ob ein Übergang aktiv ist
  int nextScreen = 0;  // Der nächste Bildschirm, zu dem gewechselt werden soll

  // Konstruktor der Game-Klasse
  Game() {
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();

    // Erstellen der Bildschirm-Objekte
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this);
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);

    player = new Player();  // Erstellen des Spielerobjekts

    level = new Level(1, 6, 90, false); // Initialisieren des Levels
  }

  // Setup-Methode, die beim Start des Spiels aufgerufen wird
  void setup() {
    backgroundImage = loadImage("./data./Weltall-1.png");  // Hintergrundbild laden
    backgroundImage.resize(width, height);  // Größe des Hintergrundbilds anpassen
    resetGame();  // Spiel zurücksetzen
    frameRate(60);  // Framerate auf 60 setzen
  }

  // Hauptzeichnungsfunktion des Spiels
  void draw() {
    if (isTransitioning) {
      renderTransition();  // Zeigt den Übergang zwischen Bildschirmen an
    } else {
      renderScreen();  // Zeigt den aktuellen Bildschirm
    }
  }

  // Übergangsanimation zwischen Bildschirmen
  void renderTransition() {
    transitionProgress = lerp(transitionProgress, 1, 0.1);  // Übergang verlangsamen
    if (transitionProgress > 0.99) {
      isTransitioning = false;  // Übergang beenden
      screen = nextScreen;  // Setzt den neuen Bildschirm
      transitionProgress = 0;  // Setzt den Übergangsfortschritt zurück
    }
    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);  // Berechnet die Transparenz für den Fade-Out
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);  // Berechnet die Transparenz für den Fade-In
    pushStyle();
    tint(255, fadeOutAlpha);  // Setzt den Fade-Out Effekt
    renderScreenContent(screen);  // Zeichnet den aktuellen Bildschirm
    tint(255, fadeInAlpha);  // Setzt den Fade-In Effekt
    renderScreenContent(nextScreen);  // Zeichnet den nächsten Bildschirm
    popStyle();
  }

  // Rendert den aktuellen Bildschirm, wenn kein Übergang stattfindet
  void renderScreen() {
    renderScreenContent(screen);  // Zeichnet den aktuellen Bildschirm
  }

  // Zeigt den Inhalt des Bildschirms basierend auf der Bildschirmnummer
  void renderScreenContent(int currentScreen) {
    switch (currentScreen) {
    case 0:
      startScreen.display();  // Zeigt den Startbildschirm
      break;
    case 1:
      levelScreen.display();  // Zeigt den Levelbildschirm
      break;
    case 2:
      helpScreen.display();  // Zeigt den Hilfe-Bildschirm
      break;
    case 3:
      playGame();  // Zeigt das eigentliche Spiel
      break;
    case 4:
      gameOverScreen.display(player.score);  // Zeigt den Game Over-Bildschirm mit dem Punktestand
      break;
    case 5:
      winScreen.display(player.score);  // Zeigt den Win-Bildschirm mit dem Punktestand
      break;
    case 6:
      introScreen.update();  // Zeigt den Intro-Bildschirm
      break;
    }
  }

  // Wird aufgerufen, wenn die Maus gedrückt wird
  void mousePressed() {
    if (screen == 0) startScreen.mousePressed();  // Wenn auf dem Startbildschirm, drücke den Startbutton
    else if (screen == 1) levelScreen.mousePressed();  // Wenn auf dem Levelbildschirm, handle den Klick
    else if (screen == 2) helpScreen.mousePressed();  // Wenn auf dem Hilfe-Bildschirm, handle den Klick
    else if (screen == 6) introScreen.keyPressed();  // Wenn auf dem Intro-Bildschirm, handle den Tastendruck
  }

  // Wird aufgerufen, wenn eine Taste gedrückt wird
  void keyPressed() {
    if (screen == 0 && key == ENTER) {
      triggerTransition(6);  // Übergang zum Intro-Screen
    }
    if (screen == 6 && key == ENTER) {
      triggerTransition(3);  // Übergang zum Spiel-Screen
    }
    if ((screen == 4 || screen == 5) && key == ENTER) {
      resetGame();  // Setzt das Spiel zurück und startet einen neuen Versuch
      triggerTransition(0);  // Übergang zum Startbildschirm
    }
    if (screen == 3 && key == ' ') {
      player.shoot(playerBullets);  // Spieler schießt mit der Leertaste
    }
  }

  // Löst den Übergang zu einem neuen Bildschirm aus
  void triggerTransition(int newScreen) {
    isTransitioning = true;  // Aktiviert den Übergang
    nextScreen = newScreen;  // Setzt den nächsten Bildschirm
  }

  // Setzt das Spiel zurück
  void resetGame() {
    player.reset();  // Setzt den Spieler zurück
    enemies.clear();  // Löscht alle Gegner
    playerBullets.clear();  // Löscht alle Spieler-Projektile
    enemyBullets.clear();  // Löscht alle Gegner-Projektile
    powerUps.clear();  // Löscht alle Power-Ups
    screen = 0;  // Setzt den Bildschirm auf den Startbildschirm zurück
  }

  // Das eigentliche Spiel wird in dieser Methode abgerufen
  void playGame() {
    image(backgroundImage, 0, 0);  // Zeichnet das Hintergrundbild
    player.update();  // Aktualisiert die Spielerposition
    player.display();  // Zeichnet den Spieler
    drawHUD();  // Zeichnet die HUD (Punkte, Leben)

    // Erzeugt neue Gegner basierend auf der Spawnrate des Levels
    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));  // Neue Gegner zufällig erzeugen
      }
    }

    // Wenn der Level einen Boss hat, prüft, ob der Boss besiegt wurde
    if (level.hasBoss) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        if (enemies.get(i) instanceof Boss) {
          Boss boss = (Boss) enemies.get(i);  // Wenn der Gegner ein Boss ist
          boss.takeDamage();  // Reduziert die Lebenspunkte des Bosses
          if (boss.isDead()) {  // Wenn der Boss tot ist
            player.score += 500;  // Erhöht die Punktzahl des Spielers
            enemies.remove(i);  // Entfernt den Boss aus der Gegnerliste
            triggerTransition(5);  // Übergang zum Gewinnbildschirm
            break;
          }
        }
      }
    }

    // Power-Ups werden angezeigt und geprüft, ob sie eingesammelt wurden
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();  // Zeichnet das Power-Up
      if (p.isCollected(player.x, player.y)) {  // Überprüft, ob der Spieler das Power-Up eingesammelt hat
        player.collectPowerUp(p);  // Der Spieler sammelt das Power-Up ein
        powerUps.remove(i);  // Entfernt das Power-Up aus der Liste
      }
    }

    // Gegner werden aktualisiert und angezeigt
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();  // Aktualisiert die Position des Gegners
      e.display();  // Zeichnet den Gegner
      if (frameCount % 30 == 0) e.shoot(enemyBullets);  // Gegner schießen alle 30 Frames
      if (e.y > height) enemies.remove(i);  // Entfernt Gegner, die den Bildschirm verlassen haben
    }

    // Spieler-Projektile werden aktualisiert und angezeigt
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();  // Aktualisiert die Position des Projektile
      b.display();  // Zeichnet das Projektile
      if (b.isOutOfScreen()) playerBullets.remove(i);  // Entfernt das Projektile, wenn es den Bildschirm verlässt
    }

    // Gegner-Projektile werden aktualisiert und angezeigt
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();  // Aktualisiert die Position des Projektile
      b.display();  // Zeichnet das Projektile
      if (b.isOutOfScreen()) enemyBullets.remove(i);  // Entfernt das Projektile, wenn es den Bildschirm verlässt
    }
  }

  // Zeichnet das HUD (Punkte, Leben)
  void drawHUD() {
    textSize(30);
    fill(255);
    text("Score: " + player.score, 20, 40);  // Zeigt den Punktestand des Spielers an
    text("Lives: " + player.lives, width - 150, 40);  // Zeigt die verbleibenden Leben des Spielers an
  }





  void drawPowerUpTimer(float x, float y, float barWidth, float barHeight, float timer, float maxTimer, color barColor) {
    float timerProgress = timer / maxTimer;
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6);
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6);
    // Timer-Balken (innerer farbiger Bereich)
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6); // Timer-Balken nur mit fortschreitendem Wert

    // Weiße Umrandung
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6); // Weiße Umrandung
  }
}
