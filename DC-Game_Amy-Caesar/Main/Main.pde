// Deklaration der Hauptklasse des Spiels als globale Variable
Game game;
SoundManager sound; // Verwaltung der Soundeffekte und Hintergrundmusik
Button levelButton, helpButton;

void setup() {
  // Festlegen der Fenstergröße auf 1000 x 600 Pixel
  size(1000, 600);

  // Startet eine externe Max/MSP-Patch-Datei für die Soundverwaltung
  launch(sketchPath("./data./Sound.maxpat"), "-g");

  // Initialisierung des Sound-Managers mit der IP-Adresse und Ports zur Kommunikation
  sound = new SoundManager("127.0.0.1", 11000, 12000);

  // Startet die Hintergrundmusik
  sound.sendSound("ambient");

  // Erstellt ein neues Game-Objekt (Initialisierung des Spiels)
  game = new Game();

  // Bereitet das Spiel vor, indem die setup-Methode des Game-Objekts aufgerufen wird
  game.setup();
}

void draw() {
  // Wird in jeder Frame-Aktualisierung aufgerufen, um das Spiel zu zeichnen
  game.draw();
}

void mousePressed() {
  // Übergibt Mausklick-Ereignisse an das Game-Objekt
  game.mousePressed();

  // Spielt je nach gedrückter Maustaste einen Soundeffekt ab
  if (mouseButton == LEFT) {
    sound.sendSound("button");
  }
}


void keyPressed() {
  // Übergibt Tastendruck-Ereignisse an das Game-Objekt
  game.keyPressed();

  if (key == ' ') {
    sound.sendSound("hit"); // Schuss-Sound abspielen
  }
}



void exit() {
  // Stoppt die Sounds, bevor das Programm beendet wird
  sound.stopSound();

  // Ruft die exit-Methode der übergeordneten Klasse auf, um das Programm zu beenden
  super.exit();
}
