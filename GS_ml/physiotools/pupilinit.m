function pupilinit()

portA = PsychSerial('Open','.Ain','.Aout',9600)
PsychSerial('Write',portA,[132.00]);
waitsecs(0.04);
PsychSerial('Close',portA);
