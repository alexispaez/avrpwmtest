with AVR;         use AVR;
with AVR.MCU;
with AVR.Wait;
with AVR.Timer1;
with Interfaces;  use Interfaces;
with Avrada_Rts_Config;

procedure avrpwmtest is
   procedure Calculate is
      -- Calculations here
      Half_Revs : Integer := 0;
      Revs : Float := 0.0;
      Factor : Float := 0.0;
   begin
      Revs := Float (Half_Revs) / Factor;
   exception
      when others =>
         Revs := 0.0;
   end;
   --  at 4MHz waiting for 4 cycles is 1 micro-second
   procedure Wait_10ms;
   pragma Inline (Wait_10ms);

   procedure Wait_10ms is
   begin
      AVR.Wait.Wait_4_Cycles (10_000);
   end Wait_10ms;

   procedure Wait_1_Sec is new
     AVR.Wait.Generic_Wait_USecs (Avrada_Rts_Config.Clock_Frequency,
                                  1_000_000);

   PB1 : Boolean renames MCU.DDRB_Bits (1);
   PB2 : Boolean renames MCU.DDRB_Bits (2);
   --  OC1A_Pin  : constant Bit_Number := MCU.PORTD5_Bit;
   --  OC1A_DDR  : Bits_In_Byte renames MCU.DDRD_Bits;
   --  OC1A_Port : Bits_In_Byte renames MCU.PORTD_Bits;

   PB_Duty : Nat8;

begin
   -- MCU.DDRB_Bits := (others => DD_Output);  -- use all pins on PortB for output
   PB1 := DD_Output;
   PB2 := DD_Output;
   -- MCU.PORTB := 16#FF#;                 -- set output high -> turn all LEDs off


   -- OC1A_DDR (OC1A_Pin) := DD_Output; -- set pin5 as output
   -- OC1A_Port (OC1A_Pin) := False;    -- clear pin5

   -- enable 8 bit PWM, select inverted PWM
   Timer1.Init_PWM (Timer1.Scale_By_8, Timer1.Fast_PWM_8bit, Inverted => True);

   Timer1.Init_PWMB (Timer1.Scale_By_8, Timer1.Fast_PWM_8bit, Inverted => True);

   --  timer1 running on 1/8 MCU clock with clear timer/counter1 on
   --  Compare Match -- PWM frequency will be MCU clock / 8 / 512,
   --  e.g. with 4Mhz Crystal 977 Hz.


   --
   --  Dimm LED on and off in interval of 2.5 seconds
   --
   PB_Duty := 255;   -- off
   PB_Duty := 0;     -- on
   MCU.OCR1AL := 64;
   MCU.OCR1BL := 192;

   loop
      MCU.OCR1AL := 0;
      MCU.OCR1BL := 255;

      Wait_1_Sec;

      MCU.OCR1AL := 64;
      MCU.OCR1BL := 192;

      Wait_1_Sec;

      MCU.OCR1AL := 128;
      MCU.OCR1BL := 128;

      Wait_1_Sec;

      MCU.OCR1AL := 192;
      MCU.OCR1BL := 64;

      Wait_1_Sec;

      MCU.OCR1AL := 255;
      MCU.OCR1BL := 0;

      Wait_1_Sec;

      -- dimm LED off
      -- for I in reverse Nat8 loop
         -- MCU.OCR1AL := I;
         -- MCU.OCR1BL := I;
         --Wait_10ms;
      --end loop;

      -- MCU.OCR1BL := 250;
      --MCU.OCR1BL := PB_Duty;
      --PB_Duty := PB_Duty + 10;

      -- dimm LED on
      --for I in Nat8 loop
         --MCU.OCR1AL := I;
         -- MCU.OCR1BL := I;
         --Wait_10ms;
      --end loop;
   end loop;

   -- This is a new line added for testing

end avrpwmtest;
