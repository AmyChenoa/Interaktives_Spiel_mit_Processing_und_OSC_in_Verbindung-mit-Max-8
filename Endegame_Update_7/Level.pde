// Klasse Level: Speichert die Daten eines einzelnen Levels
class Level {
    int levelNumber;              // Nummer des Levels
    String backgroundImagePath;   // Pfad zum Hintergrundbild des Levels
    int enemyCount;               // Anzahl der Feinde im Level
    float enemySpeed;             // Geschwindigkeit der Feinde im Level
    int bossHealth;               // Gesundheit des Bosses im Level (0 = kein Boss)

    // Konstruktor, der die Daten eines Levels setzt
    Level(int levelNumber, String backgroundImagePath, int enemyCount, float enemySpeed, int bossHealth) {
        this.levelNumber = levelNumber;
        this.backgroundImagePath = backgroundImagePath;
        this.enemyCount = enemyCount;
        this.enemySpeed = enemySpeed;
        this.bossHealth = bossHealth;
    }
}
