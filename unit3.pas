unit Unit3;

{
    Files compare
    Copyright (C) 2021  Artyomov Alexander

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { TForm3 }

  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Change1(Sender: TObject);
    procedure Change2(Sender: TObject);
    procedure CloseButton(Sender: TObject);
  private

  public

  end;

var
  Form3: TForm3;

implementation

uses unit1;

{$R *.lfm}

{ TForm3 }

procedure TForm3.CloseButton(Sender: TObject);
begin
File1.findp := 0;
File1.finds := false;
File2.findp := 0;
File2.finds := false;
  Close;
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
if File1.FindAfter then Form1.StringGrid1.Row := File1.findp + 1;
end;
procedure TForm3.Button1Click(Sender: TObject);
begin
if File1.FindBefore then Form1.StringGrid1.Row := File1.findp + 1;
end;
procedure TForm3.Button3Click(Sender: TObject);
begin
if File2.FindBefore then Form1.StringGrid1.Row := File2.findp + 1;
end;
procedure TForm3.Button4Click(Sender: TObject);
begin
if File2.FindAfter then Form1.StringGrid1.Row := File2.findp + 1;
end;

procedure TForm3.Change1(Sender: TObject);
begin
  File1.TextToHex(Edit1.Text);
  Label1.Caption := File1.HexToText;
  File1.findp := 0;
  File1.finds := false;
end;

procedure TForm3.Change2(Sender: TObject);
begin
  File2.TextToHex(Edit2.Text);
  Label2.Caption := File2.HexToText;
  File2.findp := 0;
  File2.finds := false;
end;

end.

