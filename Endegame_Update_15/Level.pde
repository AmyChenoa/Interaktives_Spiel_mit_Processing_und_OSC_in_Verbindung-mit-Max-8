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
    this.powerUps = new ArrayList<>();
    this.platforms = new ArrayList<>();
    setupLevel(); // Direkt das Level konfigurieren
  }

  void setupLevel() {
    switch (levelNumber) {
      case 1:
        background = loadImage("data./background1.png");
        enemyCount = 1;
        spawnRate = 250;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        platforms.add(new Platform(100, 300, 150, 20));
        break;

      case 2:
        background = loadImage("data./background2.png");
        enemyCount = 1;
        spawnRate = 270;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(200, 250, 100, 20));
        break;

      case 3:
        background = loadImage("data./background3.png");
        enemyCount = 2;
        spawnRate = 280;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(150, 200, 120, 20));
        platforms.add(new Platform(250, 350, 130, 20));
        break;

      case 4:
        background = loadImage("data./background4.png");
        enemyCount = 2;
        spawnRate = 300;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(120, 270, 160, 20));
        break;

      case 5:
        background = loadImage("data./background5.png");
        enemyCount = 2;
        spawnRate = 320;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        platforms.add(new Platform(180, 220, 140, 20));
        break;

      case 6:
        background = loadImage("data./background6.png");
        enemyCount = 3;
        spawnRate = 300;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(100, 260, 130, 20));
        platforms.add(new Platform(250, 180, 110, 20));
        break;

      case 7:
        background = loadImage("data./background7.png");
        enemyCount = 2;
        spawnRate = 330;
        hasBoss = false;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(160, 210, 120, 20));
        break;

      case 8:
        background = loadImage("data./background8.png");
        enemyCount = 2;
        spawnRate = 350;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(200, 240, 130, 20));
        break;

      case 9:
        background = loadImage("data./background9.png");
        enemyCount = 1;
        spawnRate = 340;
        hasBoss = true;
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
        powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
        platforms.add(new Platform(150, 200, 150, 20));
        break;

      default:
        background = loadImage("data./Weltall-1.png");
        enemyCount = 1;
        spawnRate = 300;
        hasBoss = false;
        break;
    }

    // Fehlerprüfung für Hintergrundbild
    if (background == null) {
      println("Fehler: Hintergrundbild für Level " + levelNumber + " nicht gefunden!");
    } else {
      println("Hintergrund für Level " + levelNumber + " geladen.");
    }
  }

  void initializeLevel(Game game) {
    // Sicherstellen, dass die Listen nicht null sind
    if (game.platforms == null) game.platforms = new ArrayList<>();
    if (game.enemies == null) game.enemies = new ArrayList<>();
    if (game.powerUps == null) game.powerUps = new ArrayList<>();

    // Hintergrund setzen
    game.backgroundImage = this.background;
    if (game.backgroundImage != null) {
      println("Hintergrund für Level " + levelNumber + " gesetzt.");
    } else {
      println("Fehler: Kein Hintergrundbild für Level " + levelNumber + " gefunden!");
    }

    // Alte Objekte entfernen
    game.enemies.clear();
    game.powerUps.clear();
    game.platforms.clear();
    game.player.reset();

    // Plattformen hinzufügen
    for (Platform p : platforms) {
      game.platforms.add(p);
    }

    // Gegner hinzufügen
    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }

    // Boss hinzufügen, falls vorhanden
    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 50));
    }

    // PowerUps hinzufügen
    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }
  }
}

// Plattform-Klasse bleibt unverändert
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
