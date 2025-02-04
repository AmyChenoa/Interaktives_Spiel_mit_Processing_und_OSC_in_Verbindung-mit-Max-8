class LevelManager {
  int currentLevel; // Aktuelles Level
  int totalLevels; // Gesamtzahl der Level
  boolean levelCompleted; // Ob das aktuelle Level abgeschlossen wurde
  Game game; // Referenz auf das Spiel-Objekt

  // Konstruktor
  LevelManager(int totalLevels, Game game) {
    this.totalLevels = totalLevels;
    this.game = game; // Referenz auf das Game-Objekt
    currentLevel = 1; // Start beim ersten Level
    levelCompleted = false;
  }

  // Methode, die das Level lädt
  void loadLevel(int levelNumber) {
    currentLevel = levelNumber;  // Setzt das aktuelle Level
    println("Level " + currentLevel + " geladen");
    // Hier kannst du weitere Logik hinzufügen, um das Level zu initialisieren
  }


  // Setzt das Level zurück, wenn der Spieler stirbt oder ein Level abgeschlossen wird
  void resetLevel() {
    levelCompleted = false; // Level noch nicht abgeschlossen
    // Weitere Reset-Logik hier hinzufügen, falls nötig (z. B. zurücksetzen von Feinden, Power-Ups, etc.)
  }

  // Nächstes Level starten
  void nextLevel() {
    if (currentLevel < totalLevels) {
      currentLevel++; // Nächstes Level setzen
      resetLevel(); // Level zurücksetzen
      // Weitere Logik für das Starten des neuen Levels, z. B. Feinde hinzufügen, Power-Ups einstellen, etc.
    } else {
      // Wenn das letzte Level erreicht wurde, vielleicht das Spiel beenden oder den Spieler zum Gewinn-Bildschirm bringen
      triggerWin();
    }
  }

  // Überprüfen, ob das Level abgeschlossen ist (z. B. wenn alle Feinde besiegt wurden)
  void checkLevelCompletion() {
    // Zugriff auf die Feinde im Game-Objekt
    if (game.enemies.isEmpty()) { // Annahme: enemies ist die Liste der Feinde im Game
      levelCompleted = true;
      // Du kannst hier auch eine Übergangsanimation oder eine Nachricht anzeigen, um den Abschluss zu bestätigen
    }
  }

  // Den aktuellen Level anzeigen
  void displayLevel() {
    textSize(24);
    fill(255);
    textAlign(CENTER, TOP);
    text("Level " + currentLevel, width / 2, 20);
  }

  // Logik, wenn der Spieler gewinnt (alle Level abgeschlossen)
  void triggerWin() {
    // Hier kannst du eine Methode hinzufügen, um den Gewinnbildschirm anzuzeigen
    // oder das Spiel auf andere Weise zu beenden
    println("Du hast das Spiel gewonnen!");
    // Zum Beispiel: triggerTransition(5); für den Gewinnbildschirm
  }
}
