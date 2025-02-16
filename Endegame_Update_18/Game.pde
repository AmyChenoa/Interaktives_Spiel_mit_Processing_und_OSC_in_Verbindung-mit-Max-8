class Game {
  // Variable zur Speicherung des höchsten Punktestands
  int highScore;

  // Referenz auf das PApplet-Objekt, das das Hauptprogramm enthält (nicht initialisiert)
  PApplet parent;

  // Variable zur Steuerung des aktuellen Bildschirmzustands
  // 0 = Startbildschirm, 3 = Spielbildschirm, 4 = Game Over, 5 = Sieg, 6 = Intro
  int screen = 0;

  // Hintergrundbild für das jeweilige Level
  PImage backgroundImage;

  // Listen zur Verwaltung von Spielobjekten
  ArrayList<Enemy> enemies;       // Liste der aktiven Gegner im Spiel
  ArrayList<Bullet> playerBullets; // Liste der vom Spieler abgefeuerten Kugeln
  ArrayList<Bullet> enemyBullets;  // Liste der von Gegnern abgefeuerten Kugeln
  ArrayList<PowerUp> powerUps;     // Liste der im Spiel befindlichen Power-Ups

  // Variable zur Speicherung des aktuellen Levels, beginnt bei Level 1
  int currentLevel = 1;

  // Boolean-Wert zur Überprüfung, ob der Kampagnenmodus aktiv ist
  boolean campaignMode = false;

  // Objekte für verschiedene Bildschirme
  Player player;                     // Spielerobjekt
  StartScreen startScreen;            // Startbildschirm
  LevelScreen levelScreen;            // Level-Auswahlbildschirm
  HelpScreen helpScreen;              // Hilfebildschirm
  GameOverScreen gameOverScreen;      // Bildschirm für "Game Over"
  WinScreen winScreen;                // Bildschirm für "Spiel gewonnen"
  IntroScreen introScreen;            // Einführungsbildschirm vor Spielstart

  Level level;  // Aktuelles Level-Objekt

  // Variablen für Bildschirmübergänge
  float transitionProgress = 0; // Fortschritt der Bildschirmübergänge (0 = kein Übergang, 1 = abgeschlossen)
  boolean isTransitioning = false; // Gibt an, ob ein Übergang gerade läuft
  int nextScreen = 0; // Speichert, zu welchem Bildschirm gewechselt wird

  // HashMap zur Speicherung der Zeitlimits für jedes Level
  HashMap<Integer, Float> levelTimers;

  // Variable zur Speicherung der verbleibenden Zeit im aktuellen Level
  float timeRemaining;

  // Gibt an, ob das Level abgeschlossen wurde
  boolean levelCompleted = false;

  // Gibt an, ob das Spiel gestartet wurde
  boolean gameStarted = false;

  // Variablen für die Anzeige der verbleibenden Spielzeit als Balken
  float levelTimeBarWidth = 500;
  float levelTimeBarHeight = 20;
  float levelTimeBarX = 300;
  float levelTimeBarY = 15;

  // Konstruktor der Game-Klasse
  Game() {
    // Initialisieren der ArrayLists
    enemies = new ArrayList<>();
    playerBullets = new ArrayList<>();
    enemyBullets = new ArrayList<>();
    powerUps = new ArrayList<>();

    // Erstellen der Bildschirmobjekte
    startScreen = new StartScreen(this);
    levelScreen = new LevelScreen(this);
    helpScreen = new HelpScreen(this);
    gameOverScreen = new GameOverScreen(this);
    winScreen = new WinScreen(this);
    introScreen = new IntroScreen(this);

    // Erstellen des Spielerobjekts und Initialisieren des ersten Levels
    player = new Player();
    level = new Level(1);

    // Laden des gespeicherten Highscores
    loadHighScore();

    // Initialisieren der Level-Timer für insgesamt 9 Levels (30 Sekunden pro Level)
    levelTimers = new HashMap<>();
    for (int i = 1; i <= 9; i++) {
      levelTimers.put(i, 30.0);
    }

    // Setzen der Startzeit für das erste Level
    timeRemaining = levelTimers.get(currentLevel);
  }

  // Methode zum Starten der Kampagne (Story-Modus)
  void startCampaign() {
    campaignMode = true;    // Kampagnenmodus aktivieren
    currentLevel = 1;       // Startlevel setzen
    loadLevel(currentLevel); // Erstes Level laden
    screen = 3;             // Zum Spielbildschirm wechseln
    gameStarted = true;     // Spiel als gestartet markieren
  }

  // Methode zum Laden eines spezifischen Levels
  void loadLevel(int levelNumber) {
    level = new Level(levelNumber);        // Neues Level-Objekt erstellen
    level.initializeLevel(this);           // Level mit Feinden und Umgebung initialisieren
    backgroundImage = level.background;    // Hintergrundbild setzen
    timeRemaining = levelTimers.get(levelNumber); // Zeit für das Level setzen
    gameStarted = true; // Sicherstellen, dass das Spiel läuft
  }

  // Methode, die aufgerufen wird, wenn ein Level abgeschlossen wurde
  void levelCompleted() {
    if (campaignMode) {
      if (currentLevel < 9) { // Falls noch nicht das letzte Level erreicht wurde
        currentLevel++;       // Zum nächsten Level wechseln
        loadLevel(currentLevel);
      } else {
        triggerTransition(5); // Kampagne gewonnen -> Zum Sieg-Bildschirm wechseln
      }
    } else {
      triggerTransition(5); // Bei anderen Modi direkt zum Gewinn-Bildschirm wechseln
    }
  }

  // Methode zur Verarbeitung von Tasteneingaben
  void keyPressed() {
    if (screen == 0 && key == ENTER) {  // Falls im Startbildschirm ENTER gedrückt wird
      campaignMode = true;
      triggerTransition(6);  // Zuerst das Intro anzeigen
    }

    if (screen == 6 && key == ENTER) { // Falls ENTER im Intro gedrückt wird
      startCampaign();  // Kampagne starten
    }

    if (screen == 4 && (key == ENTER || key == '\n')) { // Falls im "Game Over"-Bildschirm ENTER gedrückt wird
      resetGame();    // Spiel zurücksetzen
      triggerTransition(0); // Zurück zum Startbildschirm
    }

    if (screen == 5 && (key == ENTER || key == '\n')) { // Falls im "Sieg"-Bildschirm ENTER gedrückt wird
      resetGame();    // Spiel zurücksetzen
      triggerTransition(0); // Zurück zum Startbildschirm
    }

    if (screen == 3 && key == ' ') { // Falls im Spiel die Leertaste gedrückt wird
      player.shoot(playerBullets); // Spieler schießt eine Kugel
    }
  }

  // Methode zum Laden des gespeicherten Highscores
  void loadHighScore() {
    try {
      String[] data = loadStrings("highscore.txt"); // Highscore aus Datei laden
      if (data != null && data.length > 0) { // Falls Daten vorhanden sind
        highScore = Integer.parseInt(data[0].trim()); // Highscore als Integer speichern
      }
    }
    catch (Exception e) { // Falls Fehler auftreten (z. B. Datei nicht vorhanden)
      highScore = 0; // Highscore auf 0 setzen
    }
  }

  // Methode zum Speichern des Highscores in einer Datei
  void saveHighScore() {
    String[] data = {str(highScore)}; // Highscore in String umwandeln
    saveStrings("highscore.txt", data); // Highscore in Datei speichern
  }


  // Methode zur Initialisierung des Spiels
  void setup() {
    // Setzt das Hintergrundbild auf das des aktuellen Levels
    backgroundImage = level.background;

    // Ändert die Größe des Hintergrundbildes auf die aktuelle Fenstergröße
    backgroundImage.resize(width, height);

    // Setzt das Spiel zurück (z. B. Initialisierung von Spielern, Gegnern etc.)
    resetGame();

    // Setzt die Bildrate auf 60 FPS, um flüssige Animationen zu gewährleisten
    frameRate(60);

    // Setzt die verbleibende Zeit für das aktuelle Level basierend auf dem Level-Timer
    timeRemaining = levelTimers.get(level.levelNumber);

    // Gibt eine Debug-Nachricht aus, die das geladene Level und die verfügbare Zeit anzeigt
    println("Neues Level geladen: " + level.levelNumber + ", Zeit: " + timeRemaining);
    
     sound.sendSound("ambient");
  }

  // Methode, die in jeder Frame-Aktualisierung ausgeführt wird
  void draw() {
    // Falls ein Übergang zwischen Bildschirmen läuft, wird dieser gezeichnet
    if (isTransitioning) {
      renderTransition();
    } else {
      // Falls ein Hintergrundbild existiert, wird es skaliert und gezeichnet
      if (backgroundImage != null) {
        backgroundImage.resize(width, height);
        image(backgroundImage, 0, 0, width, height);
      } else {
        // Falls kein Hintergrundbild gesetzt wurde, wird eine Fehlermeldung ausgegeben
        println("Kein Hintergrundbild gesetzt!");
      }

      // Zeichnet den aktuellen Bildschirm basierend auf dem Spielstatus
      renderScreen();
    }
  }

  // Methode zur Darstellung der verbleibenden Zeit als Fortschrittsbalken
  void drawLevelTimerBar(float x, float y, float height) {
    // Falls sich das Spiel nicht im Spielmodus befindet, wird die Timerleiste nicht gezeichnet
    if (screen != 3) return;

    float margin = 20;  // Abstand zum Rand
    float barWidth = width - (x + margin); // Stellt sicher, dass der Balken korrekt berechnet wird

    y += 20; // Verschiebt den Balken nach unten für bessere Sichtbarkeit

    // Setzt die Farbe für den Timer-Text auf Weiß
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);

    // Zeichnet die Beschriftung für die Zeitleiste
    text("Remaining Time", x + barWidth / 2, y - 15);

    // Berechnet die Breite des Fortschrittsbalkens basierend auf der verbleibenden Zeit
    float progressWidth = map(timeRemaining, 0, levelTimers.get(level.levelNumber), barWidth, 0);

    // Zeichnet den Hintergrundbalken (grau, halbtransparent)
    fill(220, 220, 220, 150);
    noStroke();
    rect(x, y, barWidth, height, 10);

    // Zeichnet den Fortschrittsbalken in Orange
    fill(255, 165, 0, 220);
    rect(x, y, progressWidth, height, 10);
  }

  // Startet das Spiel, indem es den Spielstatus auf aktiv setzt
  void startGame() {
    gameStarted = true;
  }

  // Löst einen Bildschirmübergang aus
  void triggerTransition(int newScreen) {
    nextScreen = newScreen;  // Speichert, zu welchem Bildschirm gewechselt werden soll
    isTransitioning = true;  // Setzt den Übergang auf aktiv
    transitionProgress = 0;  // Setzt den Fortschritt des Übergangs auf den Anfang
  }

  // Methode zur Darstellung eines Bildschirmübergangs
  void renderTransition() {
    // Nutzt eine lineare Interpolation (lerp), um den Übergangsfortschritt zu berechnen
    transitionProgress = lerp(transitionProgress, 1, 0.1);

    // Sobald der Übergang fast abgeschlossen ist, wird der neue Bildschirm gesetzt
    if (transitionProgress > 0.99) {
      isTransitioning = false;
      screen = nextScreen;
      transitionProgress = 0;
      println("Transition beendet! Neuer Screen: " + screen);
    }

    // Berechnet die Transparenz für den Ausblend- und Einblendeffekt
    float fadeOutAlpha = map(transitionProgress, 0, 1, 255, 0);
    float fadeInAlpha = map(transitionProgress, 0, 1, 0, 255);

    pushStyle();  // Speichert den aktuellen Zeichenstil

    // Falls ein Übergang läuft, werden beide Bildschirme überlagert gezeichnet
    if (isTransitioning) {
      tint(255, fadeOutAlpha);   // Setzt die Transparenz für den aktuellen Bildschirm
      renderScreenContent(screen);
      tint(255, fadeInAlpha);    // Setzt die Transparenz für den neuen Bildschirm
      renderScreenContent(nextScreen);
    } else {
      renderScreenContent(screen); // Falls kein Übergang, einfach den aktuellen Bildschirm zeichnen
    }

    popStyle();  // Stellt den vorherigen Zeichenstil wieder her
  }

  // Ruft die Methode zum Rendern des aktuellen Screens auf
  void renderScreen() {
    renderScreenContent(screen);
  }

  // Zeichnet den Inhalt des aktuellen Bildschirms
  void renderScreenContent(int currentScreen) {
    println("Aktueller Screen: " + currentScreen);  // Debugging-Ausgabe des aktuellen Bildschirms

    // Verwendet eine Switch-Anweisung, um den passenden Bildschirm anzuzeigen
    switch (currentScreen) {
    case 0:
      startScreen.display(); // Startbildschirm
      break;
    case 1:
      levelScreen.display(); // Levelauswahlbildschirm
      break;
    case 2:
      helpScreen.display(); // Hilfebildschirm
      break;
    case 3:
      playGame(); // Spielbildschirm (enthält Hauptspielmechaniken)
      break;
    case 4:
      gameOverScreen.display(player.score); // Spiel-Verloren-Bildschirm mit Punktestand
      break;
    case 5:
      println("WinScreen wird gezeichnet!");
      winScreen.display(player.score); // Spiel-Gewonnen-Bildschirm mit Punktestand
      break;
    case 6:
      introScreen.update(); // Introbildschirm aktualisieren
      break;
    }
  }

  // Wechselt das aktuelle Level und initialisiert es neu
  void switchLevel(int newLevelNumber) {
    level = new Level(newLevelNumber);  // Erstellt ein neues Level-Objekt mit der angegebenen Nummer
    level.initializeLevel(this);        // Initialisiert das Level mit Gegnern, Power-Ups usw.
    backgroundImage = level.background; // Setzt das Hintergrundbild auf das neue Level
    timeRemaining = levelTimers.get(newLevelNumber); // Setzt die neue verbleibende Zeit
    gameStarted = true;  // Markiert das Spiel als gestartet
  }

  // Hauptspiel-Loop: Wird jedes Frame aufgerufen, um das Spielgeschehen zu aktualisieren
  void playGame() {
    // Überprüft, ob ein Hintergrundbild existiert
    if (backgroundImage != null) {
      backgroundImage.resize(width, height);  // Skaliert das Hintergrundbild auf die aktuelle Fenstergröße
      image(backgroundImage, 0, 0);  // Zeichnet das Hintergrundbild
    } else {
      println("Kein Hintergrundbild in playGame() gesetzt!"); // Falls kein Hintergrundbild vorhanden ist, Debug-Meldung ausgeben
    }

    // Aktualisiert den Timer für das Level (reduziert verbleibende Zeit)
    if (timeRemaining > 0) {
      timeRemaining -= 1 / frameRate;  // Reduziert die verbleibende Zeit basierend auf der Framerate
    } else {
      levelCompleted();  // Falls die Zeit abläuft, wird die Level-Abschluss-Logik aufgerufen
    }

    // Zeichnet die Fortschrittsleiste für den Timer
    drawLevelTimerBar(levelTimeBarX, levelTimeBarY, levelTimeBarHeight);

    // Aktualisiert und zeichnet den Spieler
    player.update();
    player.display();

    // Zeichnet das HUD (z. B. Punkte, Leben)
    drawHUD();

    // Überprüfung, ob das aktuelle Level abgeschlossen wurde
    if (timeRemaining <= 0) {
      if (currentLevel < 9) {  // Falls noch Level übrig sind
        currentLevel++;  // Erhöht das Level
        loadLevel(currentLevel);  // Lädt das nächste Level
      } else {
        triggerTransition(5);  // Falls letztes Level beendet, wird der Gewinn-Screen aufgerufen
      }
    }

    // Gegner spawnen in einem bestimmten Rhythmus
    if (frameCount % level.spawnRate == 0) {
      for (int i = 0; i < level.enemyCount; i++) {  // Spawnt eine bestimmte Anzahl an Gegnern
        enemies.add(new Enemy(random(30, width - 30), random(20, 100)));  // Erstellt Gegner an zufälligen Positionen
      }
    }

    // Aktualisiert und zeichnet Power-Ups
    for (int i = powerUps.size() - 1; i >= 0; i--) {
      PowerUp p = powerUps.get(i);
      p.display();  // Zeichnet das Power-Up

      // Überprüft, ob der Spieler das Power-Up einsammelt
      if (p.isCollected(player.x, player.y)) {
        player.collectPowerUp(p);  // Wendet den Power-Up-Effekt auf den Spieler an
        powerUps.remove(i);  // Entfernt das Power-Up aus der Liste
      }
    }

    // Aktualisiert und zeichnet Gegner
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy e = enemies.get(i);
      e.update();  // Aktualisiert Gegnerposition
      e.display();  // Zeichnet den Gegner

      // Gegner schießen alle 30 Frames eine Kugel ab
      if (frameCount % 30 == 0) {
        e.shoot(enemyBullets);
      }

      // Entfernt Gegner, falls sie den unteren Rand des Bildschirms erreichen
      if (e.y > height) {
        enemies.remove(i);
      }
    }

    // Aktualisiert und zeichnet die Spieler-Projektile
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      Bullet b = playerBullets.get(i);
      b.update();  // Aktualisiert die Position der Kugel
      b.display();  // Zeichnet die Kugel

      // Überprüfung auf Kollision mit Gegnern
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy e = enemies.get(j);
        if (bulletHitsEnemy(b, e)) {  // Falls die Kugel einen Gegner trifft
          enemies.remove(j);  // Entfernt den getroffenen Gegner
          playerBullets.remove(i);  // Entfernt die Kugel
          player.score += 10;  // Erhöht den Punktestand des Spielers
          break;  // Beendet die Überprüfung, um doppelte Treffer zu vermeiden
        }
      }
    }

    // Aktualisiert und zeichnet die feindlichen Projektile
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      b.update();  // Aktualisiert die Position der Kugel
      b.display();  // Zeichnet die Kugel

      // Überprüfung auf Kollision mit dem Spieler
      if (dist(b.x, b.y, player.x, player.y) < 15 && !player.shieldActive) {
        player.lives--;  // Reduziert die Leben des Spielers
        enemyBullets.remove(i);  // Entfernt die Kugel

        // Falls der Spieler keine Leben mehr hat, wird das Spiel beendet
        if (player.lives <= 0) {
          triggerTransition(4);  // Wechselt zum Game Over-Screen
        }
      }
    }
  }

  // Methode zur Überprüfung, ob eine Kugel einen Gegner trifft
  boolean bulletHitsEnemy(Bullet bullet, Enemy enemy) {
    // Berechnet den Abstand zwischen Kugel und Gegner und prüft, ob er innerhalb der Trefferzone liegt
    return dist(bullet.x, bullet.y, enemy.x, enemy.y) < enemy.size / 2;
  }

  // Methode zur Verarbeitung von Maus-Klicks
  void mousePressed() {
    // Falls sich das Spiel auf dem Startbildschirm befindet
    if (screen == 0) {
      startScreen.mousePressed();  // Reagiert auf Klicks im Startbildschirm
    }
    // Falls sich das Spiel auf dem Level-Auswahlbildschirm befindet
    else if (screen == 1) {
      levelScreen.mousePressed();  // Reagiert auf Klicks im Levelbildschirm
    }
    // Falls sich das Spiel auf dem Hilfe-Bildschirm befindet
    else if (screen == 2) {
      helpScreen.mousePressed();  // Reagiert auf Klicks im Hilfe-Bildschirm
    }
    // Falls sich das Spiel auf dem Intro-Bildschirm befindet
    else if (screen == 6) {
      introScreen.keyPressed();  // Startet das Spiel durch eine Tasteneingabe im Intro-Screen
    }
    // Falls sich das Spiel auf dem Game-Over oder Win-Screen befindet
    else if (screen == 4 || screen == 5) {
      resetGame();  // Setzt das Spiel zurück
      triggerTransition(0);  // Wechselt zurück zum Startbildschirm
    }
  }

  // Setzt das Spiel auf den Anfangszustand zurück
  void resetGame() {
    println("resetGame() wurde aufgerufen!"); // Debug-Ausgabe zur Überprüfung des Resets

    // Setzt den Spieler zurück (z. B. Position, Leben, Power-Ups)
    player.reset();

    // Leert alle Listen, um Spielfiguren, Projektile und Power-Ups zu entfernen
    enemies.clear();
    playerBullets.clear();
    enemyBullets.clear();
    powerUps.clear();

    // Erstellt ein neues Level-Objekt und setzt die Zeit für das Level zurück
    level = new Level(1); // Startet das Spiel wieder mit Level 1
    timeRemaining = levelTimers.get(1); // Setzt den Timer basierend auf Level 1

    // Setzt wichtige Spielvariablen zurück
    levelCompleted = false;  // Markiert das Level als nicht abgeschlossen
    gameStarted = false;  // Stellt sicher, dass das Spiel nicht sofort startet
    transitionProgress = 0;  // Setzt den Übergangseffekt zurück
    isTransitioning = false;  // Setzt die Übergangsanimation zurück

    // Speichert den Highscore, bevor das Spiel zurückgesetzt wird
    saveHighScore();

    // Wechselt zurück zum Startbildschirm
    screen = 0;
    println("Spiel zurückgesetzt. Neuer Screen: " + screen); // Debugging-Ausgabe

    // Löst ein Neuzeichnen des Bildschirms aus
    redraw();
  }

  // Zeichnet die Leben des Spielers als kleine Herzsymbole auf dem HUD
  void drawLives(float x, float y, float width, int lives) {
    for (int i = 0; i < lives; i++) {
      float xPos = x + i * (width + 8); // Berechnet die Position für jedes Leben
      fill(255, 0, 0); // Rot für Herzen
      noStroke();
      beginShape();
      vertex(xPos, y);
      bezierVertex(xPos - width / 2, y - width / 2, xPos - width, y + width / 2, xPos, y + width);
      bezierVertex(xPos + width, y + width / 2, xPos + width / 2, y - width / 2, xPos, y);
      endShape(CLOSE);
    }

    // Zeigt Power-Up-Timer an, falls Power-Ups aktiv sind
    if (player.shieldTimer > frameCount) {
      drawPowerUpTimer(20, 80, 230, 12, player.shieldTimer - frameCount, player.maxShieldTimer, color(100, 180, 255)); // Blau für Schild
    }
    if (player.multiShotTimer > frameCount) {
      drawPowerUpTimer(20, 100, 230, 12, player.multiShotTimer - frameCount, player.maxMultiShotTimer, color(150, 255, 100)); // Grün für Multi-Shot
    }
  }

  // Zeichnet das HUD (Heads-Up Display) mit Punktestand und Leben
  void drawHUD() {
    rectMode(CORNER);  // Stellt sicher, dass Rechtecke von der oberen linken Ecke aus gezeichnet werden
    fill(40, 40, 40, 200); // Dunkelgrauer Hintergrund mit Transparenz
    noStroke();
    rect(10, 10, 270, 120, 20); // Hintergrund-Box des HUDs

    // Zeichnet den Punktestand
    fill(255); // Weiße Schrift
    textSize(24);
    textAlign(CENTER, TOP);
    text("Punkte: " + player.score, 145, 20); // Zentrierter Punktetext

    // Zeichnet die Leben des Spielers als Symbole
    drawLives(100, 50, 22, player.lives);
  }

  // Zeichnet den Fortschrittsbalken für ein aktives Power-Up
  void drawPowerUpTimer(float x, float y, float barWidth, float barHeight, float timer, float maxTimer, color barColor) {
    float timerProgress = timer / maxTimer; // Berechnet den Fortschritt des Timers als Prozentwert

    // Zeichnet den inneren farbigen Balken, abhängig von der verbleibenden Zeit
    fill(barColor);
    rect(x, y, barWidth * timerProgress, barHeight, 6); // Breite abhängig vom Fortschritt

    // Zeichnet eine weiße Umrandung um den Fortschrittsbalken
    stroke(255);
    noFill();
    rect(x, y, barWidth, barHeight, 6);
  }
}
