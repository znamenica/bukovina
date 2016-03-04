# language: ru
Функционал: Импортёр описания
   Сценарий: Простое описание
      Допустим есть память "Анания Бобков"
      И есть обработанные данные описания:
         """
         ---
           :language_code: :ру
           :text: описание Анания
           :memory:
             :short_name: Анания Бобков
         """

      Если импортируем их
      То будет создана модель описания с аттрибутами:
         | text            | описание Анания    |
         | language_code   | ру                 |
