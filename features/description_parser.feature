# language: ru
Функционал: Обработчик имени
   Сценарий: Простое описание
      Допустим есть строка описания:
         """
         описание
         """
      То обработанные данные описания будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: описание
         """


   Сценарий: Сложное описание
      Допустим есть строка описания:
         """
         '"апостол" от 70-ти; описание на Сергий‑Вася, и ещё (Володю-Володимера): с сокр.Вову-''Сашу/Александра?'
         """
      То обработанные данные описания будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: '"апостол" от 70-ти; описание на Сергий‑Вася, и ещё (Володю-Володимера):
             с сокр.Вову-''Сашу/Александра?'
         """


   Сценарий: Описание на разных возможных языках
      Допустим есть строки описания:
         """
         рп: вотъ Нина
         ру: вот Нина
         цс: се Нина
         гр: Νίνα
         ив: ნინმ
         ср: се Нина
         ан: this Nina
         ла: this Nina
         чх: this Nina
         ир: this Nina
         си: this Nina
         бг: се Нина
         ит: this Nina
         ар: Նունէ
         рм: this Nina
         са: this Nina
         """
      То обработанные данные описания будут выглядеть как:
         """
         ---
         - :alphabeth_code: :рп
           :language_code: :ру
           :text: вотъ Нина
         - :alphabeth_code: :ру
           :language_code: :ру
           :text: вот Нина
         - :alphabeth_code: :цс
           :language_code: :цс
           :text: се Нина
         - :alphabeth_code: :гр
           :language_code: :гр
           :text: Νίνα
         - :alphabeth_code: :ив
           :language_code: :ив
           :text: ნინმ
         - :alphabeth_code: :ср
           :language_code: :сх
           :text: се Нина
         - :alphabeth_code: :ан
           :language_code: :ан
           :text: this Nina
         - :alphabeth_code: :ла
           :language_code: :ла
           :text: this Nina
         - :alphabeth_code: :чх
           :language_code: :чх
           :text: this Nina
         - :alphabeth_code: :ир
           :language_code: :ир
           :text: this Nina
         - :alphabeth_code: :си
           :language_code: :си
           :text: this Nina
         - :alphabeth_code: :бг
           :language_code: :бг
           :text: се Нина
         - :alphabeth_code: :ит
           :language_code: :ит
           :text: this Nina
         - :alphabeth_code: :ар
           :language_code: :ар
           :text: Նունէ
         - :alphabeth_code: :рм
           :language_code: :рм
           :text: this Nina
         - :alphabeth_code: :са
           :language_code: :ан
           :text: this Nina
         """

   Сценарий: Неверный язык указан
      Допустим есть строки описания:
         """
         кк: то Валентин
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного языка"


   Сценарий: Указаны неверные символы в языке
      Допустим есть строки описания:
         """
         ру: то у Валентина, Сергија
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверной буквы языка"
