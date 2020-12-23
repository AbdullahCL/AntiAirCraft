unit UntBaseFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, System.Actions, FMX.ActnList;

type
  TBaseFrame = class(TFrame)
    BtnMainMenu: TButton;
    Layout: TLayout;
    BtnPlayGame: TButton;
    LabelTitle: TLabel;
    ActListBaseFrame: TActionList;
    ActPlayGame: TAction;
    ActMainMenu: TAction;
    procedure ActPlayGameExecute(Sender: TObject);
    procedure ActMainMenuExecute(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: Boolean; virtual;
    class function CrateBaseFrame(FrmName: string): TBaseFrame; overload;
    class function CrateBaseFrame(OlderFrame: TBaseFrame; FrmName: string): TBaseFrame; overload;
  end;

implementation

{$R *.fmx}

uses UntBaseForm, ShellApi, UntModule;

type
  TBaseClass = class of TBaseFrame;

class function TBaseFrame.CrateBaseFrame(FrmName: string): TBaseFrame;
var
  c: TBaseClass;
begin
  Result := nil;
  c := TBaseClass(GetClass(FrmName));

  if Assigned(c) then
  begin
    Result := TBaseFrame(c.Create(nil));
    Result.Visible := True;
    Result.Align := TAlignLayout.Client;
  end;
end;


procedure TBaseFrame.ActMainMenuExecute(Sender: TObject);
begin
  Self.Visible := False;
  CrateBaseFrame(Self, 'TFrameSplash');
end;

procedure TBaseFrame.ActPlayGameExecute(Sender: TObject);
begin
  inherited;
  Self.Visible := False;
  TBaseForm(Self.Parent.Owner).Close;
end;

class function TBaseFrame.CrateBaseFrame(OlderFrame: TBaseFrame;
  FrmName: string): TBaseFrame;
var
  layout: TLayout;
begin
   layout := TLayout(OlderFrame.Parent);
   OlderFrame.Visible := False;
   Result := CrateBaseFrame(FrmName);
   Result.Parent := layout;
end;

function TBaseFrame.Execute: Boolean;
begin
  Result := True;
end;

end.
