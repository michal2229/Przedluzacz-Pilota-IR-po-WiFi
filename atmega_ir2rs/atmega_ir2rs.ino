// program przeznaczony na mikrokontroler odbiorczy podczerwieni - nadawczy UART RS232

#include <IRremote.h> // dołączenie biblioteki obsługującej komunikację IR - IRremote

IRrecv irrecv(4); // zadeklarowanie pinu 4 jako wyprowadzenie odbiornika IR
decode_results kod; // zawiera dane odczytanego kodu IR

// deklaracja tablicy łańcuchów znaków symbolizujących nazwy kolejnych protokołów IR używanych w bibliotece IRremote
String codeTypes[] = {"BLAD", "NEC", "SONY", "RC5", "RC6", "DISH", "SHARP", "PANASONIC", "JVC", "SANYO", "MITSUBISHI", "SAMSUNG", "LG"} ;

void setup() { // ustawienia początkowe
  Serial.begin(38400); // inicjalizacja komunikacji UART z prędkością 38400 bodów
  irrecv.enableIRIn(); // włączenie odczytu danych z odbiornika IR
}

void loop() {    
  if (irrecv.decode(&kod)) { // jesli odczytano kod przez odbiornik IR
    if (kod.decode_type>0) { // jesli protokol jest poprawny
      String wynikIR = "sendMessage(\"GET /kod?typKodu="; // deklaracja zmiennej łańcuchowej wynikIR i przypisywanie do niej wiadomości (zapytania GET) zawierającej typ kodu oraz jego wartość
      wynikIR += codeTypes[kod.decode_type]; // dolacz do zmiennej tekstowej nazwe protokolu
      wynikIR += "&wartoscKodu="; 
      wynikIR += "0x";
      wynikIR += String(kod.value, 16); // dolacz do zmiennej wartosc kodu w postaci ciagu znakow symbolizujacych liczbe szesnastkowa
      wynikIR += " \")"; 
      Serial.println(wynikIR); // wysłanie wiadomości zawartej w zmiennej wynikIR przez UART
    }
    irrecv.resume(); // kontynuuj odpytywanie odbiornika IR
  }
}
