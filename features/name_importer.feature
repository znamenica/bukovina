# language: ru
Функционал: Импортёр имени
   Сценарий: Простое одинарное имя
      Допустим есть обработанные данные имени:
         """
         ---
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Анания
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Анания |
         | alphabeth_code  | ро     |
         | language_code   | ру     |

   Сценарий: Несколько едноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Валентин
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Сергий
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Алексей     | :alphabeth_code: :ро  | :language_code: :ру   |
         | :text: Валентин    | :alphabeth_code: :ро  | :language_code: :ру   |
         | :text: Сергий      | :alphabeth_code: :ро  | :language_code: :ру   |

   Сценарий: Едноязычные имена со ссылкою
      Допустим есть обработанные данные имени:
         """
         ---
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Иувеналий
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Алексий
         - &1
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Феофан
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Феофаний
           :similar_to: *1
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Иван
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Иувеналий   | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Алексий     | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Феофан      | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Феофаний    | :alphabeth_code: :ро  | :language_code: :ру   | :similar_to: Феофан   |
         | :text: Иван        | :alphabeth_code: :ро  | :language_code: :ру   |                       |


   Сценарий: Набор разноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - &3
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Валентин
         - &2
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Алексей
         - &1
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Валерий
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Валера
           :similar_to: *1
         - &4
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Валерик
           :similar_to: *1
         - :alphabeth_code: :ро
           :language_code: :ру
           :text: Зема
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :similar_to: *2
         - &5
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Сергије
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valentin
           :similar_to: *3
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Sergius
           :similar_to: *5
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valery
           :similar_to: *1
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valerick
           :similar_to: *4
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Валентин | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Алексей  | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Валерий  | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Валера   | :alphabeth_code: :ро  | :language_code: :ру   | :similar_to: Валерий  |
         | :text: Валерик  | :alphabeth_code: :ро  | :language_code: :ру   | :similar_to: Валерий  |
         | :text: Зема     | :alphabeth_code: :ро  | :language_code: :ру   |                       |
         | :text: Αλέξιος  | :alphabeth_code: :гр  | :language_code: :гр   | :similar_to: Алексей  |
         | :text: Сергије  | :alphabeth_code: :ср  | :language_code: :сх   |                       |
         | :text: Valentin | :alphabeth_code: :ан  | :language_code: :ан   | :similar_to: Валентин |
         | :text: Sergius  | :alphabeth_code: :ан  | :language_code: :ан   | :similar_to: Сергије  |
         | :text: Valery   | :alphabeth_code: :ан  | :language_code: :ан   | :similar_to: Валерий  |
         | :text: Valerick | :alphabeth_code: :ан  | :language_code: :ан   | :similar_to: Валерик  |


   Сценарий: Одинарное имя с пробелом
      Допустим есть обработанные данные имени:
         """
         ---
           :alphabeth_code: :ро
           :language_code: :ру
           :text: Око Времени‑Завета
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Око Времени‑Завета |
         | alphabeth_code  | ро                 |
         | language_code   | ру                 |
