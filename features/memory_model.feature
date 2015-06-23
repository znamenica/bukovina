# language: ru
Функционал: Модель памяти
   Сценарий: Действительная запись
      Допустим есть новая пустая запись памяти
      Если задаём поле 'short_name' значением 'Василий Памятливый'
      То сохранивши память "Василий Памятливый" будет существовать

   Сценарий: Проверка полей модели имени
      Допустим есть память "Василий Памятливый"
      То свойство 'short_name' памяти "Василий Памятливый" не может быть пустым

   Сценарий: Проверка многосвязности поля имён
      Допустим есть память "Василий Памятливый"
      И есть русское имя Василий
      А имя Василий относится к памяти "Василий Памятливый"
      То многосвязное свойство "names" памяти "Василий Памятливый" действенно
