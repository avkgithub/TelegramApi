{*****************************************************************}
{                                                                 }
{     Простой класс для отправки текстовых сообщений              }
{           Telegram боту                                         }
{                                                                 }
{       AVK 2019                                                  }
{                                                                 }
{*****************************************************************}


unit uTelegramApi;

interface

uses  Idhttp, System.SysUtils, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack,
   IdSSL, IdSSLOpenSSL, IdGlobal,  IdBaseComponent,  IdException ,  DBXJSON,
   IdSocks, IdURI  ;


  type
    TTelegramApi = class
      const
        API_URL = 'https://api.telegram.org/bot';
      private
        fHttp: TIdHTTP;
        fHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
        fIdSocksInfo: TIdSocksInfo;

        fToken: string;
        fUrl: string;
        fLogin: string;
        fPassword: string;
        //fUseProxy: boolean;

        function EmojiStr(AStr: string) : string;  // Заменяет служебные символы на коды Emoji
      public
        constructor Create;
        destructor Destroy;
        property Token: string read fToken write fToken;
       //  property UseProxy: boolean read fUseProxy write fUseProxy;
        procedure SetProxy(aHost, ALogin, APassword: string);
        function SendMessage(const AChatId, AMsg: string): boolean;

    end;

implementation

{ TTelegramApi }

constructor TTelegramApi.Create;
begin
  inherited Create;
  fHttp := TIdHTTP.Create(nil);
  fHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(fHttp);
  fHttp.IOHandler := fHandlerSocket;
  fIdSocksInfo := TIdSocksInfo.Create(fHttp);
  fIdSocksInfo.Version := svSocks5;
  fHandlerSocket.TransparentProxy := fIdSocksInfo;
end;

destructor TTelegramApi.Destroy;
begin
  fHandlerSocket.Free;
  fHttp.free;
  fIdSocksInfo.Free;
  inherited;
end;


function TTelegramApi.EmojiStr(AStr: string): string;
var
  S: string;
begin
  // Вставить emoji  Например:
  S := StringReplace(AStr, ':dollar:', #$1F4B5, [rfReplaceAll]);
  Result := S;
end;

function TTelegramApi.SendMessage(const AChatId, AMsg: string): boolean;
var
  s: string;
begin
  try
    Result := False;
    s := fHttp.Get(TIdURI.PathEncode(API_URL + fToken + '/' + 'sendMessage?chat_id='
          + AChatId + '&text=' + EmojiStr(AMsg) + '&parse_mode=Markdown'));
    Result := True;
  except
    on E: EIdHTTPProtocolException do
      raise Exception.Create(E.Message + ' : '+ E.ErrorMessage);
    on E: EIdException do
      raise Exception.Create('TTelegramApi.SendMessage: '+ E.Message);
    on E: Exception do
      raise Exception.Create('TTelegramApi.SendMessage: '+ E.Message);
  end;
end;

procedure TTelegramApi.SetProxy(aHost, ALogin, APassword: string);
begin
  fIdSocksInfo.Authentication := saUsernamePassword;
  fIdSocksInfo.Username := ALogin;
  fIdSocksInfo.Password := APassword;
  fIdSocksInfo.Host :=  aHost;
end;

end.
