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
      case 1: // Einfacher Start, nur 1-2 Gegner
        enemyCount = 2;
        spawnRate = 150;
        hasBoss = false;
        break;
      case 2: // Mehr Gegner, aber sehr langsame Spawnrate
        enemyCount = 3;
        spawnRate = 140;
        hasBoss = false;
        break;
      case 3: // Erstes Boss-Level, aber weniger Feinde
        enemyCount = 3;
        spawnRate = 120;
        hasBoss = true;
        break;
      case 4: // Noch weniger Feinde, aber langsame Spawnrate
        enemyCount = 4;
        spawnRate = 130;
        hasBoss = false;
        break;
      case 5: // Mehr Power-Ups
        enemyCount = 3;
        spawnRate = 100;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1)); // Schild-Power-Up
        break;
      case 6: // Boss-Level mit wenigen Feinden
        enemyCount = 4;
        spawnRate = 110;
        hasBoss = true;
        break;
      case 7: // Sehr wenige Gegner, aber Power-Ups
        enemyCount = 2;
        spawnRate = 150;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2)); // Extra Leben Power-Up
        break;
      case 8: // Chaos-Level, aber nur wenige Gegner
        enemyCount = 3;
        spawnRate = 180;
        hasBoss = false;
        break;
      case 9: // Finaler Boss, aber wenig Gegner
        enemyCount = 2;
        spawnRate = 100;
        hasBoss = true;
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
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 200)); // Boss mit 200 HP
    }

    // Power-Ups hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}
