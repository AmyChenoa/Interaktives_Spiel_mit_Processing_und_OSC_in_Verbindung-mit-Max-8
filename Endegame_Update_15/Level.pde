class Level {
  int levelNumber;
  int enemyCount;
  int spawnRate;
  boolean hasBoss;
  ArrayList<PowerUp> powerUps;
  PImage background;
  float levelTime;

  Level(int levelNumber) {
    this.levelNumber = levelNumber;
    this.powerUps = new ArrayList<>();
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
      levelTime = 30;
      break;

    case 2:
      background = loadImage("data./background2.png");
      enemyCount = 1;
      spawnRate = 270;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 35;
      break;

    case 3:
      background = loadImage("data./background3.png");
      enemyCount = 2;
      spawnRate = 280;
      hasBoss = false;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
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
      enemyCount = 3;
      spawnRate = 300;
      hasBoss = true;
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
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 65;
      break;

    case 9:
      background = loadImage("data./background9.png");
      enemyCount = 1;
      spawnRate = 340;
      hasBoss = true;
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 1));
      powerUps.add(new PowerUp(random(30, width - 30), random(20, 100), 2));
      levelTime = 70;
      break;

    default:
      background = loadImage("data./Weltall-1.png");
      enemyCount = 1;
      spawnRate = 300;
      hasBoss = false;
      levelTime = 30;
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
    if (game.enemies == null) game.enemies = new ArrayList<>();
    if (game.powerUps == null) game.powerUps = new ArrayList<>();

    game.backgroundImage = this.background;
    if (game.backgroundImage != null) {
      println("Hintergrund für Level " + levelNumber + " gesetzt.");
    } else {
      println("Fehler: Kein Hintergrundbild für Level " + levelNumber + " gefunden!");
    }

    game.enemies.clear();
    game.powerUps.clear();
    game.player.reset();

    for (int i = 0; i < enemyCount; i++) {
      game.enemies.add(new Enemy(random(30, width - 30), random(20, 100)));
    }

    if (hasBoss) {
      game.enemies.add(new Boss(random(30, width - 30), random(20, 100), 50));
    }

    for (PowerUp p : powerUps) {
      game.powerUps.add(p);
    }

    game.timeRemaining = this.levelTime;
  }
}
