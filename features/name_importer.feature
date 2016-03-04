# language: ru
Функционал: Импортёр имени
   Сценарий: Простое одинарное имя
      Допустим есть обработанные данные имени:
         """
         ---
           :language_code: :ру
           :text: Анания
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Анания    |
         | language_code   | :ру       |

   Сценарий: Несколько едноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - :language_code: :ру
           :text: Алексей
         - :language_code: :ру
           :text: Валентин
         - :language_code: :ру
           :text: Сергий
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Алексей     | :language_code: :ру   |
         | :text: Валентин    | :language_code: :ру   |
         | :text: Сергий      | :language_code: :ру   |

   Сценарий: Едноязычные имена со ссылкою
      Допустим есть обработанные данные имени:
         """
         ---
         - :language_code: :ру
           :text: Иувеналий
         - :language_code: :ру
           :text: Алексий
         - &1
           :language_code: :ру
           :text: Феофан
         - :language_code: :ру
           :text: Феофаний
           :similar_to: *1
         - :language_code: :ру
           :text: Иван
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Иувеналий   | :language_code: :ру   |                       |
         | :text: Алексий     | :language_code: :ру   |                       |
         | :text: Феофан      | :language_code: :ру   |                       |
         | :text: Феофаний    | :language_code: :ру   | :similar_to: Феофан   |
         | :text: Иван        | :language_code: :ру   |                       |


   Сценарий: Набор разноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - &3
           :language_code: :ру
           :text: Валентин
         - &2
           :language_code: :ру
           :text: Алексей
         - &1
           :language_code: :ру
           :text: Валерий
         - :language_code: :ру
           :text: Валера
           :similar_to: *1
         - &4
           :language_code: :ру
           :text: Валерик
           :similar_to: *1
         - :language_code: :ру
           :text: Зема
         - :language_code: :гр
           :text: Αλέξιος
           :similar_to: *2
         - &5
           :language_code: :ср
           :text: Сергије
         - :language_code: :ан
           :text: Valentin
           :similar_to: *3
         - :language_code: :ан
           :text: Sergius
           :similar_to: *5
         - :language_code: :ан
           :text: Valery
           :similar_to: *1
         - :language_code: :ан
           :text: Valerick
           :similar_to: *4
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Валентин | :language_code: :ру   |                       |
         | :text: Алексей  | :language_code: :ру   |                       |
         | :text: Валерий  | :language_code: :ру   |                       |
         | :text: Валера   | :language_code: :ру   | :similar_to: Валерий  |
         | :text: Валерик  | :language_code: :ру   | :similar_to: Валерий  |
         | :text: Зема     | :language_code: :ру   |                       |
         | :text: Αλέξιος  | :language_code: :гр   | :similar_to: Алексей  |
         | :text: Сергије  | :language_code: :ср   |                       |
         | :text: Valentin | :language_code: :ан   | :similar_to: Валентин |
         | :text: Sergius  | :language_code: :ан   | :similar_to: Сергије  |
         | :text: Valery   | :language_code: :ан   | :similar_to: Валерий  |
         | :text: Valerick | :language_code: :ан   | :similar_to: Валерик  |

   Сценарий: Одинарное имя с пробелом
      Допустим есть обработанные данные имени:
         """
         ---
           :language_code: :ру
           :text: Око Времени‑Завета
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Око Времени‑Завета |
         | language_code   | :ру                |
