#include <IRremote.h>
#include <LiquidCrystal.h>
//#include <SPI.h>
//#include <nRF24L01.h>
//#include <RF24.h>


int RECV_PIN = 4;
bool value_dioda = false;
uint8_t pin_dioda = 8;
int i = 0;

IRrecv irrecv(RECV_PIN);
decode_results results;

//IRsend irsend; 
//long unsigned int msg = 0x46467878;

LiquidCrystal lcd(A5, A4, A3, A2, A1, A0); 

////////////// SETUP ////////////// 
void setup() {
  /*lcd.begin(16, 2);
  lcd.clear(); 
  lcd.setCursor(0, 0); 
  lcd.print("IR transceiver. ");*/
  
  Serial.begin(9600);
  //Serial.println("IR to UART transceiver. ");
  
  //pinMode(pin_dioda, OUTPUT);
  //digitalWrite(pin_dioda, HIGH); delay(1000); digitalWrite(pin_dioda, LOW);
  
  irrecv.enableIRIn(); 
  
  //digitalWrite(pin_dioda, HIGH); delay(1000); digitalWrite(pin_dioda, LOW);
}

////////////// LOOP ////////////// 
void loop() {    
  if (irrecv.decode(&results)) {
    lcd.clear(); 
    lcd.setCursor(0, 0); lcd.print("kod: "); lcd.print(results.value, HEX);
    lcd.setCursor(0, 1); lcd.print("typ: "); lcd.print(results.decode_type);
    String message = "message = \"GET /kod?typKodu=NEC&wartoscKodu=";
    message += results.value; // globalna zmienna 'message' w LUA? wysylana za kazdym razem kiedy sie zmieni?
    message += " \"";
    Serial.println(message);
    //digitalWrite(pin_dioda, HIGH); delay(1000); digitalWrite(pin_dioda, LOW);
    delay(100);
    //irsend.sendNEC(results.value, 64); delay(250);
    irrecv.resume(); 
    irrecv.enableIRIn();
  }
}

