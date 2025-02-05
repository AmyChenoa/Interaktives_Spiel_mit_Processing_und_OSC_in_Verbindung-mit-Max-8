class Level {
  int levelNumber;  // Level-Nummer
  int enemyCount;   // Anzahl der Feinde
  int spawnRate;    // Spawnrate der Feinde
  boolean hasBoss;  // Gibt an, ob ein Boss im Level ist
  ArrayList<PowerUp> powerUps;
  Game game;

  // Konstruktor für das Level
  Level(int levelNumber, int enemyCount, int spawnRate, boolean hasBoss) {
    this.levelNumber = levelNumber;
    this.enemyCount = enemyCount;
    this.spawnRate = spawnRate;
    this.hasBoss = hasBoss;
    powerUps = new ArrayList<>();
  }

  // Methode zur Initialisierung des Levels
  void initializeLevel(Game game) {
    game.enemies.clear();  // Alle vorherigen Feinde entfernen
    game.powerUps.clear(); // Alle vorherigen Power-Ups entfernen
    game.player.reset();   // Spieler zurücksetzen
    game.player.score = 0; // Punktestand zurücksetzen

    // Feinde spawnen
    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100))); // Feinde zufällig platzieren
    }

    // Boss spawnen, wenn der Level einen Boss hat
    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 100));  // Beispiel Boss
    }

    // Beispiel für das Hinzufügen eines Power-Ups im Level 9 mit einem Typ
    if (levelNumber == 9) {
      int type = 1;  // Beispiel: Wir setzen den Typ auf 1 für das Power-Up
      game.powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), type));
    }
  }

  // Zusätzliche Funktionen, z.B. um Hindernisse hinzuzufügen oder spezifische Feindarten zu erzeugen
}
