function pupilstoprecording()

portA = PsychSerial('Open','.Ain','.Aout',9600)
PsychSerial('Write',portA,[136]);
waitsecs(0.02);
PsychSerial('Close',portA);
