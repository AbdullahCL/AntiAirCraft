unit UntFrmControl;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Ani, FMX.Layouts, FMX.Gestures,
  FMX.StdCtrls, FMX.Controls.Presentation, UntBaseForm, UntBaseFrame, FMX.Media;

type
  TFormControl = class(TBaseForm)
    LMain: TLayout;
    procedure ToolbarCloseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FCurrentFrame: TBaseFrame;
    { Private declarations }
  public
    procedure InitFrame(FrameName: string);
    function Execute: Boolean; override;
    function ExecuteVar(FrameName: String): Boolean; override;
    property CurrentFrame: TBaseFrame read FCurrentFrame write FCurrentFrame;
  end;

implementation


{$R *.fmx}

uses UntModule;

procedure TFormControl.InitFrame(FrameName: string);
begin
   with TBaseFrame.CrateBaseFrame(FrameName) do
   begin
     Parent := LMain;
     Execute;
   end;
end;

procedure TFormControl.ToolbarCloseButtonClick(Sender: TObject);
begin
  Close;
end;

function TFormControl.Execute: Boolean;
begin
  inherited;

  InitFrame('TFrameSplash');
  TDModule.PlayMusic(MAIN_MUSIC_NAME);
  ShowModal;
  Result := True;
end;

function TFormControl.ExecuteVar(FrameName: String): Boolean;
begin
  inherited;

  InitFrame(FrameName);
  TDModule.PlayMusic(MAIN_MUSIC_NAME);
  ShowModal;
  Result := True;
end;

procedure TFormControl.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   TDModule.StopPlayer;
end;

procedure TFormControl.FormCreate(Sender: TObject);
begin
  TDModule.PlayMusic(MAIN_MUSIC_NAME);
end;
end.
