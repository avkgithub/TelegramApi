# TelegramApi
Простой класс для отправки текстовых сообщений Telegram боту.
Разработан в среде Delphi XE2. Используются встроенные компоненты Indy.


# Пример использования:
```delphi
var
  TelegramApi: TTelegramApi;
begin
  TelegramApi := TTelegramApi.Create;
  try
    TelegramApi.Token := '123456789:AABBXXXXXXXXXXXXXXXXXXXXXXXXXXX';
    TelegramApi.SetProxy('192.xxx.xxx.xxx', 'login', 'pass') ;  // proxy 
    TelegramApi.SendMessage('123456789', 'Test');
  finally
    TelegramApi.Free;
  end;
```
