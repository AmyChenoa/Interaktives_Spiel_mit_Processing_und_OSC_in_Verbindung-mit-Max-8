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
      case 1: // Sehr einfach, nur 1 Gegner
        enemyCount = 1;
        spawnRate = 200; // Sehr langsame Spawnrate
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 2: // Nur 1 Gegner, langsame Spawnrate
        enemyCount = 1;
        spawnRate = 220;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 3: // 1 Gegner und Power-Ups
        enemyCount = 1;
        spawnRate = 250;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 4: // Sehr einfach, 2 Gegner, langsame Spawnrate
        enemyCount = 2;
        spawnRate = 250;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 5: // Noch weniger Feinde und langsame Spawnrate
        enemyCount = 2;
        spawnRate = 300;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 6: // Wenige Gegner und einfacher Boss
        enemyCount = 2;
        spawnRate = 280;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        break;
      case 7: // Wenige Gegner, aber viele Power-Ups
        enemyCount = 2;
        spawnRate = 300;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 8: // Chaos-Level, aber mit wenigeren Gegnern und vielen Power-Ups
        enemyCount = 1;
        spawnRate = 350;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 9: // Finaler Boss, aber sehr wenige Gegner
        enemyCount = 1;
        spawnRate = 300;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild Power-Up
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      default:
        // Standardwerte für andere Levels
        enemyCount = 1;
        spawnRate = 300;
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
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 50)); // Einfacher Boss mit 50 HP
    }

    // Power-Ups hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}
