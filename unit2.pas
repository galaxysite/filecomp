unit Unit2;

{
    Files compare
    Copyright (C) 2019-2021  Artyomov Alexander

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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids,
  Buttons;

type

  { TForm2 }

  TForm2 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ListBox1: TListBox;
    procedure Cancel(Sender: TObject);
    procedure oc(Sender: TObject);
    procedure Actions(a : Int64);
    procedure oncl(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

uses Unit1;

{ TForm2 }

procedure TForm2.oc(Sender: TObject);
var f : Int64;
begin
for f := 0 to 255 do ListBox1.AddItem(IntToStr(f) +
 ' HEX: ' + IntToHex(f, 8) + ' Char: ' + FToStr(f), nil);
ListBox1.ItemIndex:= edval;
end;

procedure TForm2.Cancel(Sender: TObject);
begin
  Close;
end;

procedure TForm2.Actions(a : Int64);
begin
case a of
1: begin // save
  edval := ListBox1.ItemIndex;
  ModalResult := 1;
end;
end; {end case}
end;

procedure TForm2.oncl(Sender: TObject);
begin
  Actions(1);
end;

end.

