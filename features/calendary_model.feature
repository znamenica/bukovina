# language: ru
@model @calendary
Функционал: Модель календаря

   @language
   Сценарий: Проверка полей модели календаря
      Допустим есть модель календаря

      И свойства "slug, date" модели не могут быть пустыми
      И календарь имеет рода "строка" следущие столбцы:
         | столбец            |
         | author             |
         | date               |
         | slug               |
         | language_code      |
         | alphabeth_code     |


   Сценарий: Проверка многосвязности полей модели календаря
      Если есть модель календаря
      То у модели суть действенными многоимущие свойства:
         | свойства        | как          | зависимость  | имя рода  |
         | descriptions    | describable  | destroy      | описание  |
         | names           | describable  | destroy      | описание  |
      И свойство "descriptions" модели есть включения описания с зависимостями удаления
      И свойство "names" модели есть включения описания с зависимостями удаления
      И модель принимает вложенные настройки для свойства "descriptions"
      И модель принимает вложенные настройки для свойства "names"


   @language
   Сценарий: Действительная запись календаря
      Допустим создадим новый календарь с полями:
        | alphabeth_code   | ру        |
        | language_code    | ру        |
        | author           | Василий   |
        | slug             | клнд      |
        | date             | Година    |
      То календарь "клнд" будет действительным


   @language
   Сценарий: Недействительная связь календаря и его описания
      Допустим попробуем создать календарь "клнд" без описания

      То увидим сообщение календаря об ошибке:
         """
         Alphabeth_code is not included in the list
         """
      И календаря "клнд" не будет


   @language
   Сценарий: Действительная связь календаря и его описания
      Допустим есть календарь "клнд"

      Если создадим новое описание с полями:
        | alphabeth_code         | ру     |
        | language_code          | ру     |
        | text                   | Мурмур |
        | describable:calendary  | *клнд  |
      То календарь "клнд" будет действительным


   @language
   Сценарий: Неверный язык календаря
      Если попробуем создать новый календарь с полями:
        | alphabeth_code   | ру        |
        | language_code    | уу        |
        | author           | Василий   |
        | slug             | клнд      |
        | date             | Година    |
      То увидим сообщение календаря об ошибке:
         """
         Language_code is not included in the list
         """
      И календаря "клнд" не будет


   @language
   Сценарий: Неверный алфавит календаря
      Если попробуем создать новый календарь с полями:
        | alphabeth_code   | уу        |
        | language_code    | ру        |
        | author           | Василий   |
        | slug             | клнд      |
        | date             | Година    |
      То увидим сообщение календаря об ошибке:
         """
         Alphabeth_code is not included in the list
         """
      И календаря "клнд" не будет

   @language
   Сценарий: Недействительное описание календаря
      Если попробуем создать новый календарь "клнд" с неверным описанием
      То увидим сообщение календаря об ошибке:
         """
         Descriptions alphabeth_code is not included in the list
         Descriptions is invalid
         Names alphabeth_code is not included in the list
         Names is invalid
         """
      И календаря "клнд" не будет
