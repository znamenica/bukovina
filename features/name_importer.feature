# language: ru
Функционал: Импортёр имени
   Сценарий: Простое одинарное имя
      Допустим есть обработанные данные имени:
         """
         ---
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Анания
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Анания |
         | alphabeth_code  | ру     |
         | language_code   | ру     |

   Сценарий: Несколько едноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Валентин
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Сергий
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Алексей     | :alphabeth_code: :ру  | :language_code: :ру   |
         | :text: Валентин    | :alphabeth_code: :ру  | :language_code: :ру   |
         | :text: Сергий      | :alphabeth_code: :ру  | :language_code: :ру   |

   Сценарий: Едноязычные имена со ссылкою
      Допустим есть обработанные данные имени:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Иувеналий
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексий
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Феофан
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Феофаний
           :bind_kind: подобное
           :bond_to: *1
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Иван
         """

      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Иувеналий   | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Алексий     | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Феофан      | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Феофаний    | :alphabeth_code: :ру  | :language_code: :ру   | :bond_to: Феофан   |
         | :text: Иван        | :alphabeth_code: :ру  | :language_code: :ру   |                       |


   Сценарий: Набор разноязычных имён
      Допустим есть обработанные данные имени:
         """
         ---
         - &3
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валентин
         - &2
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валерий
         - &5
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валерик
           :bind_kind: подобное
           :bond_to: *1
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Валера
           :bind_kind: подобное
           :bond_to: *1
         - :alphabeth_code: :ру
           :language_code: :ру
           :bind_kind: прилаженое
           :text: Зема
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :bind_kind: прилаженое
           :bond_to: *2
         - &4
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Сергије
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valentin
           :bind_kind: прилаженое
           :bond_to: *3
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Sergius
           :bind_kind: прилаженое
           :bond_to: *4
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valery
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Valerick
           :bind_kind: прилаженое
           :bond_to: *5
         """


      Если импортируем их
      То будут созданы модели имени с аттрибутами:
         | :text: Валентин | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Алексей  | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Валерий  | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Валера   | :alphabeth_code: :ру  | :language_code: :ру   | :bond_to: Валерий  |
         | :text: Валерик  | :alphabeth_code: :ру  | :language_code: :ру   | :bond_to: Валерий  |
         | :text: Зема     | :alphabeth_code: :ру  | :language_code: :ру   |                       |
         | :text: Αλέξιος  | :alphabeth_code: :гр  | :language_code: :гр   | :bond_to: Алексей  |
         | :text: Сергије  | :alphabeth_code: :ср  | :language_code: :сх   |                       |
         | :text: Valentin | :alphabeth_code: :ан  | :language_code: :ан   | :bond_to: Валентин |
         | :text: Sergius  | :alphabeth_code: :ан  | :language_code: :ан   | :bond_to: Сергије  |
         | :text: Valery   | :alphabeth_code: :ан  | :language_code: :ан   | :bond_to: Валерий  |
         | :text: Valerick | :alphabeth_code: :ан  | :language_code: :ан   | :bond_to: Валерик  |


   Сценарий: Одинарное имя с пробелом
      Допустим есть обработанные данные имени:
         """
         ---
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Око Времени‑Завета
         """

      Если импортируем их
      То будет создана модель имени с аттрибутами:
         | text            | Око Времени‑Завета |
         | alphabeth_code  | ру                 |
         | language_code   | ру                 |
