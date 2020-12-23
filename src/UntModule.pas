unit UntModule;

interface

uses
  System.SysUtils, System.Classes, FMX.Types, FMX.Media;

const
  GAME_MUSIC_NAME = 'game.mp3';
  MAIN_MUSIC_NAME = 'main.mp3';
  SHUT_MUSIC_NAME = 'shut.wav';
  MIN_HIGH_SCORE = 100000;


type
  TDModule = class(TDataModule)
    MP: TMediaPlayer;
    procedure DataModuleCreate(Sender: TObject);
  public
    class procedure StopPlayer;
    class procedure PlayMusic; overload;
    class procedure PlayMusic(FileName: string); overload;
  end;

  function GetCurrentPath: string;
  function GetCurrentScore: Integer;
  procedure SetCurrentScore(CurrentScore: Integer);
  function LoadScores: TMemoryStream;
  function SaveScore(PlayerName: string): Boolean;
  function GetMusicMode: Boolean;
  function GetScreenMode: Boolean;
  function GetArcadeMode: Integer;
  procedure SetMusicMode(MusicMode: Boolean);
  procedure SetScreenMode(ScreenMode: Boolean);
  procedure SetArcadeModee(ArcadeMode: Integer);

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.IniFiles;


const
  SECTION_GENERAL = 'General';
  SECTION_ARCADE = 'Arcade';
  KEY_SCREEN_MODE = 'ScreenMode';
  KEY_MUSIC_MODE = 'MusicMode';
  KEY_ARCADE_MODE = 'ArcadeMode';
  INI_FILE_PATH =  'settings.ini';
  SCORES_FILE = 'scores.txt';

  // ARCADE MODE = 0 EASY
  // ARCADE MODE = 1 MEDIUM
  // ARCADE MODE = 2 HARD

  // SCREEN MODE = TRUE  ON
  // SCREEN MODE = FALSE OFF

  // MUSIC MODE = TRUE  ON
  // MUSIC MODE = FALSE OFF
var
  FPlayer: TMediaPlayer;
  FCurrentFileName: string;

  FMusicMode: Boolean;
  FScreenMode: Boolean;
  FArcadeMode: Integer;
  FCurrentScore: Integer;

function LoadSettings: Boolean; forward;
function SaveSettings: Boolean; overload; forward;
function SaveSettings(Section, Key: string; Value: Variant): Boolean; overload; forward;

function GetMusicMode: Boolean;
begin
  Result := FMusicMode;
end;

function GetScreenMode: Boolean;
begin
  Result := FScreenMode;
end;

function GetArcadeMode: Integer;
begin
  Result := FArcadeMode;
end;

function GetCurrentScore: Integer;
begin
  Result := FCurrentScore;
end;

procedure SetCurrentScore(CurrentScore: Integer);
begin
  FCurrentScore := CurrentScore;
end;

procedure SetMusicMode(MusicMode: Boolean);
begin
  if FMusicMode = MusicMode then Exit;

  FMusicMode := MusicMode;
  SaveSettings(SECTION_GENERAL, KEY_MUSIC_MODE, FMusicMode);
end;

procedure SetScreenMode(ScreenMode: Boolean);
begin
  if FScreenMode = ScreenMode then Exit;

  FScreenMode := ScreenMode;
  SaveSettings(SECTION_GENERAL, KEY_SCREEN_MODE, FScreenMode);
end;

procedure SetArcadeModee(ArcadeMode: Integer);
begin
  if FArcadeMode = ArcadeMode then Exit;

  FArcadeMode := ArcadeMode;
  SaveSettings(SECTION_ARCADE, KEY_ARCADE_MODE, FArcadeMode);
end;

procedure TDModule.DataModuleCreate(Sender: TObject);
begin
  FPlayer := MP;
  LoadSettings;
end;

function GetCurrentPath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function LoadSettings: Boolean;
var
  ini: TIniFile;
begin
   ini := TIniFile.Create(GetCurrentPath + INI_FILE_PATH);
  try
    if Assigned(ini) then
    begin
      FMusicMode := ini.ReadBool(SECTION_GENERAL, KEY_MUSIC_MODE, True);
      FScreenMode := ini.ReadBool(SECTION_GENERAL, KEY_SCREEN_MODE,True);
      FArcadeMode := ini.ReadInteger(SECTION_ARCADE, KEY_ARCADE_MODE, 0);
    end;
  finally
    ini.Free;
  end;

  Result := True;
end;

function SaveSettings: Boolean; overload;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetCurrentPath + INI_FILE_PATH);
  try
    if Assigned(ini) then
    begin
      ini.WriteBool(SECTION_GENERAL, KEY_MUSIC_MODE, FMusicMode);
      ini.WriteBool(SECTION_GENERAL, KEY_SCREEN_MODE, FScreenMode);
      ini.WriteInteger(SECTION_ARCADE, KEY_ARCADE_MODE, FArcadeMode);
    end;
  finally
    ini.Free;
  end;

  Result := True;
end;

function SaveSettings(Section, Key: string; Value: Variant): Boolean; overload;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GetCurrentPath + INI_FILE_PATH);
  try
    if Assigned(ini) then
      ini.WriteString(Section, Key, Value);
  finally
    ini.Free;
  end;

  Result := True;
end;

function LoadScores: TMemoryStream;
begin
  Result := nil;
  try
    if FileExists(GetCurrentPath + SCORES_FILE) then
    begin
      Result := TMemoryStream.Create;
      Result.LoadFromFile(GetCurrentPath + SCORES_FILE);
    end;
  finally

  end;
end;

function SaveScore(PlayerName: string): Boolean;

const enter = #13#10;
var
  stream: TMemoryStream;
  buffer: TBytes;
  score: string;
begin
  Result := False;
  stream := LoadScores;
  try
    score := Format('Player Name: %s, Score: %d, Date: %s %s',
      [PlayerName, FCurrentScore, DateTimeToStr(Now), enter]);
    buffer := TEncoding.UTF8.GetBytes(score);

    if Assigned(stream) then
    begin
      stream.Seek(soFromCurrent, soFromEnd);
      stream.Write(buffer, Length(buffer));
      stream.SaveToFile(GetCurrentPath + SCORES_FILE);
    end else
    begin
      stream := TMemoryStream.Create;
      stream.Seek(0, soFromBeginning);
      stream.Write(buffer, Length(buffer));
      stream.SaveToFile(GetCurrentPath + SCORES_FILE);
    end;
    Result := True;
  finally
    stream.Free;
  end;
end;

class procedure TDModule.PlayMusic(FileName: string);
var
  path: string;
begin
  path := GetCurrentPath + FileName;

  if FileExists(path) then
  begin
    FPlayer.FileName := path;
    FPlayer.Volume := 0.6;

    if FMusicMode then
      FPlayer.Play;

    FCurrentFileName := FileName;
  end;
end;

class procedure TDModule.PlayMusic;
begin
   PlayMusic(FCurrentFileName);
end;

class procedure TDModule.StopPlayer;
begin
  FPlayer.Stop;
end;

end.

