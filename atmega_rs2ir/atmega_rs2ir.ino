// program przeznaczony na mikrokontroler nadawczy podczerwieni - odbiorczy UART RS232
#include <IRremote.h> // dołączenie biblioteki obsługującej komunikację IR - IRremote

String wiadomoscRS = ""; // deklaracja zmiennej tekstowej bedacej miejscem zapisywania wiadomosci odczytanych przez UART
boolean odczytanoWiadomosc = false; // deklaracja flagi informujacej o odczytaniu tekstu przez UART

IRsend irsend; // stworzenie obiektu nadajnika IR

void setup() {  // ustawienia poczatkowe
  Serial.begin(38400); // inicjalizacja komunikacji UART z prędkością 38400 bodów
}

void loop() { // petla glowna
  if (odczytanoWiadomosc & wiadomoscRS.startsWith("GET")) { // jesli odebrano wiadomosc i zaczyna sie ona od ciagu znakow "GET"
    int i1p, i1k, i2p, i2k, i3p, i3k; // deklaracja zmiennych tekstowych oznaczajacych poczatel oraz koniec ciagow znakow, ktore nalezy wydobyc
    i1p = wiadomoscRS.indexOf("/", 0);     i1k = wiadomoscRS.indexOf("?", i1p+1); // okreslanie gdzie zaczyna sie i gdzie konczy ciag znakow oznaczajacy typ wiadomosci
    i2p = wiadomoscRS.indexOf("=", i1k+1); i2k = wiadomoscRS.indexOf("&", i2p+1); // okreslanie gdzie zaczyna sie i gdzie konczy ciag znakow oznaczajacy nazwe protokolu
    i3p = wiadomoscRS.indexOf("=", i2k+1); i3k = wiadomoscRS.indexOf(" ", i3p+1); // okreslanie gdzie zaczyna sie i gdzie konczy ciag znakow oznaczajacy kod IR
    
    String typWiadomosci = wiadomoscRS.substring(i1p + 1, i1k); // wydobywanie ciagu znakow oznaczajacego typ wiadomosci i przypisywanie go do zmiennej
    if (typWiadomosci == "kod") { // jesli wiadomosc zawiera protokol oraz kod IR
      String typKodu       = wiadomoscRS.substring(i2p + 1, i2k); // wydobywanie ciagu znakow oznaczajacych typ protokolu
      String wartoscKodu   = wiadomoscRS.substring(i3p + 1, i3k); // wydobywanie ciagu znakow oznaczajacych kod IR
      
      char wartoscKoduChar[24]; // zmienna pomocnicza pozwalajaca przerobic string zawierajacy liczbe szesnastkowa na liczbe (int)
      wartoscKodu.toCharArray(wartoscKoduChar, wartoscKodu.length()+1); // przerabiam String na char[] aby potem przerobic to na liczbe 
      wartoscKoduChar[wartoscKodu.length() + 1] = '\0'; // oznaczanie konca ciagu znakow
      unsigned long wartoscKoduInt = strtoul(wartoscKoduChar, 0, 16); // przerabiam kod char[] na liczbe unsigned long, aby mozna bylo wyslac kod poprzez IR 
      
      if      (typKodu == "NEC")     irsend.sendNEC(wartoscKoduInt, 32); // jesli protokol to NEC, wyslij kod w standardzie NEC
      else if (typKodu == "RC5")     irsend.sendRC5(wartoscKoduInt, 32); // jesli protokol to RC5, wyslij kod w standardzie RC5
      else if (typKodu == "SAMSUNG") irsend.sendSAMSUNG(wartoscKoduInt, 32); // jesli protokol to SAMSUNG, wyslij kod w standardzie SAMSUNG
    } 
  }
  odczytanoWiadomosc = false; // zerowanie flagi oznaczajacego oczekujaca wiadomosc
}

void serialEvent() { // obsluga przerwania rozpoczecia transmisji
  while (Serial.available()) { // wykonuje petle tak dlugo, jak trwa komunikacja przez UART
    char znakiOdczytane[1024]; // zmienna pomocnicza na kolejno odczytane znaki
    byte iloscOdczytanychZnakow; // zmienna pomocnicza okreslajaca ile znakow odczytano
    iloscOdczytanychZnakow = Serial.readBytesUntil(10, znakiOdczytane, 1023); // odczytywanie iosci odebranych znakow
    znakiOdczytane[iloscOdczytanychZnakow] = '\0'; // konczenie ciagu znakow zerem
    wiadomoscRS = znakiOdczytane; // konwersja tablicy znakow na zmienna typu String
    odczytanoWiadomosc = true; // ustawienie flagi informujacej o oczekujacej wiadomosci
  } 
}
