/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/10/2021
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>
#include <delay.h>
#include <stdlib.h>

// Alphanumeric LCD functions
#include <alcd.h>

// Declare your global variables here
int A;
int B;
int C;
char nums[];
int operater;
char results[];
int result;
int counter = 0;

void num_printer(int var){
    itoa(var, nums);
    lcd_puts(nums);
    delay_ms(1000);
    counter += 2;
    lcd_gotoxy(counter,0);  
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 8
lcd_init(16);
lcd_clear();
lcd_gotoxy(0,0);

DDRB = 0x00;
DDRA = 0b00001111;

A = -1;
B = -1;
C = -1;
result = 0;
operater = 1; // operater = 1 ==> + | operater = 0 ==> -

while (1)
      {
      // Place your code here
      //Line 1
      PORTA = 0b00000001;
      if(PINB.1 == 1){ 
        if(A == -1) {A = 9; num_printer(A); }
        else if(B == -1){ B = 9; num_printer(B); }
        else if(C == -1){ C = 9; num_printer(C); }
        else{ num_printer(9); }
      }
      delay_ms(10);
      
      if(PINB.2 == 1){
        if(A == -1) {A = 8; num_printer(A); }
        else if(B == -1){ B = 8; num_printer(B); }
        else if(C == -1){ C = 8; num_printer(C); }
        else{ num_printer(8); }
      }
      delay_ms(10);
      
      if(PINB.3 == 1){ 
        if(A == -1) {A = 7; num_printer(A); }
        else if(B == -1){ B = 7; num_printer(B); }
        else if(C == -1){ C = 7; num_printer(C); }
        else{ num_printer(7); }
      } 
      delay_ms(10);
      
      //Line 2
      PORTA = 0b00000010;
      if(PINB.1 == 1){ 
        if(A == -1) {A = 6; num_printer(A); }
        else if(B == -1){ B = 6; num_printer(B); }
        else if(C == -1){ C = 6; num_printer(C); }
        else{ num_printer(6); }
      }
      delay_ms(10);
      
      if(PINB.2 == 1){
        if(A == -1) {A = 5; num_printer(A); }
        else if(B == -1){ B = 5; num_printer(B); }
        else if(C == -1){ C = 5; num_printer(C); }
        else{ num_printer(5); }
      }
      delay_ms(10);
      
      if(PINB.3 == 1){ 
        if(A == -1) {A = 4; num_printer(A); }
        else if(B == -1){ B = 4; num_printer(B); }
        else if(C == -1){ C = 4; num_printer(C); }
        else{ num_printer(4); }
      } 
      delay_ms(10);
      
      //Line 3
      PORTA = 0b00000100;
      if(PINB.0 == 1){ operater = 0; lcd_puts("-"); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); }
      delay_ms(10);
      
      if(PINB.1 == 1){ 
        if(A == -1) {A = 3; num_printer(A); }
        else if(B == -1){ B = 3; num_printer(B); }
        else if(C == -1){ C = 3; num_printer(C); }
        else{ num_printer(3); }
      }
      delay_ms(10);
      
      if(PINB.2 == 1){
        if(A == -1) {A = 2; num_printer(A); }
        else if(B == -1){ B = 2; num_printer(B); }
        else if(C == -1){ C = 2; num_printer(C); }
        else{ num_printer(2); }
      }
      delay_ms(10);
      
      if(PINB.3 == 1){ 
        if(A == -1) {A = 1; num_printer(A); }
        else if(B == -1){ B = 1; num_printer(B); }
        else if(C == -1){ C = 1; num_printer(C); }
        else{ num_printer(1); }
      } 
      delay_ms(10);
      
      //Line 4
      PORTA = 0b00001000;
      if(PINB.0 == 1){ operater = 1; lcd_puts("+"); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); }
      delay_ms(10);
      
      if(PINB.1 == 1){ 
        lcd_puts("="); counter += 2; lcd_gotoxy(counter,0);
        //if((A == -1) && (B == -1)){ result = 0; itoa(result, results); lcd_puts(results); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); break;}
        //if((A == -1) || (B == -1)){ lcd_gotoxy(0,0); lcd_clear(); result = A + B + 1; itoa(result, results); lcd_puts(results); delay_ms(1000); counter += 2; lcd_gotoxy(counter,0); break;}
        
        if( operater == 1 ){
            if( C == -1 ){  
                result = A + B; 
            }
            else{ 
                result = (A * 10 + B) + C;  
            } 
                
            itoa(result, results);
            lcd_puts(results);
            delay_ms(1000);
            counter += 2;
            lcd_gotoxy(counter,0);} 
        
        
         if( operater == 0 ){
         
            if( C == -1 ){  
                result = A - B; 
            }
            else{ 
                result = (A * 10 + B) - C;  
            }

            itoa(result, results);
            lcd_puts(results);
            delay_ms(1000);
            counter += 2;
            lcd_gotoxy(counter,0);} 
        
        }
      delay_ms(10);       
      
      if(PINB.2 == 1){
        if(A == -1) {A = 0; num_printer(A); }
        else if(B == -1){ B = 0; num_printer(B); }
        else if(C == -1){ C = 0; num_printer(C); }
        else{ num_printer(0); }
      }
      delay_ms(10);
      
      if(PINB.3 == 1){ 
        if(A != -1){ A = -1; }
        if(B != -1){ B = -1; }
        if(C != -1){ C = -1; }
        lcd_clear();
        counter = 0;
        lcd_gotoxy(0,0);
      } 
      delay_ms(10);     

      }
                             
}
