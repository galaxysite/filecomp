unit Unit1;

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
  Unit2, Unit3, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, Grids, ComCtrls, strutils, gcmpc, Types, formresize;

type

  { TForm1 }

  TForm1 = class(TForm)
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    PopupMenu3: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    StringGrid1: TStringGrid;
    procedure dbl(Sender: TObject);
    procedure hc(Sender: TObject; IsColumn: Boolean; Index: Integer);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure odc(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
      aState: TGridDrawState);
    procedure oebc(Sender: TObject);
    procedure Actions(n : Int64);
    procedure Display;
    procedure oncr(Sender: TObject);
    procedure OpenFind(Sender: TObject);
    procedure ReSize1(Sender: TObject);
    procedure ReSize2(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
  File1, File2 : TCmpFile;
  edval, tmpval : byte;

function FToStr(b : byte) : utf8string;

implementation

{$R *.lfm}

function FToStr(b : byte) : utf8string;
begin if b > 31 then Exit(Char(b)) else Exit('.'); end;

{ TForm1 }

procedure TForm1.dbl(Sender: TObject);
begin
//  showmessage('d c R:' + IntToStr(StringGrid1.Row) + ' C:' + IntToStr(StringGrid1.Col));
  Actions(2);
end;

procedure TForm1.hc(Sender: TObject; IsColumn: Boolean; Index: Integer);
begin
case iscolumn of
true : begin
  case index of
  0: PopupMenu3.PopUp;
  1: PopupMenu1.PopUp;
  2: PopupMenu2.PopUp;
  end;
end;
false :begin
end;
end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
Actions(0);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
Actions(1);
end;

procedure TForm1.odc(Sender: TObject; aCol, aRow: Integer; aRect: TRect;
  aState: TGridDrawState);
var
  la1, la2 : Int64;
begin

  if ARow < 1 then Exit;

la1 := File1.fs;
la2 := File2.fs;

with StringGrid1, StringGrid1.Canvas do begin
case ACol of
1: begin
   if ARow > la1 then begin
     Canvas.Brush.Color:=clBtnFace;
     FillRect(aRect);
     Exit;
   end;
end;
2: begin
   if ARow > la2 then begin
    Canvas.Brush.Color:=clBtnFace;
    FillRect(aRect);
    Exit;
   end;
end;
end;
la1 := Min(la1, la2);
if ARow > la1 then Exit;
case ACol of
1,2: begin
if File1.a[ARow-1] <> File2.a[ARow-1] then begin
 Canvas.Brush.Color:=clRed;
 FillRect(aRect);
 TextOut(aRect.Left+2, aRect.Top+2, Cells[ACol, ARow]);
end;
end;
end;

end;

end;

procedure TForm1.oebc(Sender: TObject);
begin
//  showmessage('e');
end;

procedure TForm1.Actions(n : Int64);
var
  mr : Int64;
begin
case n of
0: begin // open dialog and open file 1
   if OpenDialog1.Execute then begin
     if File1.LoadFromFile(OpenDialog1.FileName) then
        showmessage('Error in open file: ' + OpenDialog1.FileName);
     Display;
   end;
end;
1: begin // open dialog and open file 2
   if OpenDialog2.Execute then begin
     if File2.LoadFromFile(OpenDialog2.FileName) then
        showmessage('Error in open file: ' + OpenDialog2.FileName);
     Display;
   end;
end;
2: begin // edit file 1, 2
   if StringGrid1.Row > 0 then begin
   case StringGrid1.Col of
   1: begin
      if StringGrid1.Row <= File1.fs then begin
      edval := File1.a[StringGrid1.Row - 1]; tmpval := edval;
      Form2 := TForm2.Create(self); mr := Form2.ShowModal;
      if mr = 1 then begin
      if tmpval <> edval then begin
      File1.a[StringGrid1.Row - 1] := edval;
      if File1.Save then showmessage('Error save in File1 ' + File1.fFileName);
      File2.ReLoad;
      Display;
      end;
      end;
      end;
   end;
   2: begin
      if StringGrid1.Row <= File2.fs then begin
      edval := File2.a[StringGrid1.Row - 1]; tmpval := edval;
      Form2 := TForm2.Create(self); mr := Form2.ShowModal;
      if mr = 1 then begin
      if tmpval <> edval then begin
      File2.a[StringGrid1.Row - 1] := edval;
      if File2.Save then showmessage('Error save in File2 ' + File2.fFileName);
      File1.ReLoad;
      Display;
      end;
      end;
      end;
   end;
end;

end;
end;

end;
end;

procedure TForm1.Display;
var b : byte; f : Int64;
begin
StringGrid1.Cells[1,0] := File1.fFileName;
StringGrid1.Cells[2,0] := File2.fFileName;
b := File1.Compare(File2);
Caption := IntToStr(b) + '. ' + cmpn[b];
StringGrid1.RowCount := Max(File1.fs, File2.fs) + 1;
for f := 1 to StringGrid1.RowCount - 1 do begin
 StringGrid1.Cells[0, f] := '(' + IntToStr(f - 1) + ') ' + IntToStr(f) +
 ' HEX: (' + IntToHex(f-1, 8) + ') ' + IntToHex(f, 8);
end;

for f := 1 to File1.fs do
 StringGrid1.Cells[1, f] := 'HEX: ' + IntToHex(File1.a[f-1], 2) + ' Char: ' + FToStr(File1.a[f-1]) + '  D: ' + IntToStr(File1.a[f-1]) + ' BIN: ' + IntToBin(File1.a[f-1], 8);

for f := 1 to File2.fs do
 StringGrid1.Cells[2, f] := 'HEX: ' + IntToHex(File2.a[f-1], 2) + ' Char: ' + FToStr(File2.a[f-1]) + '  D: ' + IntToStr(File2.a[f-1]) + ' BIN: ' + IntToBin(File2.a[f-1], 8);

end;

procedure TForm1.oncr(Sender: TObject);
begin
case ParamCount of
1: begin
  File1.LoadFromFile(ParamStr(1));
  Display;
end;
2: begin
  File1.LoadFromFile(ParamStr(1));
  File2.LoadFromFile(ParamStr(2));
  Display;
end else
  StringGrid1.Cells[1,0] := 'Menu File1 | Меню файла 1';
  StringGrid1.Cells[2,0] := 'Menu File2 | Меню файла 2';
end;
StringGrid1.Cells[0,0] := 'Program Menu | Меню программы';
end;

procedure TForm1.OpenFind(Sender: TObject);
begin
  Form3.Show;
end;

procedure TForm1.ReSize1(Sender: TObject);
begin
formresize.oldsize := File1.fs;
if Form4.ShowModal = mrOk then begin
if formresize.newsize < 0 then exit;
File1.ReSize(formresize.newsize);
Display;
end;
end;

procedure TForm1.ReSize2(Sender: TObject);
begin
formresize.oldsize := File2.fs;
if Form4.ShowModal = mrOk then begin
if formresize.newsize < 0 then exit;
File2.ReSize(formresize.newsize);
Display;
end;
end;

initialization
File1 := TCmpFile.Create;
File2 := TCmpFile.Create;
end.

