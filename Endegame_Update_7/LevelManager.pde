// Klasse LevelManager: Verwaltet alle Levels des Spiels
class LevelManager {
  Level[] levels = new Level[9]; // Array von Leveln (insgesamt 9 Levels)
  PImage Level1;



  // Konstruktor, der die Level-Daten initialisiert
  LevelManager() {
    // Initialisiere die Levels mit spezifischen Daten
    levels[0] = new Level(1, "./data./Weltall-1.png", 5, 2.0f, 0);    // Level 1: 5 Feinde, keine Bosse
    levels[1] = new Level(2, "./data./Weltall-1.png", 8, 2.5f, 0);    // Level 2: 8 Feinde, keine Bosse
    levels[2] = new Level(3, "./data./Weltall-1.png", 10, 3.0f, 0);   // Level 3: 10 Feinde, keine Bosse
    levels[3] = new Level(4, "./data./Weltall-1.png", 12, 3.5f, 50);  // Level 4: 12 Feinde, 50 Boss-Gesundheit
    levels[4] = new Level(5, "./data./Weltall-1.png", 15, 4.0f, 100); // Level 5: 15 Feinde, 100 Boss-Gesundheit
    levels[5] = new Level(6, "./data./Weltall-1.png", 18, 4.5f, 150); // Level 6: 18 Feinde, 150 Boss-Gesundheit
    levels[6] = new Level(7, "./data./Weltall-1.png", 20, 5.0f, 200); // Level 7: 20 Feinde, 200 Boss-Gesundheit
    levels[7] = new Level(8, "./data./Weltall-1.png", 25, 5.5f, 250); // Level 8: 25 Feinde, 250 Boss-Gesundheit
    levels[8] = new Level(9, "./data./Weltall-1.png", 30, 6.0f, 300); // Level 9: 30 Feinde, 300 Boss-Gesundheit
  }

  // Gibt das Level anhand der Levelnummer zurück (1-basiert)
  Level getLevel(int levelNumber) {
    if (levelNumber < 1 || levelNumber > levels.length) {
      println("Error: Invalid level number!");
      return null;
    }
    return levels[levelNumber - 1];  // Levelnummer ist 1-basiert, daher -1
  }
}
