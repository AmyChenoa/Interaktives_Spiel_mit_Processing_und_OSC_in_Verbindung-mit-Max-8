class Level {
  int levelNumber;
  int enemyCount;
  int spawnRate;
  boolean hasBoss;
  ArrayList<PowerUp> powerUps;
  Game game;

  // Konstruktor für das Level
  Level(int levelNumber, int enemyCount, int spawnRate, boolean hasBoss) {
    this.levelNumber = levelNumber;
    this.enemyCount = enemyCount;
    this.spawnRate = spawnRate;
    this.hasBoss = hasBoss;
    powerUps = new ArrayList<>();

    // Jedes Level hat eigene Eigenschaften
    switch (levelNumber) {
    case 1: // Einfacher Start
      enemyCount = 3;
      spawnRate = 120;
      hasBoss = false;
      break;
    case 2: // Mehr Gegner, aber langsame Spawnrate
      enemyCount = 5;
      spawnRate = 100;
      hasBoss = false;
      break;
    case 3: // Erstes Boss-Level
      enemyCount = 4;
      spawnRate = 90;
      hasBoss = true;
      break;
    case 4: // Viele kleine Feinde
      enemyCount = 8;
      spawnRate = 70;
      hasBoss = false;
      break;
    case 5: // Mehr Power-Ups
      enemyCount = 5;
      spawnRate = 80;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild-Power-Up
      break;
    case 6: // Schwierigeres Boss-Level
      enemyCount = 6;
      spawnRate = 75;
      hasBoss = true;
      break;
    case 7: // Extrem viele Gegner, aber sehr langsam
      enemyCount = 10;
      spawnRate = 150;
      hasBoss = false;
      break;
    case 8: // Chaos-Level mit schnellem Spawn
      enemyCount = 6;
      spawnRate = 50;
      hasBoss = false;
      break;
    case 9: // Finaler Boss
      enemyCount = 4;
      spawnRate = 60;
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
      break;
    }
  }

  // Methode zur Initialisierung des Levels
  void initializeLevel(Game game) {
    game.enemies.clear();
    game.powerUps.clear();
    game.player.reset();
    game.player.score = 0;

    // Feinde spawnen
    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }

    // Boss spawnen, falls vorhanden
    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 200));
    }

    // Power-Ups hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}
