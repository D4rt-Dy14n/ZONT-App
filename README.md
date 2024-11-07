## Задача - разработать приложение ZONT

Помогает юзеру понять, нужно ли брать с собой зонт перед выходом из дома. Один экран с местоположением пользователя, температурой и советом захватить зонт или нет.

<aside>
💡

Используем UIKit и Swift без сторонних библиотек и зависимостей.

</aside>

1. Получить локацию пользователя
2. Использовать бесплатный API от **OpenWeather** https://openweathermap.org/current для получения погоды. API Key можно получить сразу после регистрации, однако его валидируют примерно через 30 минут, нужно немного подождать.
3. Использовать **URLSession** и **Codable** для запроса погоды
4. Отобразить на экране название текущего местоположения, температуру и температуру “ощущается как” (feels_like). Использовать градус Цельсия.
5. Отобразить текущие погодные условия, например “Clear sky”. Если погодных условий несколько - перечислить через запятую. Например - “Light rain, Fog”
6. Узнать, идет ли сейчас дождь. Если идет - отобразить на главном экране текст “Grab an umbrella”. Если нет - “Don't take an umbrella”

Интерфейс не важен, но вот пример на всякий случай
<details><summary>Пример</summary>
<img src="https://github.com/user-attachments/assets/b95a6c7d-8577-4ecb-a96c-607e4d0a2eb6" width="300">
</details>


## Мое решение
<details><summary>Посмотреть</summary>
  
| Иконка | Интерфейс | Демонстрация |
|:--------------|:--------------|:--------------|
| <img src="https://github.com/user-attachments/assets/73a362f6-6d5d-4aae-beaf-5534b7a2cb67" width="300"> | <img src="https://github.com/user-attachments/assets/86ff9d31-63cb-4a49-81e8-42a5205e7003" width="300"> | <img src="https://github.com/user-attachments/assets/b1ec02f5-4512-4d1c-a907-6771d42ba138" width="300"> |

</details>

### В рамках тестового задания были выполнены все обязательные пункты, но также дополнительно:
1. Была выбрана архитектура MVC
2. При выполнении проекта соблюдены паттерны SOLID
3. Все зависимости выполнены в виде абстракций, т.е. протоколов. Реализацию легко подменить или замокать для тестов.
4. Обработка всех возможных сетевых ошибок + добавлен механизм Retry при недоступности сети с настраиваемым инициализатором.
5. Шифрованное хранилище (Keychain) для хранения API Key.
6. Обработка ошибок доступа к локации.
7. Настраиваемые стили для лейблов.
8. Лоадер для отображения процесса получения сетевых данных.
9. Настраиваемый градиент (угол градиента, кол-во и набор цветов, прозрачноть).
10. LaunchScreen с кастомным изображением и иконка приложения.
11. Основной экран вынесен в отдельный класс, чтобы не загромождать ViewController.


