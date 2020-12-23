unit UntRegister;

interface

uses System.Classes;

procedure RegisterClasses;

implementation

uses UntFrmControl, UntFrmSplash, UntFrmAbout, UntFrmSettings, UntFrmHighScore, 
  UntFrmGameOver, UntFrmCongratulations;

procedure RegisterClasses;
begin
  RegisterClass(TFormControl);
  RegisterClass(TFrameSplash);
  RegisterClass(TFrameGameOver);
  RegisterClass(TFrameHighScore);
  RegisterClass(TFrameAbout);
  RegisterClass(TFrameSettings);
  RegisterClass(TFrameCongratulations);
end;
end.
