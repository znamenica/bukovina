# language: ru
@model @item_type
Функционал: Модель типа предмета

   @language
   Сценарий: Проверка полей модели типа предмета
      Допустим есть модель типа предмета

      И свойство "descriptions" модели не может быть пустым


   Сценарий: Проверка многосвязности полей модели типа предмета
      Если есть модель типа предмета
      То у модели суть действенными многоимущие свойства:
         | свойство        |
         | descriptions    |
         | items           |


   @language
   Сценарий: Недействительная запись типа предмета из-за отсутствия описания
      Если попробуем создать новый тип предмета без описаний
      То увидим сообщение типа предмета об ошибке:
         """
         Descriptions can't be blank
         """
      И типа предмета не будет


   @language
   Сценарий: Недействительная запись типа предмета из-за неверного описания
      Если попробуем создать новый тип предмета с неверным описанием
      То увидим сообщение типа предмета об ошибке:
         """
         Descriptions is invalid
         Descriptions text contains invalid char(s) "Iadilnv" for the specified alphabeth "ру"
         """
      И типа предмета не будет
