unit frmLuaEngineUnit;

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Menus, ExtCtrls, luahandler,lua, lauxlib, lualib;

type

  { TfrmLuaEngine }

  TfrmLuaEngine = class(TForm)
    btnExecute: TButton;
    GroupBox1: TGroupBox;
    MainMenu1: TMainMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    cbShowOnPrint: TMenuItem;
    mOutput: TMemo;
    mScript: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    SaveDialog1: TSaveDialog;
    Splitter1: TSplitter;
    procedure btnExecuteClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure Panel2Resize(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  frmLuaEngine: TfrmLuaEngine;

implementation

{ TfrmLuaEngine }

procedure TfrmLuaEngine.Panel2Resize(Sender: TObject);
begin
  btnexecute.Height:=panel2.clientheight-(2*btnexecute.top);
end;

procedure TfrmLuaEngine.btnExecuteClick(Sender: TObject);
var pc: pchar;
  i,j: integer;
begin
  luacs.Enter;
  try
    mOutput.lines.add(mscript.text);
    if lua_dostring(luavm, pchar(mScript.text) )=0 then
    begin


      j:=lua_gettop(luavm);
      if j>0 then
      begin
        for i:=-j to -1 do
        begin
          pc:=lua_tolstring(luavm, i,nil);
          if pc<>nil then
            mOutput.lines.add(':'+pc)
          else
          begin
            if lua_islightuserdata(luavm,i) then
            begin
              moutput.lines.add(':p->'+inttohex(ptruint(lua_touserdata(luavm,i)),1));

            end else moutput.lines.add(':'+'nil');

          end;
        end;

        lua_pop(luavm, lua_gettop(luavm)); //balance the stack
      end;
    end
    else
    begin
      i:=lua_gettop(luavm);
      if i>0 then
      begin
        pc:=lua_tolstring(luavm, -1,nil);
        if pc<>nil then
          mOutput.lines.add('error:'+pc)
        else
          moutput.lines.add('error:'+'nil');

        lua_pop(luavm, i);
      end else moutput.lines.add('error');

    end;
  finally
    luacs.Leave;
  end;
end;

procedure TfrmLuaEngine.MenuItem2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    mscript.Lines.LoadFromFile(opendialog1.filename);
end;

procedure TfrmLuaEngine.MenuItem3Click(Sender: TObject);
begin
  if savedialog1.execute then
    mscript.lines.SaveToFile(savedialog1.filename);
end;

procedure TfrmLuaEngine.MenuItem5Click(Sender: TObject);
begin
  moutput.Clear;
end;

initialization
  {$I frmluaengineunit.lrs}

end.

