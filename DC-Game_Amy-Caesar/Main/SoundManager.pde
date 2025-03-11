// Importiert die OSC-Bibliotheken für die Netzwerkkommunikation mit externen Soundprogrammen
import oscP5.*;
import netP5.*;

// Die SoundManager-Klasse verwaltet die Kommunikation mit einem externen Sound-Programm über das OSC-Protokoll
class SoundManager {
  OscP5 receiver;  // Objekt zur Verarbeitung eingehender OSC-Nachrichten
  NetAddress sender;  // Adresse des externen Sound-Programms (z. B. Max/MSP, Pure Data)

  /**
   * Konstruktor: Initialisiert die OSC-Kommunikation
   *
   * @param ip           Die IP-Adresse des externen Programms (z. B. "127.0.0.1" für lokale Kommunikation)
   * @param sendPort     Der Port, an den Nachrichten gesendet werden
   * @param receivePort  Der Port, auf dem Nachrichten empfangen werden
   */
  SoundManager(String ip, int sendPort, int receivePort) {
    sender = new NetAddress(ip, sendPort);  // Erstellt die Netzwerkadresse für den Empfänger
    receiver = new OscP5(this, receivePort);  // Startet den OSC-Listener auf dem angegebenen Empfangs-Port
  }

  /**
   * Sendet eine OSC-Nachricht mit einem bestimmten Sound-Befehl
   *
   * @param command Der zu sendende Befehl (z. B. "play", "pause", "stop", "effect1")
   */
  void sendSound(String command) {
    OscMessage nachricht = new OscMessage("max");  // Erstellt eine neue OSC-Nachricht mit dem Adress-Tag "max"
    nachricht.add(command);  // Fügt den Befehl als Parameter zur Nachricht hinzu
    receiver.send(nachricht, sender);  // Sendet die Nachricht an die angegebene Netzwerkadresse
  }


  /**
   * Stoppt die Wiedergabe des Sounds durch das Senden des "stop"-Befehls
   */
  void stopSound() {
    sendSound("stop");  // Ruft die sendSound-Methode mit dem "stop"-Befehl auf
  }
}
