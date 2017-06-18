# language: ru
Функционал: Импортёр календаря
   Сценарий: Простое помина
      Допустим есть обработанные данные календаря:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :slug:
             :text: клдр
           :author_name: Автор
           :date: 10.10.1001
           :descriptions:
           - :alphabeth_code: :ру
             :language_code: :ру
             :text: Описание календаря
           :names:
           - :alphabeth_code: :ру
             :language_code: :ру
             :type: Appellation
             :text: Календарь
         """

      Если импортируем их
      То будет создана модель календаря с аттрибутами:
         | alphabeth_code  | ру           |
         | language_code   | ру           |
         | author_name     | Автор        |
         | date            | 10.10.1001   |
      То будет создана модель описания с аттрибутами:
         | alphabeth_code  | ру                 |
         | language_code   | ру                 |
         | text            | Описание календаря |
      То будет создана модель слуга с аттрибутами:
         | text            | клдр |
      То будет создана модель наименования с аттрибутами:
         | alphabeth_code  | ру           |
         | language_code   | ру           |
         | text            | Календарь    |
         | type            | Appellation  |
