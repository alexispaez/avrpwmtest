with AVR; use AVR;
with AVR.MCU;
with AVR.Wait;
with AVR.UART; use AVR.UART;
with Avrada_Rts_Config;

procedure Avrpwmtest is
   procedure Wait_1_Sec is new
     AVR.Wait.Generic_Wait_USecs (Avrada_Rts_Config.Clock_Frequency,
                                  1_000_000);

   LED1 : Boolean renames AVR.MCU.PORTB_Bits (5);
   LED1_DD : Boolean renames AVR.MCU.DDRB_Bits (5);
   LED2 : Boolean renames AVR.MCU.PORTB_Bits (4);
   LED2_DD : Boolean renames AVR.MCU.DDRB_Bits (4);
begin
   LED1_DD := DD_Output;
   LED2_DD := DD_Output;

   Init (Baud_19200_16MHz);

   loop
      LED1 := High;  -- On on Arduino
      LED2 := Low;
      Put ("Led 1 On");
      CRLF;
      Put ("Led 2 Off");
      CRLF;
      Wait_1_Sec;
      LED1 := Low;  -- Off on Arduino
      LED2 := High;
      Put ("Led 1 Off");
      CRLF;
      Put ("Led 1 On");
      CRLF;
      Wait_1_Sec;
   end loop;
end Avrpwmtest;
