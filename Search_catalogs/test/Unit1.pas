unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uCatalogs, StdCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    Button2: TButton;
    SearchCatalogs1: TSearchCatalogs;
    procedure Button1Click(Sender: TObject);
    procedure SearchCatalogs1StartYandex;
    procedure SearchCatalogs1StopDMOZ;
    procedure SearchCatalogs1StartYahooDir;
    procedure SearchCatalogs1StartDMOZ;
    procedure SearchCatalogs1StopYahooDir;
    procedure SearchCatalogs1StopYandex;
    procedure SearchCatalogs1GiveDMOZ(InDMOZ: Boolean);
    procedure SearchCatalogs1GiveYahoo(InYahooDir: Boolean);
    procedure SearchCatalogs1GiveYandex(InYandex: Boolean);
    procedure SearchCatalogs1AcceptData(InYandex, InDMOZ, InYahooDir: Boolean);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
SearchCatalogs1.Domain:=Edit1.Text;
Edit1.Text:=SearchCatalogs1.Domain;
SearchCatalogs1.Options.Yandex:=CheckBox1.Checked;
SearchCatalogs1.Options.DMOZ:=CheckBox2.Checked;
SearchCatalogs1.Options.YahooDir:=CheckBox3.Checked;
SearchCatalogs1.Activate;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
SearchCatalogs1.Deactivate;
end;

procedure TForm1.SearchCatalogs1AcceptData(InYandex, InDMOZ,
  InYahooDir: Boolean);
begin
SearchCatalogs1GiveDMOZ(InDMOZ);
SearchCatalogs1GiveYahoo(InYahooDir);
SearchCatalogs1GiveYandex(InYandex);
end;

procedure TForm1.SearchCatalogs1GiveDMOZ(InDMOZ: Boolean);
begin
if InDMOZ then
  label8.Caption:='есть'
else
  label8.Caption:='нет';
label5.Caption:='отработал';
end;

procedure TForm1.SearchCatalogs1GiveYahoo(InYahooDir: Boolean);
begin
if InYahooDir then
  label9.Caption:='есть'
else
  label9.Caption:='нет';
label6.Caption:='отработал';
end;

procedure TForm1.SearchCatalogs1GiveYandex(InYandex: Boolean);
begin
if InYandex then
  label7.Caption:='есть'
else
  label7.Caption:='нет';
label4.Caption:='отработал';
end;

procedure TForm1.SearchCatalogs1StartDMOZ;
begin
 label5.Caption:='запущен'
end;

procedure TForm1.SearchCatalogs1StartYahooDir;
begin
 label6.Caption:='запущен'
end;

procedure TForm1.SearchCatalogs1StartYandex;
begin
 label4.Caption:='запущен'
end;

procedure TForm1.SearchCatalogs1StopDMOZ;
begin
 label5.Caption:='остановлен'
end;

procedure TForm1.SearchCatalogs1StopYahooDir;
begin
label6.Caption:='остановлен'
end;

procedure TForm1.SearchCatalogs1StopYandex;
begin
label4.Caption:='остановлен'
end;

end.
