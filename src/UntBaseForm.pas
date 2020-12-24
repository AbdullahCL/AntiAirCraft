// Base Form

// Create By AbdullahCL

// Create Date 12.11.2020

unit UntBaseForm;

interface

uses FMX.Forms, Classes, UntBaseFrame;

type
  TBaseForm = class(TForm)
    public
      function CrateBaseForm(FrmName: string): TBaseForm;
      function Execute: Boolean; virtual;
      function ExecuteVar(FrameName: string): Boolean; virtual;
  end;


implementation

{ TBaseForm }

type
  TBaseClass = class of TBaseForm;

function TBaseForm.CrateBaseForm(FrmName: string): TBaseForm;
var
  c: TBaseClass;
begin
  Result := nil;
  c := TBaseClass(GetClass(FrmName));

  if Assigned(c) then
  begin
    Result := TBaseForm(c.Create(nil));
  end;
end;

function TBaseForm.Execute: Boolean;
begin
  Result := True;
end;

function TBaseForm.ExecuteVar(FrameName: string): Boolean;
begin
  Result := True;
end;
end.
