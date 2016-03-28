# language: ru
Функционал: Импортёр службы
   Сценарий: Простая служба
      Допустим есть память "Анания Бобков"
      И есть обработанные данные службы:
         """
         ---
         - :language_code: :ру
           :name: Анании Бобкову служба
           :chants:
           - :language_code: :ру
             :type: Troparion
             :prosomeion_title: Тропарёв текст
             :text: Тропарёв ин текст.
             :tone: 4
           :memory:
             :short_name: Анания Бобков
         """

      Если импортируем их
      То будет создана модель службы с аттрибутами:
         | language_code      | ру                    |
         | name               | Анании Бобкову служба |
      И будет создана модель тропаря с аттрибутами:
         | type               | Troparion             |
         | tone               | 4                     |
         | prosomeion_title   | Тропарёв текст        |
         | text               | Тропарёв ин текст.    |
         | language_code      | ру                    |

      А модель службы с аттрибутами будет относиться к памяти "Анания Бобков":
         | language_code      | ру                    |
         | name               | Анании Бобкову служба |
      И модель тропаря с аттрибутами будет относиться к службе "Анании Бобкову служба":
         | prosomeion_title   | Тропарёв текст        |
         | text               | Тропарёв ин текст.    |
