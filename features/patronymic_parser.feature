# language: ru
Функционал: Обработчик отчества
   Сценарий: Простое одинарное отчество
      Допустим есть строка отчества:
         """
         Ананьевич
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :text: Ананьевич
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Ананьевич
           :state: :отчество
         """

   Сценарий: Несколько отчеств
      Допустим есть строка отчества:
         """
         Алексеевич, Валентинович
         """
      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :text: Алексеевич
         - :language_code: :ру
           :text: Валентинович
         """
      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексеевич
           :state: :отчество
         - :name:
             :language_code: :ру
             :text: Валентинович
           :state: :отчество
         """

   Сценарий: Возможное отчество
      Допустим есть строка отчества:
         """
         вид.Алексеевич
         """
      То обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Алексеевич
           :feasibly: :feasible
           :state: :отчество
         """

   Сценарий: Альтернативные отчества
      Допустим есть строка отчества:
         """
         Иувенальевич/Алексеевич, Феофанович
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :text: Иувенальевич
         - :language_code: :ру
           :text: Алексеевич
         - :language_code: :ру
           :text: Феофанович
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Иувенальевич
           :state: :отчество
           :mode: :ored
         - :name:
             :language_code: :ру
             :text: Алексеевич
           :state: :отчество
         - :name:
             :language_code: :ру
             :text: Феофанович
           :state: :отчество
         """

   Сценарий: Разноязычные отчества
      Допустим есть строки отчества:
         """
         ру: Александрович
         гр: Αλεξάνδροβιτς
         """

      То обработанные данные имени будут выглядеть как:
         """
         ---
         - &1
           :language_code: :ру
           :text: Александрович
         - :language_code: :гр
           :text: Αλεξάνδροβιτς
           :similar_to: *1
         """

      А обработанные данные памятного имени будут выглядеть как:
         """
         ---
         - :name:
             :language_code: :ру
             :text: Александрович
           :state: :отчество
         """

   Сценарий: Ошибочно-разное количество слов отчеств в разных языках
      Допустим есть строки отчества:
         """
         ру: Валентинович, Алексеевич,
         гр: ', Αλεξάνδροβιτς'
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка индекса"

   Сценарий: Неверный язык указан
      Допустим есть строки отчества:
         """
         кк: Валентин
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверного языка"

   Сценарий: Указаны неверные символы в языке
      Допустим есть строки отчества:
         """
         ру: Валентинович, Сергијевич
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверной буквы языка"

   Сценарий: Ошибочное отчество по префиксу
      Допустим есть строки отчества:
         """
         Алексеевич/, Александрович
         """
      То обработанных данных имени не будет
      И в списке ошибок будет "ошибка неверного перечислителя"
