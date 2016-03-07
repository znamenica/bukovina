# language: ru
Функционал: Импортёр ссылки
   Сценарий: Простая вики ссылка
      Допустим есть память "Анания Бобков"
      И есть обработанные данные вики ссылки:
         """
         ---
         :language_code: :ру
         :url: http://wiki.ws/вики
         :description:
            :language_code: :ру
            :text: описание вики
         :memory:
            :short_name: Анания Бобков
         """

      Если импортируем их
      То будет создана модель ссылки с аттрибутами:
         | url             | http://wiki.ws/вики   |
         | language_code   | ру                    |
      И будет создана модель описания с аттрибутами:
         | text            | описание вики         |
         | language_code   | ру                    |
