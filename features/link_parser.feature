# language: ru
Функционал: Обработчик ссылки
   Сценарий: Простая ссылка
      Допустим есть строка ссылки:
         """
         http://recource.ru
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :url: http://recource.ru
         """


   Сценарий: Ссылка с описанием
      Допустим есть строка ссылки:
         """
         http://recource.ru [Описание]
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :url: http://recource.ru
           :description:
             :language_code: :ру
             :text: Описание
         """


   Сценарий: Описание на разных возможных языках
      Допустим есть строки ссылки:
         """
         ру: http://recource.ru
         цс: http://recource.cs
         гр: http://recource.gr
         ив: http://recource.iv
         ср: http://recource.sr
         ан: http://recource.uk
         ла: http://recource.com
         чх: http://recource.cz
         ир: http://recource.ir
         си: http://recource.ir
         бг: http://recource.bg
         ит: http://recource.it
         ар: http://recource.ar
         рм: http://recource.ro
         са: http://recource.uk
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :language_code: :ру
           :url: http://recource.ru
         - :language_code: :цс
           :url: http://recource.cs
         - :language_code: :гр
           :url: http://recource.gr
         - :language_code: :ив
           :url: http://recource.iv
         - :language_code: :ср
           :url: http://recource.sr
         - :language_code: :ан
           :url: http://recource.uk
         - :language_code: :ла
           :url: http://recource.com
         - :language_code: :чх
           :url: http://recource.cz
         - :language_code: :ир
           :url: http://recource.ir
         - :language_code: :си
           :url: http://recource.ir
         - :language_code: :бг
           :url: http://recource.bg
         - :language_code: :ит
           :url: http://recource.it
         - :language_code: :ар
           :url: http://recource.ar
         - :language_code: :рм
           :url: http://recource.ro
         - :language_code: :са
           :url: http://recource.uk
         """

   Сценарий: Неверный язык указан
      Допустим есть строки ссылки:
         """
         кк: http://recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного языка"


   Сценарий: Указаны неверные символы в языке
      Допустим есть строки ссылки:
         """
         ру: http://recource.ru [то у Валентина, Сергија]
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверной буквы языка"

   Сценарий: Неверный формат ссылки указан
      Допустим есть строки ссылки:
         """
         ру: httr://recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"

      Если есть строки ссылки:
         """
         ру: file:///recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"

      Если есть строки ссылки:
         """
         ру: httpe/r/recource.ruw
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"
