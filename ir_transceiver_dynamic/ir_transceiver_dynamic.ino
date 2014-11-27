#include <IRremote.h>
//#include <LiquidCrystal.h>
//#include <SPI.h>
//#include <nRF24L01.h>
//#include <RF24.h>


int RECV_PIN = 4;
bool value_dioda = false;
uint8_t pin_dioda = 8;

IRsend * irsend = new IRsend; // chyba nie moze dzialac na raz receiver i sender
long unsigned int msg = 0x46467878;

IRrecv * irrecv = new IRrecv(RECV_PIN);
decode_results * results = new decode_results;


////////////// SETUP ////////////// 
void setup() {
  pinMode(pin_dioda, OUTPUT);
  irrecv->enableIRIn();
  digitalWrite(pin_dioda, HIGH); delay(1000); digitalWrite(pin_dioda, LOW);
}


////////////// LOOP ////////////// 
void loop() {    
  digitalWrite(pin_dioda, LOW);
  //delay(500);
  
  if (irrecv->decode(results)) {
    digitalWrite(pin_dioda, HIGH);
    irsend->sendNEC(results->value, 64); delay(250); // to mi psuje mozliwosc odbierania
    irrecv->resume(); // Receive the next value
    irrecv->enableIRIn(); // a to mi naprawia mozliwosc odbierania :D
  }
}

