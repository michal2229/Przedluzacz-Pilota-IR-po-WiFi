#include <IRremote.h>

String wiadomoscRS = "";
boolean odczytanoWiadomosc = false;

IRsend irsend;

void setup() {  
  Serial.begin(38400);
}

void loop() {      
  if (odczytanoWiadomosc & wiadomoscRS.startsWith("GET")) {    
    int i1p, i1k, i2p, i2k, i3p, i3k;
    i1p = wiadomoscRS.indexOf("/", 0);     i1k = wiadomoscRS.indexOf("?", i1p+1); 
    i2p = wiadomoscRS.indexOf("=", i1k+1); i2k = wiadomoscRS.indexOf("&", i2p+1);
    i3p = wiadomoscRS.indexOf("=", i2k+1); i3k = wiadomoscRS.indexOf(" ", i3p+1);
    
    String typWiadomosci = wiadomoscRS.substring(i1p + 1, i1k); 
    if (typWiadomosci == "kod") {
      String typKodu       = wiadomoscRS.substring(i2p + 1, i2k);
      String wartoscKodu   = wiadomoscRS.substring(i3p + 1, i3k);
      
      char wartoscKoduChar[24]; // zmienna pomocnicza pozwalajaca przerobic string zawierajacy liczbe szesnastkowa na liczbe (int)
      wartoscKodu.toCharArray(wartoscKoduChar, wartoscKodu.length()+1); // przerabiam String na char[] aby potem przerobic to na liczbe 
      wartoscKoduChar[wartoscKodu.length() + 1] = '\0';
      unsigned long wartoscKoduInt = strtoul(wartoscKoduChar, 0, 16); // przerabiam char[] na liczbe unsigned long/
      
      if      (typKodu == "NEC")     irsend.sendNEC(wartoscKoduInt, 32);
      else if (typKodu == "RC5")     irsend.sendRC5(wartoscKoduInt, 32);
      else if (typKodu == "SAMSUNG") irsend.sendSAMSUNG(wartoscKoduInt, 32);
      
      //else if (typKodu == "BLAD") Serial.println("log=\"blad 1\"");
      //else Serial.println("log=\"blad 2\"");
    } 
    //else Serial.println("log=\"blad 3\"");
  }
  odczytanoWiadomosc = false;
  //delay(100);
}

void serialEvent() {
  while (Serial.available()) {
    char znakiOdczytane[1024];
    byte iloscOdczytanychZnakow;
    iloscOdczytanychZnakow = Serial.readBytesUntil(10, znakiOdczytane, 1023); 
    znakiOdczytane[iloscOdczytanychZnakow] = '\0';
    wiadomoscRS = znakiOdczytane;
    odczytanoWiadomosc = true;
  } 
}
