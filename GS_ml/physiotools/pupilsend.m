function pupilsend(val)

portA = PsychSerial('Open','.Ain','.Aout',9600)
PsychSerial('Write',portA,[val]);
waitsecs(0.02);
PsychSerial('Close',portA);
