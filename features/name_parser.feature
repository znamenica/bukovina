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
         - :language_code: :ру
           :text: Анания
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Анания
         """

   Сценарий: Несколько имён
      Допустим есть строка имени:
         """
         Алексей, Валентин, Сергий
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :text: Алексей
         - :language_code: :ру
           :text: Валентин
         - :language_code: :ру
           :text: Сергий
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексей
         - :name:
             :language_code: :ру
             :text: Валентин
         - :name:
             :language_code: :ру
             :text: Сергий
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

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Иувеналий
           :state: :иноческое
           :mode: :ored
         - :name:
             :language_code: :ру
             :text: Алексий
           :state: :иноческое
        - :name:
             :language_code: :ру
             :text: Феофан
           :state: :схимное
         - :name:
             :language_code: :ру
             :text: Иван
           :state: :крещенское
         """

   Сценарий: Имена, наречённое в событии
      Допустим есть строка имени:
         """
         в наречении Алексей, в крещении Валентин, в чернестве Василий,
         в иночестве Сергий, в схиме Виктор
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексей
           :state: :наречёное
         - :name:
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :language_code: :ру
             :text: Василий
           :state: :чернецкое
         - :name:
             :language_code: :ру
             :text: Сергий
           :state: :иноческое
         - :name:
             :language_code: :ру
             :text: Виктор
           :state: :схимное
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
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
           :state: :наречёное
         """

   Сценарий: Неточное имя, из двух выбираемое
      Допустим есть строка имени:
         """
         Алексей/Александр
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :text: Алексей
         - :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексей
           :mode: :ored
         - :name:
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
         - :language_code: :ру
           :text: Алексей
         - :language_code: :ру
           :text: Александр
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексей
           :mode: :prefix
         - :name:
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
           :language_code: :ру
           :text: Алексей
         - :language_code: :ру
           :text: Алеша
           :similar_to: *1
         - :language_code: :ру
           :text: Лёха
           :similar_to: *1
         - :language_code: :ру
           :text: Вало
         - :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - :language_code: :ср
           :text: Бранко
           :similar_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексей
           :feasibly: :feasible
           :state: :наречёное
         - :name:
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
           :language_code: :ру
           :text: Алексей
         - :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - &2
           :language_code: :ср
           :text: Бранко
           :similar_to: *1
         - :language_code: :ср
           :text: Бранок
           :similar_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
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
           :language_code: :ру
           :text: Сергей
         - &1
           :language_code: :ру
           :text: Алексей
         - :language_code: :гр
           :text: Αλέξιος
           :similar_to: *1
         - :language_code: :ан
           :text: Sergei
           :similar_to: *2
         - :language_code: :ан
           :text: Alexey
           :similar_to: *1
         - :language_code: :ср
           :text: Срђан
           :similar_to: *2
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Сергей
           :feasibly: :feasible
           :state: :наречёное
           :mode: :ored
         - :name:
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
           :language_code: :ру
           :text: Валентин
         - &2
           :language_code: :ру
           :text: Алексей
         - &1
           :language_code: :ру
           :text: Валерий
         - &5
           :language_code: :ру
           :text: Валерик
           :similar_to: *1
         - :language_code: :ру
           :text: Валера
           :similar_to: *1
         - :language_code: :ру
           :text: Зема
         - :language_code: :гр
           :text: Αλέξιος
           :similar_to: *2
         - &4
           :language_code: :ср
           :text: Сергије
         - :language_code: :ан
           :text: Valentin
           :similar_to: *3
         - :language_code: :ан
           :text: Sergius
           :similar_to: *4
         - :language_code: :ан
           :text: Valery
           :similar_to: *1
         - :language_code: :ан
           :text: Valerick
           :similar_to: *5
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Валентин
           :state: :крещенское
         - :name:
             :language_code: :ру
             :text: Алексей
         - :name:
             :language_code: :ср
             :text: Сергије
         - :name:
             :language_code: :ру
             :text: Валерий
           :state: :наречёное
         - :name:
             :language_code: :ру
             :text: Зема
         """

   Сценарий: Ошибочно-разное количество слов имён в разных языках
      Допустим есть строки имени:
         """
         ру: Валентин, Алексей,
         гр: ', Αλέξιος'
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка индекса"

   Сценарий: Неверный язык указан
      Допустим есть строки имени:
         """
         кк: Валентин
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверного языка"

   Сценарий: Указаны неверные символы в языке
      Допустим есть строки имени:
         """
         ру: Валентин, Сергије
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверной буквы языка"

   Сценарий: Ошибочное имя по префиксу
      Допустим есть строка имени:
         """
         Алексей/, Александр
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверного перечислителя"

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
           :language_code: :ру
           :text: Нина
         - :language_code: :цс
           :text: Нина
           :similar_to: *1
         - &2
           :language_code: :гр
           :text: Νίνα
           :similar_to: *1
         - :language_code: :гр
           :text: Νίνω
           :similar_to: *2
         - &3
           :language_code: :ив
           :text: ნინმ
           :similar_to: *1
         - :language_code: :ив
           :text: ნინო
           :similar_to: *3
         - :language_code: :ср
           :text: Нина
           :similar_to: *1
         - :language_code: :ан
           :text: Nina
           :similar_to: *1
         - :language_code: :ла
           :text: Nina
           :similar_to: *1
         - :language_code: :чх
           :text: Nina
           :similar_to: *1
         - :language_code: :ир
           :text: Nina
           :similar_to: *1
         - :language_code: :си
           :text: Nina
           :similar_to: *1
         - :language_code: :бг
           :text: Нина
           :similar_to: *1
         - :language_code: :ит
           :text: Nina
           :similar_to: *1
         - :language_code: :ар
           :text: Նունէ
           :similar_to: *1
         - :language_code: :рм
           :text: Nina
           :similar_to: *1
         - :language_code: :са
           :text: Nina
           :similar_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Нина
         """
