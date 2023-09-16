unit gcmpc;

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

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$SMARTLINK ON}
{$RANGECHECKS ON}
{$codepage utf8}
{$GOTO ON}

interface

uses sysutils,syscall;

const
  cmpn : array[0..3] of utf8string =
  ('Sizes and content of common part equal. Размер и содержимое равны.',
   'Sizes different, content of common part equal. Размер разный общая часть одинакова.',
   'Sizes equal, content of common part different. Размер одинаков общая часть различна.',
   'Sizes different, content of common part different. Размер разный общая часть различна.');

type
  TAoB = array of byte;

  TCmpFile = class(TObject)
  a : PByte;
  find : TAoB;
  fFileName, ffind : utf8string;
  hf : Int64;
  findp : Int64;
  finds : boolean;
  fs : Int64;
  p : Int64;
  public
  function map(s : utf8string) : boolean;
  function unmap : boolean;
   function LoadFromFile(fn : utf8string) : boolean;
   function ReLoad : boolean;
   function SaveToFile(fn : utf8string) : boolean;
   function Save : boolean;
   function Compare(c : TCmpFile) : byte;
   procedure TextToHex(s : string);
   function HexToText : string;
   function FindBefore : boolean;
   function FindAfter : boolean;
   function ReSize(i : Int64) : boolean;
  end;

function Min(i1, i2 : Int64) : Int64;
function Max(i1, i2 : Int64) : Int64;

implementation

function TCmpFile.ReSize(i : Int64) : boolean;
const c : byte = 0;
var
 h: file of byte;
 f : Int64;
begin
if i = fs then Exit(false);
unmap;
Assign(h, fFileName);
FileMode := 2;
ReSet(h);
if i > fs then begin // +
 Seek(h, FileSize(h));
 for f := 0 to i-fs - 1 do begin
	write(h, c);
 end;
end else begin // -
 Seek(h , i);
 Truncate(h);
end;
Close(h);
map(fFileName);
Exit(false);
end;

function TCmpFile.map(s : utf8string) : boolean;
var h : Int64;
begin
fFileName := s;
h := do_SysCall(2 {Open}, Int64(PChar(fFileName)),2 {R W old 2}); if h < 0 then begin WriteLn(stderr, 'Error: can''t open input file'); Exit(true); end;
fs  := do_SysCall(8 {GET LEN}, h,0{from begin},2{SEEK_END});
p := do_SysCall(9 {FILEMAP}, 0{from begin},fs,2{PROT_},1{MAP_},h,0{from begin file});
a := Pointer(p);
if (do_SysCall(3 {Close}, h) < 0)  then begin WriteLn(stderr, 'Error: can''t map input file'); Exit(true); end;
Exit(false);
end;
function TCmpFile.unmap : boolean;
begin
Exit(do_SysCall(11 {Unmap}, p,fs) <> 0);
end;

procedure TCmpFile.TextToHex(s : string);
var f : LongInt;
  half : boolean = false;
begin
SetLength(find,0);
for f := 1 to Length(s) do begin

case s[f] of
'0': begin
   if half then begin
   find[High(find)] := find[High(find)] shl 4;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   half := true;
   end;
     end;
'1': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 1;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 1;
   half := true;
   end;
     end;
'2': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 2;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 2;
   half := true;
   end;
     end;
'3': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 3;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 3;
   half := true;
   end;
     end;
'4': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 4;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 4;
   half := true;
   end;
     end;
'5': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 5;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 5;
   half := true;
   end;
     end;
'6': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 6;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 6;
   half := true;
   end;
     end;
'7': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 7;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 7;
   half := true;
   end;
     end;
'8': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 8;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 8;
   half := true;
   end;
     end;
'9': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 9;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 9;
   half := true;
   end;
     end;
'a','A': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 10;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 10;
   half := true;
   end;
     end;
'b','B': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 11;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 11;
   half := true;
   end;
     end;
'c','C': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 12;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 12;
   half := true;
   end;
     end;
'd','D': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 13;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 13;
   half := true;
   end;
     end;
'e','E': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 14;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 14;
   half := true;
   end;
     end;
'f','F': begin
   if half then begin
   find[High(find)] := (find[High(find)] shl 4) + 15;
   half := false;
   end else begin
   SetLength(find, Length(find) + 1);
   find[High(find)] := 15;
   half := true;
   end;
     end;
end;
end;
end;
function TCmpFile.HexToText : string;
var
    f : LongInt;
begin
result := '';
for f := 0 to high(find) do result := result + IntToHex(find[f]);
end;

function TCmpFile.FindBefore : boolean;
function s : byte; begin if finds then exit(1) else exit(0); end;
label ex;
var f, ff : Int64;
begin
hf := High(find);
result := false;
if (hf < 0) or ((fs-1) < 0) or (hf > (fs-1)) then exit(result);
for f := findp - s downto 0 do begin
    if a[f] = find[0] then begin
       for ff := 0 to hf do begin
       if find[ff] <> a[f+ff] then goto ex;
       end;
    findp := f;
    finds := true;
    Exit(true);
    end;
    ex:
end;
end;
function TCmpFile.FindAfter : boolean;
function s : byte; begin if finds then exit(1) else exit(0); end;
label ex;
var f, ff : Int64;
begin
hf := High(find);
result := false;
if (hf < 0) or ((fs-1) < 0) or (hf > (fs-1)) then exit(result);
for f := findp + s to (fs-1) - hf do begin
    if a[f] = find[0] then begin
       for ff := 1 to hf do begin
       if find[ff] <> a[f+ff] then goto ex;
       end;
    findp := f;
    finds := true;
    Exit(true);
    end;
    ex:
end;
end;

function Min(i1, i2 : Int64) : Int64;
begin
if i1 < i2 then Exit(i1) else Exit(i2);
end;

function Max(i1, i2 : Int64) : Int64;
begin
if i1 < i2 then Exit(i2) else Exit(i1);
end;

function TCmpFile.LoadFromFile(fn : utf8string) : boolean;
begin
if fn = '' then Exit(true);
findp := 0;
finds := false;
Exit(map(fn));
end;

function TCmpFile.ReLoad : boolean;
begin
if fFileName = '' then Exit(true);
unmap;
Exit(map(fFileName));
end;

function TCmpFile.SaveToFile(fn : utf8string) : boolean;
var
  fp : File of byte;
begin
if (fFileName = fn) or (fn = '') then Exit(true);
Assign(fp, fn);
{$I-}
ReWrite(fp);
{$I+} if IOResult <> 0 then Exit(true);
{$I-}
BlockWrite(fp, a[0], fs);
{$I+} if IOResult <> 0 then Exit(true);
{$I-}
Close(fp);
{$I+} if IOResult <> 0 then Exit(true);
unmap;
Exit(map(fn));
end;

function TCmpFile.Save : boolean;
begin
Exit(ReLoad);
end;

function TCmpFile.Compare(c : TCmpFile) : byte;
var hca, f : Int64;
begin
hca := c.fs-1;
for f := 0 to Min((fs-1), hca) do begin
 if a[f] <> c.a[f] then begin
  if (fs-1) = hca then Exit(2) else Exit(3);
 end;
end;
if (fs-1) = hca then Exit(0) else Exit(1);
end; // 0 - размер и содержимое равны, 1 - размер разный общая часть одинакова
// 2 - размер одинаков общая часть различна, 3 - размер разный общая часть различна

end.
