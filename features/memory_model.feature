# language: ru
Функционал: Модель памяти
   Сценарий: Действительная запись
      Допустим создадим новую память с полями:
        | short_name     | Василий Памятливый |
      То память "Василий Памятливый" будет существовать

   Сценарий: Проверка полей модели имени
      Допустим есть память "Василий Памятливый"
      То свойство 'short_name' памяти "Василий Памятливый" не может быть пустым

   Сценарий: Проверка многосвязности поля имён
      Допустим есть память "Василий Памятливый"
      И есть русское имя Василий
      А имя Василий относится к памяти "Василий Памятливый"
      То многоимущие свойства "names, memory_names" памяти "Василий Памятливый" действенны