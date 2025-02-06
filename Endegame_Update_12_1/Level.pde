class Level {
  int levelNumber;
  int enemyCount;
  int spawnRate;
  boolean hasBoss;
  ArrayList<PowerUp> powerUps;

  // Konstruktor für das Level
  Level(int levelNumber, int enemyCount, int spawnRate, boolean hasBoss) {
    this.levelNumber = levelNumber;
    this.enemyCount = enemyCount;
    this.spawnRate = spawnRate;
    this.hasBoss = hasBoss;
    this.powerUps = new ArrayList<>();

    // Leichtere Level mit weniger Gegnern, langsamerer Spawnrate und mehr Power-Ups
    switch (levelNumber) {
      case 1: // Sehr einfacher Start, nur 1-2 Gegner und langsame Spawnrate
        enemyCount = 2;
        spawnRate = 180;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 2: // Weniger Gegner und langsame Spawnrate
        enemyCount = 3;
        spawnRate = 160;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 3: // Ein leichter Boss und weniger Gegner
        enemyCount = 3;
        spawnRate = 140;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 4: // Noch weniger Feinde und eine extrem langsame Spawnrate
        enemyCount = 2;
        spawnRate = 200;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 5: // Mehr Power-Ups und weniger Gegner
        enemyCount = 3;
        spawnRate = 150;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 6: // Einfacher Boss, weniger Gegner und langsame Spawnrate
        enemyCount = 3;
        spawnRate = 160;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 7: // Sehr wenige Gegner und viele Power-Ups
        enemyCount = 2;
        spawnRate = 200;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 8: // Chaos-Level, aber mit wenigen Gegnern und vielen Power-Ups
        enemyCount = 2;
        spawnRate = 200;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 9: // Finaler Boss, aber mit wenigen Gegnern und vielen Power-Ups
        enemyCount = 2;
        spawnRate = 150;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      default:
        // Standardwerte für andere Levels
        enemyCount = 3;
        spawnRate = 150;
        hasBoss = false;
        break;
    }
  }

  // Methode zur Initialisierung des Levels
  void initializeLevel(Game game) {
    game.enemies.clear();
    game.powerUps.clear();
    game.player.reset();
    
    // Feinde spawnen
    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }
    
    // Boss spawnen, falls vorhanden
    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 100)); // Einfacher Boss mit 100 HP
    }

    // Power-Ups hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}
