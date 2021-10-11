unit uCatalogs;

interface

uses Windows, Variants, ActiveX, wininet, Classes, InetThread, SysUtils,
     Messages, Controls, Forms, Dialogs;

const
  Yandex_URL = 'http://search.yaca.yandex.ru/yandsearch?text=%s&&rpt=rs2';
  DMOZ_URL = 'http://search.dmoz.org/cgi-bin/search?search=%s';
  YahooDir_URL = 'http://search.yahoo.com/search/dir?p=%s';

  YandexRegExp = '.*(?:сайт).*?(\d+)';//регулярка возвращает коллекцию, если сайт найден в каталоге
  YahooRegExp = 'No Directory Search results were found';//строка, говорящая о том, что сайт не найден в каталоге
  DMOZRegExp = '.*?No.*?results.*?found';//если сайт не найден в каталоге

type
  TOnAcceptDataEvent = procedure (InYandex,InDMOZ,InYahooDir:boolean) of object;
  TOnGiveYandexEvent = procedure (InYandex:boolean)of object;
  TOnGiveDMOZEvent = procedure (InDMOZ:boolean)of object;
  TOnGiveYahooDirEvent = procedure (InYahooDir:boolean)of object;
  TOnStopYandexEvent = procedure of object;
  TOnStopDMOZEvent = procedure of object;
  TOnStopYahooDirEvent = procedure of object;
  TOnStartYandexEvent = procedure of object;
  TOnStartDMOZEvent = procedure of object;
  TOnStartYahooDirEvent = procedure of object;

type
  TCatalogs = class(TPersistent)
  private
    FYandex: boolean;
    FDMOZ: boolean;
    FYahooDir: boolean;
  published
    property Yandex: boolean read FYandex write FYandex;
    property DMOZ: boolean read FDMOZ write FDMOZ;
    property YahooDir: boolean read FYahooDir write FYahooDir;
end;

type
  TSearchCatalogs = class(TComponent)
  private
     FDomain: string;
     FOptions: TCatalogs;
     FInYandex: boolean;
     FInDMOZ: boolean;
     FInYahooDir: boolean;
     FThreads: array [1..3]of TInetThread;//1-yandex, 2-DMOZ, 3-YahooDir
     FStreams: array [1..3]of TMemoryStream;
     FActive : boolean;
     FAcceptData:   TOnAcceptDataEvent;
     FGiveYandex:   TOnGiveYandexEvent;
     FGiveDMOZ:     TOnGiveDMOZEvent;
     FGiveYahooDir: TOnGiveYahooDirEvent;
     FStopYandex:   TOnStopYandexEvent;
     FStopDMOZ :    TOnStopDMOZEvent;
     FStopYahooDir: TOnStopYahooDirEvent;

     FStartYandex:   TOnStartYandexEvent;
     FStartDMOZ :    TOnStartDMOZEvent;
     FStartYahooDir: TOnStartYahooDirEvent;
     procedure SetThread(ThreadNum: byte);
     procedure OnAcceptThread(const ThreadNum:byte);
     procedure OnErrorThread(Error: string; ThreadNum:byte);
     function  GetYandex: boolean;
     function  GetDMOZ: boolean;
     function  GetYahooDir: boolean;
     procedure SetDomain(cURL: string);
  public
     constructor Create(AOwner:TComponent);override;
     procedure Activate;
     procedure Deactivate;
     property Active: boolean     read FActive;
     property InYandex:boolean    read GetYandex;
     property InDMOZ: boolean     read GetDMOZ;
     property InYahooDir: boolean read GetYahooDir;
  published
    property Options:TCatalogs read FOptions write FOptions;
    property Domain: string read FDomain write SetDomain;
    property OnAcceptData:TOnAcceptDataEvent read FAcceptData write FAcceptData;
    property OnGiveYandex: TOnGiveYandexEvent read FGiveYandex write FGiveYandex;
    property OnGiveDMOZ: TOnGiveDMOZEvent read FGiveDMOZ write FGiveDMOZ;
    property OnGiveYahoo: TOnGiveYahooDirEvent read FGiveYahooDir write FGiveYahooDir;
    property OnStopYandex: TOnStopYandexEvent read FStopYandex write FStopYandex;
    property OnStopDMOZ: TOnStopDMOZEvent read FStopDMOZ write FStopDMOZ;
    property OnStopYahooDir: TOnStopYahooDirEvent read FStopYahooDir write FStopYahooDir;
    property OnStartYandex: TOnStartYandexEvent read FStartYandex write FStartYandex;
    property OnStartDMOZ: TOnStartDMOZEvent read FStartDMOZ write FStartDMOZ;
    property OnStartYahooDir: TOnStartYahooDirEvent read FStartYahooDir write FStartYahooDir;
end;

procedure Register;

implementation

uses VBScript_RegExp_55_TLB;

{ TSearchCatalogs }

procedure Register;
begin
  RegisterComponents('WebDelphi.ru',[TSearchCatalogs]);
end;

procedure TSearchCatalogs.Activate;
begin
  if FOptions.FYandex then
    begin
      SetThread(1);
      if Assigned(FStartYandex) then
        OnStartYandex;
    end;
  if FOptions.FDMOZ then
    begin
      SetThread(2);
      if Assigned(FStartDMOZ) then
        OnStartDMOZ;
    end;
  if FOptions.FYahooDir then
    begin
      SetThread(3);
      if Assigned(FStartYahooDir) then
        OnStartYahooDir;
    end;
  FActive:=Assigned(FThreads[1])or Assigned(FThreads[2])or Assigned(FThreads[3]);
end;

constructor TSearchCatalogs.Create(AOwner: TComponent);
begin
  inherited;
  FOptions:=TCatalogs.Create;
end;

procedure TSearchCatalogs.Deactivate;
var i:integer;
begin
try
  for i:=1 to 3 do
    begin
      if Assigned(FThreads[i]) then
        begin
          TerminateThread(FThreads[i].Handle,0);
          FreeAndNil(FStreams[i]);
          case i of
            1:begin
                if Assigned(FStopYandex) then
                   OnStopYandex;
              end;
            2:begin
                if Assigned(FStopDMOZ) then
                   OnStopDMOZ;
              end;
            3:begin
                if Assigned(FStopYahooDir) then
                   OnStopYahooDir;
              end;
          end;
        end;
    end;
FActive:=false;
except
  MessageBox(0,'Ошибка при деактивации компонента','Ошибка',MB_OK+MB_ICONERROR)
end;
end;

function TSearchCatalogs.GetDMOZ: boolean;
var List: TStringList;
    R: TRegExp;
    mc: MatchCollection;
begin
Result:=false;
if not Assigned(FStreams[2]) then Exit;
List:=TStringList.Create;
List.LoadFromStream(FStreams[2]);
List.Text:=Utf8ToAnsi(List.Text);
R:=TRegExp.Create(self);
try
  R.Pattern:=DMOZRegExp;
  R.IgnoreCase:=true;
  R.Global:=true;
  R.Multiline:=true;
  mc:=R.Execute(List.Text)as MatchCollection;
  Result:=not(mc.Count>0);
  FInDMOZ:=Result;
  if Assigned(FGiveDMOZ) then
     OnGiveDMOZ(FInDMOZ);
finally
  mc:=nil;
  R.Free;
end;
end;


function TSearchCatalogs.GetYahooDir: boolean;
var List: TStringList;
begin
Result:=false;
if not Assigned(FStreams[3]) then Exit;
List:=TStringList.Create;
List.LoadFromStream(FStreams[3]);
List.Text:=Utf8ToAnsi(List.Text);
Result:=pos(YahooRegExp,List.Text)<=0;
FInYahooDir:=result;
if Assigned(FGiveYahooDir) then
   OnGiveYahoo(FInYahooDir);
end;

function TSearchCatalogs.GetYandex: boolean;
var List: TStringList;
    R: TRegExp;
    mc: MatchCollection;
begin
Result:=false;
if not Assigned(FStreams[1]) then Exit;
List:=TStringList.Create;
List.LoadFromStream(FStreams[1]);
List.Text:=Utf8ToAnsi(List.Text);
R:=TRegExp.Create(self);
try
  R.Pattern:=YandexRegExp;
  R.IgnoreCase:=true;
  R.Global:=true;
  R.Multiline:=true;
  mc:=R.Execute(List.Text)as MatchCollection;
  Result:=(mc.Count>0);
  FInYandex:=Result;
  if Assigned(FGiveYandex) then
     OnGiveYandex(FInYandex);
finally
  mc:=nil;
  R.Free;
end;
end;

procedure TSearchCatalogs.OnAcceptThread(const ThreadNum: byte);
begin
case ThreadNum of
  1:begin
      GetYandex;
      if Assigned(FGiveYandex) then
        OnGiveYandex(FInYandex);
    end;
  2:begin
      GetDMOZ;
      if Assigned(FGiveDMOZ) then
        OnGiveYandex(FInDMOZ);
    end;
  3:begin
      GetYahooDir;
      if Assigned(FGiveYahooDir) then
        OnGiveYandex(FInYahooDir);
    end;
end;
if Assigned(FAcceptData) then
   OnAcceptData(FInYandex,FInDMOZ,FInYahooDir)
end;

procedure TSearchCatalogs.OnErrorThread(Error: string; ThreadNum:byte);
begin
  try
    if Assigned(FThreads[ThreadNum]) then
       TerminateThread(FThreads[ThreadNum].Handle,0);
    if Assigned(FStreams[ThreadNum]) then
       FreeAndNil(FStreams[ThreadNum]);
  except
  end;
case ThreadNum of
  1:MessageBox(0,Pchar('Ошибка получения данных от Яндекс.Каталога. Текст ошибки: '+#10#13+Error),'Ошибка потока',MB_OK+MB_ICONERROR);
  2:MessageBox(0,Pchar('Ошибка получения данных от DMOZ. Текст ошибки: '+#10#13+Error),'Ошибка потока',MB_OK+MB_ICONERROR);
  3:MessageBox(0,Pchar('Ошибка получения данных от Yahoo Directory. Текст ошибки: '+#10#13+Error),'Ошибка потока',MB_OK+MB_ICONERROR);
end;

end;

procedure TSearchCatalogs.SetDomain(cURL: string);
var
  aURLC: TURLComponents;
  lencurl: Cardinal;
  aURL: string;
begin
  if pos('http://', cURL) = 0 then
    cURL := 'http://' + cURL;
  if pos(FDomain, cURL) > 0 then
    Exit;

  FillChar(aURLC, SizeOf(TURLComponents), 0);
  with aURLC do
  begin
    lpszScheme := nil;
    dwSchemeLength := INTERNET_MAX_SCHEME_LENGTH;
    lpszHostName := nil;
    dwHostNameLength := INTERNET_MAX_HOST_NAME_LENGTH;
    lpszUserName := nil;
    dwUserNameLength := INTERNET_MAX_USER_NAME_LENGTH;
    lpszPassword := nil;
    dwPasswordLength := INTERNET_MAX_PASSWORD_LENGTH;
    lpszUrlPath := nil;
    dwUrlPathLength := INTERNET_MAX_PATH_LENGTH;
    lpszExtraInfo := nil;
    dwExtraInfoLength := INTERNET_MAX_PATH_LENGTH;
    dwStructSize := SizeOf(aURLC);
  end;
  lencurl := INTERNET_MAX_URL_LENGTH;
  SetLength(aURL, lencurl);
  InternetCanonicalizeUrl(PChar(cURL), PChar(aURL), lencurl, ICU_BROWSER_MODE);
  if InternetCrackUrl(PChar(aURL), length(aURL), 0, aURLC) then
  begin
    FDomain := aURLC.lpszHostName;
    Delete(FDomain, pos(aURLC.lpszUrlPath, aURLC.lpszHostName), length
        (aURLC.lpszUrlPath));
  end
  else
    raise Exception.Create('SetDomain - Ошибка WinInet #' + IntToStr
        (GetLastError));
end;



procedure TSearchCatalogs.SetThread(ThreadNum: byte);
var aURL: string;
begin
  case ThreadNum of
    1:aURL:=Format(Yandex_URL,[FDomain]);
    2:aURL:=Format(DMOZ_URL,[FDomain]);
    3:aURL:=Format(YahooDir_URL,[FDomain]);
  end;
  if Assigned(FStreams[ThreadNum]) then
    try
      FreeAndNil(FStreams[ThreadNum]);
    except
    end;
  FStreams[ThreadNum]:=TMemoryStream.Create;
  FThreads[ThreadNum]:=TInetThread.Create(true,aURL,Pointer(FStreams[ThreadNum]),ThreadNum);
  FThreads[ThreadNum].FreeOnTerminate:=true;
  FThreads[ThreadNum].OnAcceptedEvent:=OnAcceptThread;
  FThreads[ThreadNum].Resume;
end;

end.
