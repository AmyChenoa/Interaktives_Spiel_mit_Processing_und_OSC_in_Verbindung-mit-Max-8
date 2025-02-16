// Klasse zur Verwaltung einzelner Level im Spiel
class Level {
  int levelNumber;       // Speichert die Nummer des Levels
  int enemyCount;        // Anzahl der Gegner, die in diesem Level erscheinen
  int spawnRate;        // Wie oft neue Gegner erscheinen (höherer Wert = selteneres Spawning)
  boolean hasBoss;      // Gibt an, ob das Level einen Bossgegner hat
  ArrayList<PowerUp> powerUps; // Liste aller Power-Ups, die in diesem Level erscheinen können
  PImage background;    // Hintergrundbild für das Level
  float levelTime;      // Zeit (in Sekunden), die das Level dauert

  // Konstruktor: Erstellt ein Level mit der angegebenen Nummer
  Level(int levelNumber) {
    this.levelNumber = levelNumber;  // Setzt die Levelnummer
    this.powerUps = new ArrayList<>();  // Initialisiert die Liste der Power-Ups
    setupLevel();  // Ruft eine Methode auf, die das Level basierend auf der Nummer konfiguriert
  }

  // Diese Methode setzt alle relevanten Eigenschaften des Levels je nach Nummer
  void setupLevel() {
    switch (levelNumber) {
    case 1:
      background = loadImage("data./background1.png"); // Hintergrundbild für Level 1 laden
      enemyCount = 1; // Nur ein Gegner erscheint
      spawnRate = 250; // Relativ seltene Gegner-Spawns
      hasBoss = false; // Kein Bossgegner in diesem Level
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Ein Power-Up wird zufällig positioniert
      levelTime = 30; // Das Level dauert 30 Sekunden
      break;

    case 2:
      background = loadImage("data./background2.png");
      enemyCount = 1;
      spawnRate = 270;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Power-Up Typ 2 wird hinzugefügt
      levelTime = 35;
      break;

    case 3:
      background = loadImage("data./background3.png");
      enemyCount = 2; // Ab Level 3 erscheinen zwei Gegner
      spawnRate = 280;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Zwei verschiedene Power-Ups erscheinen
      levelTime = 40;
      break;

    case 4:
      background = loadImage("data./background4.png");
      enemyCount = 2;
      spawnRate = 300;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 45;
      break;

    case 5:
      background = loadImage("data./background5.png");
      enemyCount = 2;
      spawnRate = 320;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      levelTime = 50;
      break;

    case 6:
      background = loadImage("data./background6.png");
      enemyCount = 3; // Drei Gegner erscheinen
      spawnRate = 300;
      hasBoss = true; // Erster Bosskampf!
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 55;
      break;

    case 7:
      background = loadImage("data./background7.png");
      enemyCount = 2;
      spawnRate = 330;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 60;
      break;

    case 8:
      background = loadImage("data./background8.png");
      enemyCount = 2;
      spawnRate = 350;
      hasBoss = true; // Boss in Level 8
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 65;
      break;

    case 9:
      background = loadImage("data./background9.png");
      enemyCount = 1;
      spawnRate = 340;
      hasBoss = true; // Boss in Level 9
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 70;
      break;

    default: // Falls die Levelnummer nicht zwischen 1-9 liegt, Standardwerte setzen
      background = loadImage("data./Weltall-1.png"); // Standard-Hintergrundbild
      enemyCount = 1; // Nur ein Gegner
      spawnRate = 300;
      hasBoss = false;
      levelTime = 30;
      break;
    }

    // Prüfen, ob das Hintergrundbild erfolgreich geladen wurde
    if (background == null) {
      println("Fehler: Hintergrundbild für Level " + levelNumber + " nicht gefunden!");
    } else {
      println("Hintergrund für Level " + levelNumber + " erfolgreich geladen.");
    }
  }

  // Diese Methode bereitet das Level für den Start im Spiel vor
  void initializeLevel(Game game) {
    // Falls die Listen für Gegner oder Power-Ups noch nicht existieren, initialisieren
    if (game.enemies == null) game.enemies = new ArrayList<>();
    if (game.powerUps == null) game.powerUps = new ArrayList<>();

    // Hintergrundbild für das Spiel setzen
    game.backgroundImage = this.background;
    if (game.backgroundImage != null) {
      println("Hintergrund für Level " + levelNumber + " gesetzt.");
    } else {
      println("Fehler: Kein Hintergrundbild für Level " + levelNumber + " gefunden!");
    }

    // Alte Gegner und Power-Ups aus vorherigen Leveln entfernen
    game.enemies.clear();
    game.powerUps.clear();

    // Spielerposition und Status zurücksetzen
    game.player.reset();

    // Die festgelegte Anzahl an Gegnern erzeugen und der Spielliste hinzufügen
    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100))); // Positionen zufällig bestimmen
    }

    // Falls das Level einen Boss hat, wird er zusätzlich zum normalen Gegner-Spawn erzeugt
    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 50)); // Boss hat 50 HP
    }

    // Die Power-Ups des Levels zum Spiel hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }

    // Die verfügbare Zeit für das Level setzen
    game.timeRemaining = this.levelTime;
  }
}
