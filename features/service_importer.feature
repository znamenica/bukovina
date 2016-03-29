# language: ru
@importer @service
Функционал: Импортёр службы
   Сценарий: Простая служба
      Допустим есть память "Анания Бобков"
      И есть обработанные данные службы:
         """
         ---
         - :language_code: :ру
           :name: Анании Бобкову служба
           :magnifications:
           - :language_code: :ру
             :text: Величание
           :chants:
           - :language_code: :ру
             :type: Troparion
             :prosomeion_title: Тропарёв текст
             :text: Тропарёв ин текст.
             :tone: 4
           - :language_code: :ру
             :type: Kontakion
             :text: Кондаков иной текст
             :tone: 1
           :memory:
             :short_name: Анания Бобков
         """

      Если импортируем их
      То будет создана модель службы с аттрибутами:
         | language_code      | ру                       |
         | name               | Анании Бобкову служба    |
         | memory             | *Анания Бобков           |
      И будет создана модель тропаря с аттрибутами:
         | type                     | Troparion                |
         | tone                     | 4                        |
         | prosomeion_title         | Тропарёв текст           |
         | text                     | Тропарёв ин текст.       |
         | language_code            | ру                       |
         | service_chants.service   | *Анании Бобкову служба   |
      И будет создана модель кондака с аттрибутами:
         | type                     | Kontakion                |
         | tone                     | 1                        |
         | text                     | Кондаков иной текст      |
         | language_code            | ру                       |
         | service_chants.service   | *Анании Бобкову служба   |
      И будет создана модель величания с аттрибутами:
         | text                           | Величание                |
         | language_code                  | ру                       |
         | service_magnifications.service | *Анании Бобкову служба   |
