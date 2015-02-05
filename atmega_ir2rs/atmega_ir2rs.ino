#include <IRremote.h> // dołączenie biblioteki obsługującej komunikację IR - IRremote

IRrecv irrecv(4); // zadeklarowanie pinu 4 jako wyprowadzenie odbiornika IR
decode_results kod; // zawiera dane odczytanego kodu IR

// deklaracja tablicy łańcuchów znaków symbolizujących nazwy kolejnych protokołów IR używanych w bibliotece IRremote
String codeTypes[] = {"BLAD", "NEC", "SONY", "RC5", "RC6", "DISH", "SHARP", "PANASONIC", "JVC", "SANYO", "MITSUBISHI", "SAMSUNG", "LG"} ;

// ustawienia początkowe
void setup() {
  Serial.begin(9600); // inicjalizacja komunikacji UART z prędkością 9600 bodów
  irrecv.enableIRIn(); // włączenie odczytu danych z odbiornika IR
}

void loop() {    
  if (irrecv.decode(&kod)) { 
    if (kod.decode_type<0) kod.decode_type++;
    
    // deklaracja zmiennej łańcuchowej wynikIR i przypisywanie do niej wiadomości zawierającej typ kodu oraz jego wartość
    String wynikIR = "sendMessage(\"GET /kod?typKodu="; 
    wynikIR += codeTypes[kod.decode_type]; 
    wynikIR += "&wartoscKodu="; 
    wynikIR += "0x";
    wynikIR += String(kod.value, 16); 
    wynikIR += " \", \"atmega ir2rs\")"; 
    
    Serial.println(wynikIR); // wysłanie wiadomości zawartej w zmiennej wynikIR przez UART
    irrecv.resume(); // kontynuuj odpytywanie odbiornika IR
  }
}
