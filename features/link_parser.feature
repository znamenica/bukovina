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
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://recource.ru
         """


   Сценарий: Иноязычная ссылка
      Допустим есть строка ссылки:
         """
         https://ru.wikipedia.org/wiki/София_Слуцкая
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: https://ru.wikipedia.org/wiki/София_Слуцкая
         """


   Сценарий: Сложная ссылка
      Допустим есть строка ссылки:
         """
         http://tvereparhia.ru/publikaczii/voprosy-k-pravoslavnym/7864-evgenij-poselyanin-russkie-podvizhniki-19-veka#СВЯЩЕННИК ПЕТР (ГОРОДА УГЛИЧА)
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://tvereparhia.ru/publikaczii/voprosy-k-pravoslavnym/7864-evgenij-poselyanin-russkie-podvizhniki-19-veka#СВЯЩЕННИК
             ПЕТР (ГОРОДА УГЛИЧА)
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
         не: http://recource.de
         ук: http://recource.ua
         """
      То обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://recource.ru
         - :alphabeth_code: :цс
           :language_code: :цс
           :url: http://recource.cs
         - :alphabeth_code: :гр
           :language_code: :гр
           :url: http://recource.gr
         - :alphabeth_code: :ив
           :language_code: :ив
           :url: http://recource.iv
         - :alphabeth_code: :ср
           :language_code: :сх
           :url: http://recource.sr
         - :alphabeth_code: :ан
           :language_code: :ан
           :url: http://recource.uk
         - :alphabeth_code: :ла
           :language_code: :ла
           :url: http://recource.com
         - :alphabeth_code: :чх
           :language_code: :чх
           :url: http://recource.cz
         - :alphabeth_code: :ир
           :language_code: :ир
           :url: http://recource.ir
         - :alphabeth_code: :си
           :language_code: :си
           :url: http://recource.ir
         - :alphabeth_code: :бг
           :language_code: :бг
           :url: http://recource.bg
         - :alphabeth_code: :ит
           :language_code: :ит
           :url: http://recource.it
         - :alphabeth_code: :ар
           :language_code: :ар
           :url: http://recource.ar
         - :alphabeth_code: :рм
           :language_code: :рм
           :url: http://recource.ro
         - :alphabeth_code: :са
           :language_code: :ан
           :url: http://recource.uk
         - :alphabeth_code: :не
           :language_code: :не
           :url: http://recource.de
         - :alphabeth_code: :ук
           :language_code: :ук
           :url: http://recource.ua
         """

   Сценарий: Неверный язык указан
      Допустим есть строки ссылки:
         """
         кк: http://recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного языка"


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
