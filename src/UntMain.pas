unit UntMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, UntBaseForm, FMX.Media, FMX.Objects,
  System.Actions, FMX.ActnList;

type

  TCalibreThread = class(TThread)
    public
      procedure Execute; override;
  end;

  TExplosionThread = class(TThread)
    public
      procedure Execute; override;
  end;


  TFormMain = class(TBaseForm)
    Layout1: TLayout;
    Ship: TRectangle;
    Thruster: TRectangle;
    Thruster2: TRectangle;
    Su25: TRectangle;
    Su35: TRectangle;
    ActionList1: TActionList;
    ActControlForm: TAction;
    Layout2: TLayout;
    LayoutSpace: TLayout;
    TimerAirCraft: TTimer;
    ActClose: TAction;
    MPGame: TMediaPlayer;
    Calibre: TRectangle;
    TimerCalibre: TTimer;
    LabelScore: TLabel;
    Layout3: TLayout;
    LabelTime: TLabel;
    Explosion1: TRectangle;
    Layout4: TLayout;
    LabelAirCraft: TLabel;
    Rectangle1: TRectangle;
    LabelMachine: TLabel;
    Label1: TLabel;
    RecFuze: TRectangle;
    TimerFuze: TTimer;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ActControlFormExecute(Sender: TObject);
    procedure TimerAirCraftTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure TimerCalibreTimer(Sender: TObject);
    procedure TimerFuzeTimer(Sender: TObject);
  private
    FCaThread: TCalibreThread;
    FExThread: TExplosionThread;
    FCreate: Boolean;
    FScore: Integer;
    FLive: Integer;
    FAirCraft: Integer;
    { Private declarations }
    procedure MoveLeft;
    procedure MoveRight;
    procedure Shut(const Value: Boolean);
    procedure Explosion(Rec: TRectangle);
    procedure CheckExp;
    procedure CreateSu;
    procedure StopTimers;
    procedure StartTimers;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  FValue: Boolean;

implementation

uses UntFrmControl, UntFrmSplash, UntBaseFrame, UntModule, FMX.Graphics;

{$R *.fmx}

const
  RANDOM_POS_X = 300;
  RANDOM_POS_Y = 200;
  AIRCRAFT_COUNT = 10;
  LIVE_COUNT = 3;
  EASY_SPEED = 15;
  MEDIUM_SPEED = 30;
  HARD_SPEED = 45;
  BASE_SCORE = 100;
  MAX_DURATION = 1000000;

var
   SuArray: array of TRectangle;

procedure TFormMain.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  FCreate := False;

  case Key of
   vkEscape:  ActControlForm.Execute;
   vkLeft: MoveLeft;
   vkRight: MoveRight;
   vkUp, vkSpace: Shut(True);
  end;
end;

procedure TFormMain.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  FCreate := False;

  case Key of
   vkEscape: ;
   vkLeft:  ;
   vkRight: ;
   vkUp, vkSpace: Shut(False);
  end;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
  FullScreen := GetScreenMode;
end;

procedure TFormMain.MoveLeft;
begin
  if Ship.Position.X >= 0 then
  begin
    Ship.Position.X := Ship.Position.X - 10;

    if not TimerCalibre.Enabled then
      Calibre.Position.X := Ship.Position.X + (Ship.Width / 4) + 4;
  end;
end;

procedure TFormMain.MoveRight;
begin
  if Ship.Position.X <= Self.ClientWidth - Ship.Width then
  begin
    Ship.Position.X := Ship.Position.X + 10;

    if not TimerCalibre.Enabled then
      Calibre.Position.X := Ship.Position.X + (Ship.Width / 4) + 4;
  end;
end;

procedure TFormMain.Shut(const Value: Boolean);
begin
  FValue := Value;
  Thruster.Visible := Value;
  Thruster2.Visible := Value;

  if FValue then
  begin
    FCaThread.Execute;
    try
      ;
    finally
      FCaThread.Terminate;
    end;
  end;
end;

procedure TFormMain.StartTimers;
begin
  TimerAirCraft.Enabled := True;
  TimerCalibre.Enabled := True;
  TimerFuze.Enabled := True;
end;

procedure TFormMain.StopTimers;
begin
  TimerAirCraft.Enabled := False;
  TimerCalibre.Enabled := False;
  TimerFuze.Enabled := False;
end;

var
  rote: Boolean = True;

function GetSpeed: Integer;
begin
   Result := EASY_SPEED;
   case GetArcadeMode of
    1: Result := MEDIUM_SPEED;
    2: Result := HARD_SPEED;
  end;
end;

procedure TFormMain.TimerAirCraftTimer(Sender: TObject);
var
  I, X, Y: Integer;
  speed: Integer;

  function GetStrTime: string;
  var
    int: Integer;
  begin
    int := LabelTime.Text.ToInteger + Integer(TimerAirCraft.Interval);
    Result := int.ToString;
  end;
begin
  X := 0;
  speed := GetSpeed;
  LabelTime.Text := GetStrTime;

  for I := Low(SuArray) to High(SuArray) do
  begin
    SuArray[I].Position.X := SuArray[I].Position.X + speed;
  end;

  if SuArray[Length(SuArray) -1].Position.X >= ClientWidth + 1000 then
    for I := Low(SuArray) to High(SuArray) do
    begin
      SuArray[I].Position.X := -1000 + SuArray[I].Width + X;
      SuArray[I].Position.Y := Random(RANDOM_POS_Y);
      Inc(X, Random(RANDOM_POS_X));
    end;

  if Random(500 div speed) = 1 then
  begin
    FExThread.Execute;
    try
       Y := Random(9);
       if (SuArray[Y].Visible) then
       begin
         RecFuze.Position := SuArray[Y].Position;
       end;
    finally
      FExThread.Terminate;
    end;
  end;

  if (FLive = 0) or (LabelTime.Text.ToInteger >= (MAX_DURATION div speed)) then
  begin
    with CrateBaseForm('TFormControl') do
    begin
      TimerAirCraft.Enabled := False;
      ExecuteVar('TFrameGameOver');
    end
  end;

  if (FAirCraft = 0) then
  begin
    SetCurrentScore(FScore + ((MAX_DURATION div speed) - LabelTime.Text.ToInteger) * FLive);

    with CrateBaseForm('TFormControl') do
    begin
      TimerAirCraft.Enabled := False;
      ExecuteVar('TFrameCongratulations');
    end
  end;
end;

procedure TFormMain.TimerCalibreTimer(Sender: TObject);
var
  I: Integer;
begin
  Calibre.Position.Y := Calibre.Position.Y - 10;

  for I := Low(SuArray) to High(SuArray) do
  begin
    if IntersectRect(SuArray[I].AbsoluteRect, Calibre.AbsoluteRect) and SuArray[I].Visible then
    begin
      if not (SuArray[I].Position.Y >= Calibre.Position.Y) then
        Exit;

      SuArray[I].Fill.Bitmap.Assign(Explosion1.Fill.Bitmap);
//      SuArray[I].Visible := False;
      Inc(FScore, BASE_SCORE);
      SetCurrentScore(FScore);
      Calibre.Visible := False;
      LabelScore.Text := Format('Score: %s', [FScore.ToString]);
      Explosion(SuArray[I]);
      LabelAirCraft.Text := Integer(LabelAirCraft.Text.ToInteger - 1).ToString;
      Inc(FAirCraft, -1);
      Exit;
    end;
  end;

  if Calibre.Position.Y <= -100 then
  begin
    TimerCalibre.Enabled := False;
    Calibre.Visible := False;
    Calibre.Position.X := (Ship.Position.X) + (Ship.Width / 4) + 4;
    Calibre.Position.Y := ClientHeight - Ship.Height;
  end;

  CheckExp;
end;

var
  CurrentRect: TRectF;

procedure TFormMain.TimerFuzeTimer(Sender: TObject);
var
  speed: Integer;
begin
  speed := GetSpeed;

  if Length(SuArray) = 0 then Exit;

  RecFuze.Position.Y :=  RecFuze.Position.Y + speed;

  if IntersectRect(Ship.AbsoluteRect, RecFuze.AbsoluteRect) and (CurrentRect.Left <> RecFuze.AbsoluteRect.Left) then
   begin
      CurrentRect := RecFuze.AbsoluteRect;
      RecFuze.Visible := False;
      Inc(FLive, -1);
      LabelMachine.Text := Integer(LabelMachine.Text.ToInteger - 1).ToString;
      Exit;
    end;

  if RecFuze.Position.Y >= ClientHeight + 300 then
  begin
    TimerFuze.Enabled := False;
    RecFuze.Visible := False;
  end;

  CheckExp;
end;

procedure TFormMain.ActControlFormExecute(Sender: TObject);
begin
  if not FCreate then
  begin
    if MessageDlg('Are you sure quit the game?', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0) = mrNo then
      Exit;

    if FScore = 0 then
    begin
      with CrateBaseForm('TFormControl') do
      begin
        ExecuteVar('TFrameGameOver');
        Exit;
      end
    end;
  end;

  with CrateBaseForm('TFormControl') do
  begin
    ExecuteVar('TFrameSplash');
  end;

  TDModule.PlayMusic(GAME_MUSIC_NAME);
end;

procedure TFormMain.CheckExp;
begin
  ;
end;

procedure TFormMain.CreateSu;
var
  I, X, Y, Y2: Integer;
begin
  X := 0;
  SetLength(SuArray, FAirCraft);

  for I := Low(SuArray) to High(SuArray) do
  begin
    Y := Random(RANDOM_POS_Y);
    Y2 := Random(RANDOM_POS_Y);
    SuArray[I] := TRectangle.Create(nil);
    SuArray[I].Parent := LayoutSpace;
    SuArray[I].Position.X := -400 + X;

    if (I mod 2 = 0) then
    begin
      SuArray[I].Position.Y := Y;
      SuArray[I].Fill.Kind := TBrushKind.Bitmap;
      SuArray[I].Fill.Bitmap.Assign(Su25.Fill.Bitmap);
      SuArray[I].Stroke.Kind := TBrushKind.None;
      SuArray[I].Width := 169;
      SuArray[I].Height := 121;
      SuArray[I].Visible := True;
    end else
    begin
      SuArray[I].Position.Y := Y2;
      SuArray[I].Fill.Kind := TBrushKind.Bitmap;
      SuArray[I].Fill.Bitmap.Assign(Su35.Fill.Bitmap);
      SuArray[I].Stroke.Kind := TBrushKind.None;
      SuArray[I].Width := 169;
      SuArray[I].Height := 73;
      SuArray[I].Visible := True;
    end;

    Inc(X, Random(RANDOM_POS_X));
  end;
end;

procedure TFormMain.Explosion(Rec: TRectangle);
begin
   TThread.Synchronize(nil, procedure
   begin
     try

      finally
        rec.Visible := False;
     end;
   end
   );
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FScore := 0;
  FValue := False;
  FLive := LIVE_COUNT;
  FAirCraft := AIRCRAFT_COUNT;
  FCreate := True;
  Thruster.Visible := False;
  Thruster2.Visible := False;
  Calibre.Visible := False;
  Calibre.Position.Y := ClientHeight - Ship.Height;
  CreateSu;
  FCaThread := TCalibreThread.Create;
  try

  finally
    FCaThread.Terminate;
  end;

  FExThread := TExplosionThread.Create;
  try

  finally
    FExThread.Terminate;
  end;

  ActControlForm.Execute;
end;

{ TMainThread }

procedure TCalibreThread.Execute;
begin
  inherited;

  with FormMain do
  begin
    Thruster.Visible := FValue;
    Thruster2.Visible := FValue;

    if FValue then
    begin
      Calibre.Visible := True;
      TimerCalibre.Enabled := True;
      try
        FormMain.MPGame.FileName := GetCurrentPath + SHUT_MUSIC_NAME;
        FormMain.MPGame.Volume := 1;
        FormMain.MPGame.Play;
      finally
        ;
      end;
    end;
  end;
end;
{ TExplosionThread }

procedure TExplosionThread.Execute;
begin
  inherited;

  with FormMain do
  begin
    RecFuze.Visible := True;
    TimerFuze.Enabled := True;
    try
    finally
      ;
    end;
  end;
 end;

end.
