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
{$SMARTLINK ON}
program acmp;
uses filecompu;
var
F1, F2 : TCmp;
r : byte;
begin
if ParamCount <> 2 then begin
writeln('File Compare 2023');
writeln('Use: ', ParamStr(0), ' file1 file2');
writeln('Сравнение файлов. 2023 год.');
writeln('Использование: ', ParamStr(0), ' файл1 файл2');
Halt(0);
end;

F1 := TCmp.Create;
F2 := TCmp.Create;

F1.map(ParamStr(1));
F2.map(ParamStr(2));

r := F1.Compare(F2);

F1.unmap;
F2.unmap;
F1.Free;
F2.Free;

Writeln(cmpn[r]);

Halt(r);

end.