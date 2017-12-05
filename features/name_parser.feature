# language: ru
Функционал: Обработчик имени
   Сценарий: Простое одинарное имя
      Допустим есть строка имени:
         """
         Анания
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Анания
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Анания
         """


   Сценарий: Несколько имён
      Допустим есть строка имени:
         """
         Алексей, Валентин, Сергий‑Вася
         """
      То обработанные данные имени будут выглядеть как:
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
           :text: Сергий‑Вася
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Сергий‑Вася
         """


   Сценарий: Возможное имя
      Допустим есть строка имени:
         """
         вид.Алексей
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasible: true
         """


   Сценарий: Альтернативные имена
      Допустим есть строка имени:
         """
         в иночестве Иувеналий/Алексий, в схиме Феофан (Феофаний), в крещении Иван
         """

      То обработанные данные имени будут выглядеть как:
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

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Иувеналий
           :state: :иноческое
           :mode: :ored
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексий
           :state: :иноческое
        - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Феофан
           :state: :схимное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Иван
           :state: :крещенское
         """


   Сценарий: Имена, наречённое в событии
      Допустим есть строка имени:
         """
         в наречении Алексей, в крещении Валентин, в чернестве Василий,
         в иночестве Сергий, в схиме Виктор, в благословении Иона, в покаянии
         Мирон
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :state: :наречёное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Василий
           :state: :чернецкое
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Сергий
           :state: :иноческое
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Виктор
           :state: :схимное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Иона
           :state: :благословенное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Мирон
           :state: :покаянное
         """


   Сценарий: Возможное имя, наречённое в событии
      Допустим есть строка имени:
         """
         вид.в наречении Алексей
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasible: true
           :state: :наречёное
         """


   Сценарий: Самовзятое имя
      Допустим есть строка имени:
         """
         в самонаречении Алексей
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :state: :самоданное
         """


   Сценарий: Неточное имя, из двух выбираемое
      Допустим есть строка имени:
         """
         Алексей/Александр
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :mode: :ored
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Александр
         """


   Сценарий: Сдвоенное имя
      Допустим есть строка имени:
         """
         Алексей-Александр
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :mode: :prefix
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Александр
         """


   Сценарий: Разноязычное имя
      Допустим есть строки имени:
         """
         ру: вид.в наречении Алексей (Алеша, Лёха), Вало
         гр: Αλέξιος,
         ср: Бранко,
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Алеша
           :bind_kind: подобное
           :bond_to: *1
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Лёха
           :bind_kind: подобное
           :bond_to: *1
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Вало
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранко
           :bind_kind: прилаженое
           :bond_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasible: true
           :state: :наречёное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Вало
         """


   Сценарий: Разноязычное имя со ссылками
      Допустим есть строки имени:
         """
         ру: вид.в наречении Алексей
         гр: Αλέξιος
         ср: Бранко (Бранок)
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :bind_kind: прилаженое
           :bond_to: *1
         - &2
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранко
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранок
           :bind_kind: подобное
           :bond_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasible: true
           :state: :наречёное
         """


   Сценарий: Разноязычное вариантное
      Допустим есть строки имени:
         """
         ру: вид.в наречении Сергей/Алексей
         гр: '/Αλέξιος'
         ан: Sergei/Alexey
         ср: Срђан/
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - &2
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Сергей
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Sergei
           :bind_kind: прилаженое
           :bond_to: *2
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Alexey
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ср
           :language_code: :сх
           :text: Срђан
           :bind_kind: прилаженое
           :bond_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Сергей
           :feasible: true
           :state: :наречёное
           :mode: :ored
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasible: true
           :state: :наречёное
         """


   Сценарий: Набор разноязычных имён
      Допустим есть строки имени:
         """
         ру: в крещении Валентин, Алексей, , в наречении Валерий (Валерик, Валера), Зема
         гр: ', Αλέξιος,,,'
         ср: ',,Сергије,,'
         ан: 'Valentin, , Sergius, Valery(Valerick),'
         """

      То обработанные данные имени будут выглядеть как:
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

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
         - :name:
             :alphabeth_code: :ср
             :language_code: :сх
             :text: Сергије
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валерий
           :state: :наречёное
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Зема
         """


   Сценарий: Имя на разных возможных языках
      Допустим есть строка имени:
         """
         ру: Нина
         цс: Нина
         гр: Νίνα (Νίνω)
         ив: 'ნინმ (ნინო)'
         ср: Нина
         ан: Nina
         ла: Nina
         чх: Nina
         ир: Nina
         си: Nina
         бг: Нина
         ит: Nina
         ар: Նունէ
         рм: Nina
         са: Nina
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - &1
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Нина
         - :alphabeth_code: :цс
           :language_code: :цс
           :text: Нина
           :bind_kind: прилаженое
           :bond_to: *1
         - &2
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Νίνα
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Νίνω
           :bind_kind: подобное
           :bond_to: *2
         - &3
           :alphabeth_code: :ив
           :language_code: :ив
           :text: ნინმ
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ив
           :language_code: :ив
           :text: ნინო
           :bind_kind: подобное
           :bond_to: *3
         - :alphabeth_code: :ср
           :language_code: :сх
           :text: Нина
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ла
           :language_code: :ла
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :чх
           :language_code: :чх
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ир
           :language_code: :ир
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :си
           :language_code: :си
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :бг
           :language_code: :бг
           :text: Нина
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ит
           :language_code: :ит
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :ар
           :language_code: :ар
           :text: Նունէ
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :рм
           :language_code: :рм
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         - :alphabeth_code: :са
           :language_code: :ан
           :text: Nina
           :bind_kind: прилаженое
           :bond_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Нина
         """


   Сценарий: Сложносоставное имя
      Допустим есть строка имени:
         """
         ру: Сложное имя
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: Сложное имя
         """


   Сценарий: Ошибочно-разное количество слов имён в разных языках
      Допустим есть строки имени:
         """
         ру: Валентин, Алексей,
         гр: ', Αλέξιος'
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "индекса"


   Сценарий: Неверный язык указан
      Допустим есть строки имени:
         """
         кк: Валентин
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного языка"


   Сценарий: Указаны неверные символы в языке
      Допустим есть строки имени:
         """
         ру: Валентин, Сергије
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверной буквы языка"


   Сценарий: Ошибочное имя по префиксу
      Допустим есть строка имени:
         """
         Алексей/, Александр
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного перечислителя"


   Сценарий: Ошибочное правописание в строке имени
      Допустим есть строки имени:
         """
         вид.ошибка Валентин, в наречении вот ещё Алексей, уу
         """
      То обработанных данных не будет
      И в списке ошибок будет 3 ошибки "ложного правописания"
