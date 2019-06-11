unit Tetris;

interface

const BLine=1;
      BHorseLeft=2;
      BHorseRight=3;
      BBricksLeft=4;
      BBricksRight=5;
      BTank=6;
      BSquare=7;
      mw=9;
      mh=25;
      mwx=10;
      mhx=26;

type
  TField = array [0..mwx,0..mhx] of 0..1;
  TBlock = array [0..4,0..4] of 0..1;
  TScore = array [1..4] of 0..1;
  TTetris =
    object
      field:TField;
      block:TBlock;
      shape:Integer;
      angle:Integer;
      color:Integer;
      procedure Init;
      procedure Define(sh,a:Integer);
      function Scan(x,y:integer):boolean;
      procedure Update(x,y:integer);
      function Score(var scores:TScore):boolean;
    end;

implementation

procedure TTetris.Init;
var i,j:integer;
begin
  for i:=1 to mw do begin
    for j:=1 to mh do begin
      field[i,j]:=0;
    end;
    field[i,mhx]:=1;
  end;
  for i:=0 to mhx do begin
    field[0,i]:=1;
    field[mwx,i]:=1;
  end;
end;

procedure TTetris.Define;
var i,j:integer;
begin
  shape:=sh; angle:=a;
  for i:=1 to 4 do for j:=1 to 4 do block[i,j]:=0;
  case shape of
    1:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; block[2,4]:=1; end;
      2:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[4,2]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; block[2,4]:=1; end;
      4:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[4,2]:=1; end;
    end;
    2:case angle of
      1:begin block[1,1]:=1; block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; end;
      2:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[3,1]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; block[3,3]:=1; end;
      4:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[1,3]:=1; end;
    end;
    3:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; block[3,1]:=1; end;
      2:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[3,3]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[2,3]:=1; block[1,3]:=1; end;
      4:begin block[1,2]:=1; block[2,2]:=1; block[3,2]:=1; block[1,1]:=1; end;
    end;
    4:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[3,2]:=1; end;
      2:begin block[3,1]:=1; block[2,2]:=1; block[3,2]:=1; block[2,3]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[3,2]:=1; end;
      4:begin block[3,1]:=1; block[2,2]:=1; block[3,2]:=1; block[2,3]:=1; end;
    end;
    5:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[3,1]:=1; block[1,2]:=1; end;
      2:begin block[2,1]:=1; block[2,2]:=1; block[3,2]:=1; block[3,3]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[3,1]:=1; block[1,2]:=1; end;
      4:begin block[2,1]:=1; block[2,2]:=1; block[3,2]:=1; block[3,3]:=1; end;
    end;
    6:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[1,2]:=1; block[3,2]:=1; end;
      2:begin block[2,1]:=1; block[2,2]:=1; block[3,2]:=1; block[2,3]:=1; end;
      3:begin block[1,2]:=1; block[2,2]:=1; block[2,3]:=1; block[3,2]:=1; end;
      4:begin block[1,2]:=1; block[2,2]:=1; block[2,1]:=1; block[2,3]:=1; end;
    end;
    7:case angle of
      1:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[1,2]:=1; end;
      2:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[1,2]:=1; end;
      3:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[1,2]:=1; end;
      4:begin block[2,1]:=1; block[2,2]:=1; block[1,1]:=1; block[1,2]:=1; end;
    end;
  end;
end;

function TTetris.Scan;
var i,j:integer; ok:boolean;
begin
  Scan:=false; j:=1; i:=1; ok:=false;
  while not ok do begin
    if (block[i,j]=1) and (field[i+x,j+y]=1) then begin
      Scan:=true; ok:=true;
    end;
    inc(j); if j=5 then begin j:=1; inc(i); end;
    if i=5 then ok:=true;
  end;
end;

procedure TTetris.Update;
var i,j:integer;
begin
  for i:=1 to 4 do for j:=1 to 4 do
    if (block[i,j]=1) and (i+x<mwx) and (j+y<mhx) then
      field[i+x,j+y]:=1;
end;

function TTetris.Score;

const nilscore:TScore = (0,0,0,0);
var i,j,count:integer;
    full:boolean;

 procedure del(y:integer);
 var i,j:integer;
 begin
   for i:=1 to 9 do
     for j:=y downto 2 do begin
       field[i,j]:=field[i,j-1];
       field[i,j-1]:=0;
     end;
 end;

begin
  scores:=nilscore; count:=0; score:=false;
  for j:=1 to mh do begin
    full:=true;
    for i:=1 to mw do
      if field[i,j]=0 then full:=false;
    if full then begin del(j); inc(count); end;
  end;
  if count>0 then begin
     scores[count]:=1;
     score:=true;
  end;
end;

end.