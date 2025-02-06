class Level {
  int levelNumber;
  int enemyCount;
  int spawnRate;
  boolean hasBoss;
  ArrayList<PowerUp> powerUps;
  ArrayList<Platform> platforms;
  PImage background;

  Level(int levelNumber) {
    this.levelNumber = levelNumber;
    powerUps = new ArrayList<>();
    platforms = new ArrayList<>();
    // Set the number of enemies and spawn rate based on the level
    setLevelAttributes();
  }

  void setLevelAttributes() {
    // Define the attributes based on the level
    switch (levelNumber) {
    case 1:
      enemyCount = 1;
      spawnRate = 250;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      platforms.add(new Platform(100, 300, 150, 20));
      break;
    case 2:
      enemyCount = 1;
      spawnRate = 270;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(200, 250, 100, 20));
      break;
    case 3:
      enemyCount = 2;
      spawnRate = 280;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(150, 200, 120, 20));
      platforms.add(new Platform(250, 350, 130, 20));
      break;
    case 4:
      enemyCount = 2;
      spawnRate = 300;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(120, 270, 160, 20));
      break;
    case 5:
      enemyCount = 2;
      spawnRate = 320;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      platforms.add(new Platform(180, 220, 140, 20));
      break;
    case 6:
      enemyCount = 3;
      spawnRate = 300;
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(100, 260, 130, 20));
      platforms.add(new Platform(250, 180, 110, 20));
      break;
    case 7:
      enemyCount = 2;
      spawnRate = 330;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(160, 210, 120, 20));
      break;
    case 8:
      enemyCount = 2;
      spawnRate = 350;
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(200, 240, 130, 20));
      break;
    case 9:
      enemyCount = 1;
      spawnRate = 340;
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      platforms.add(new Platform(150, 200, 150, 20));
      break;
    default:
      enemyCount = 1;
      spawnRate = 300;
      hasBoss = false;
      break;
    }
  }

  // Method to return the current level number
  int getLevelNumber() {
    return levelNumber;
  }

  void initializeLevel(Game game) {
    game.enemies.clear();
    game.powerUps.clear();
    if (game.platforms != null) {
      game.platforms.clear();
    } else {
      println("Die Plattformen-Liste ist null!");
    }

    game.player.reset();

    // Überprüfen, ob die Plattformen korrekt hinzugefügt wurden
    if (platforms.isEmpty()) {
      println("Warnung: Keine Plattformen für dieses Level!");
    } else {
      for (Platform p : platforms) {
        game.platforms.add(p);
      }
    }

    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }

    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 50));
    }

    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}


class Platform {
  float x, y, width, height;

  Platform(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
  }

  void display() {
    fill(150, 75, 0);
    rect(x, y, width, height);
  }
}
