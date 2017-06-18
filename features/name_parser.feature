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
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Анания
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
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
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валентин
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Сергий‑Вася
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
         - :name:
             :type: FirstName
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
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
         """


   Сценарий: Альтернативные имена
      Допустим есть строка имени:
         """
         в иночестве Иувеналий/Алексий, в схиме Феофан (Феофаний), в крещении Иван
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Иувеналий
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексий
         - &1
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Феофан
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Феофаний
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Иван
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Иувеналий
           :state: :иноческое
           :mode: :ored
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексий
           :state: :иноческое
        - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Феофан
           :state: :схимное
         - :name:
             :type: FirstName
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
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :state: :наречёное
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Василий
           :state: :чернецкое
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Сергий
           :state: :иноческое
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Виктор
           :state: :схимное
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Иона
           :state: :благословенное
         - :name:
             :type: FirstName
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
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
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
             :type: FirstName
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
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :mode: :ored
         - :name:
             :type: FirstName
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
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :mode: :prefix
         - :name:
             :type: FirstName
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
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алеша
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Лёха
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Вало
         - :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранко
           :similar_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
           :state: :наречёное
         - :name:
             :type: FirstName
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
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - &2
           :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранко
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Бранок
           :similar_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
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
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Сергей
         - &1
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Sergei
           :similar_to: *2
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Alexey
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Срђан
           :similar_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Сергей
           :feasibly: :feasible
           :state: :наречёное
           :mode: :ored
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
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
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валентин
         - &2
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Алексей
         - &1
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валерий
         - &5
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валерик
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Валера
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Зема
         - :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Αλέξιος
           :similar_to: *2
         - &4
           :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Сергије
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Valentin
           :similar_to: *3
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Sergius
           :similar_to: *4
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Valery
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Valerick
           :similar_to: *5
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Алексей
         - :name:
             :type: FirstName
             :alphabeth_code: :ср
             :language_code: :сх
             :text: Сергије
         - :name:
             :type: FirstName
             :alphabeth_code: :ру
             :language_code: :ру
             :text: Валерий
           :state: :наречёное
         - :name:
             :type: FirstName
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
           :type: FirstName
           :alphabeth_code: :ру
           :language_code: :ру
           :text: Нина
         - :type: FirstName
           :alphabeth_code: :цс
           :language_code: :цс
           :text: Нина
           :similar_to: *1
         - &2
           :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Νίνα
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :гр
           :language_code: :гр
           :text: Νίνω
           :similar_to: *2
         - &3
           :type: FirstName
           :alphabeth_code: :ив
           :language_code: :ив
           :text: ნინმ
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ив
           :language_code: :ив
           :text: ნინო
           :similar_to: *3
         - :type: FirstName
           :alphabeth_code: :ср
           :language_code: :сх
           :text: Нина
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ан
           :language_code: :ан
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ла
           :language_code: :ла
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :чх
           :language_code: :чх
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ир
           :language_code: :ир
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :си
           :language_code: :си
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :бг
           :language_code: :бг
           :text: Нина
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ит
           :language_code: :ит
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :ар
           :language_code: :ар
           :text: Նունէ
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :рм
           :language_code: :рм
           :text: Nina
           :similar_to: *1
         - :type: FirstName
           :alphabeth_code: :са
           :language_code: :ан
           :text: Nina
           :similar_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :type: FirstName
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
         - :type: FirstName
           :alphabeth_code: :ру
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
