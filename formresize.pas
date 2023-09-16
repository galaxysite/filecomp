unit formresize;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Spin, SpinEx;

type

  { TForm4 }

  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Ok(Sender: TObject);
    procedure OnCreate(Sender: TObject);
  private

  public

  end;

var
  Form4: TForm4;
  oldsize, newsize : Int64;

implementation

{$R *.lfm}

{ TForm4 }

procedure TForm4.Button1Click(Sender: TObject);
begin

end;

procedure TForm4.Ok(Sender: TObject);
begin
newsize := StrToIntDef(Edit1.Text, oldsize);
end;

procedure TForm4.OnCreate(Sender: TObject);
begin
Edit1.Text := IntToStr(oldsize);
Caption := IntToStr(oldsize);
end;

end.

