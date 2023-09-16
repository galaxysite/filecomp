{
    Files compare
    Copyright (C) 2019-2023  Artyomov Alexander

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
{$RANGECHECKS ON}
{$SMARTLINK ON}
{$CODEPAGE UTF8}

unit filecompu;

interface

uses syscall;

const
  cmpn : array[0..3] of utf8string =
  ('Sizes and content of common part equal. Размер и содержимое равны.',
   'Sizes different, content of common part equal. Размер разный общая часть одинакова.',
   'Sizes equal, content of common part different. Размер одинаков общая часть различна.',
   'Sizes different, content of common part different. Размер разный общая часть различна.');

type
TCmp = class(TObject)
a : pbyte;
h, l : Int64;
p : Int64;
public
function map(n : utf8string) : boolean;
function unmap : boolean;
function Compare(c : TCmp) : byte;
end;

function Min(i1, i2 : Int64) : Int64;

implementation

function Min(i1, i2 : Int64) : Int64;
begin
if i1 < i2 then Exit(i1) else Exit(i2);
end;

function TCmp.map(n : utf8string) : boolean;
begin
h := do_SysCall(2 {Open}, Int64(PChar(n)),0 {R W old 2}); if h < 0 then begin WriteLn(stderr, 'Error: can''t open input file'); Exit(true); end;
l  := do_SysCall(8 {GET LEN}, h,0{from begin},2{SEEK_END});
p := do_SysCall(9 {FILEMAP}, 0{from begin},l,1{PROT_},1{MAP_},h,0{from begin file});
a := Pointer(p);
if (p < 0) or (do_SysCall(3 {Close}, h) < 0)  then begin WriteLn(stderr, 'Error: can''t map input file'); do_SysCall(3 {Close}, h); Exit(true); end;
Exit(false);
end;
function TCmp.unmap : boolean;
begin
Exit(do_SysCall(11 {Unmap}, p,l) <> 0);
end;

function TCmp.Compare(c : TCmp) : byte;
var hca, f : Int64;
begin
hca := c.l-1;
for f := 0 to Min((l-1), hca) do begin
 if a[f] <> c.a[f] then begin
  if (l-1) = hca then Exit(2) else Exit(3);
 end;
end;
if (l-1) = hca then Exit(0) else Exit(1);
end; // 0 - размер и содержимое равны, 1 - размер разный общая часть одинакова
// 2 - размер одинаков общая часть различна, 3 - размер разный общая часть различна

end.