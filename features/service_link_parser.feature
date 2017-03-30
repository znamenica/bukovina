# language: ru
Функционал: Обработчик служебной ссылки и службы
   Сценарий: Простая служебная ссылка
      Допустим есть строка служебной ссылки:
         """
         http://recource.ru
         """
      То обработанных данных службы не будет
      А обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://recource.ru
         """


   Сценарий: Несколько ссылок
      Допустим есть строка служебной ссылки:
         """
          - http://recource.gr
          - 'http://www.porphyrios.gr/files/jpg/Εικόνες/Συλλογή με κατάταξη/Απόστολοι/Βαρθολομαίος Απόστολος 02.jpg'
         """
      То обработанных данных службы не будет
      А обработанные данные ссылки будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://recource.gr
         - :alphabeth_code: :ру
           :language_code: :ру
           :url: http://www.porphyrios.gr/files/jpg/Εικόνες/Συλλογή με κατάταξη/Απόστολοι/Βαρθολομαίος
             Απόστολος 02.jpg
         """


   Сценарий: Ссылка на местную службу с тропарём
      Допустим есть местный файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         вечерня:
            отпустительно:
               тропарь:
                  глас: 4
                  текст: Тропарёв текст
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Troparion
             :tone: 4
             :text: Тропарёв текст
         """


   Сценарий: Ссылка на местную службу со ссылкою на тропарь
      Допустим есть местный файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         вечерня:
            отпустительно:
               тропарь:
                  ссылка: Тропарёв текст
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Troparion
             :ref_title: Тропарёв текст
         """


   Сценарий: Ссылка на местную вечернюю службу
      Допустим есть память "Мария Богородица"
      И есть местный украинский файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         вечерня:
            возвашна:
               глас: 4
               текст: Кондака текст
            отпустительно:
               молитва:
                - Молитва перва
                - Молитва друга
               богородичен:
                  глас: 1
                  текст: Богородична текст
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ук
           :language_code: :ук
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ук
             :language_code: :ук
             :targets:
             - "*Василий Васильский"
             :type: CryStichira
             :tone: 4
             :text: Кондака текст
           - :alphabeth_code: :ук
             :language_code: :ук
             :targets:
             - "*Василий Васильский"
             :type: Prayer
             :text: Молитва перва
           - :alphabeth_code: :ук
             :language_code: :ук
             :targets:
             - "*Василий Васильский"
             :type: Prayer
             :text: Молитва друга
           - :alphabeth_code: :ук
             :language_code: :ук
             :targets:
             - "*Мария Богородица"
             :type: Troparion
             :tone: 1
             :text: Богородична текст
         """


   Сценарий: Ссылка на местную службу с каноном
      Допустим есть местный румынский файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         утреня:
            канон:
               седален:
                - глас: 1
                  крат: Sedalions primul
                  текст: Sedalions primul textului
                - глас: 2
                  подобен: Sedalions primul
                  текст: Sedalions a doua textului
               кондак:
                  глас: 4
                  текст: Condacul textului
               икос: Icosul textului
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :рм
           :language_code: :рм
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :рм
             :language_code: :рм
             :targets:
             - "*Василий Васильский"
             :type: Kanonion
             :tone: 1
             :title: Sedalions primul
             :text: Sedalions primul textului
           - :alphabeth_code: :рм
             :language_code: :рм
             :targets:
             - "*Василий Васильский"
             :type: Kanonion
             :tone: 2
             :prosomeion_title: Sedalions primul
             :text: Sedalions a doua textului
           - :alphabeth_code: :рм
             :language_code: :рм
             :targets:
             - "*Василий Васильский"
             :type: Kontakion
             :tone: 4
             :text: Condacul textului
           - :alphabeth_code: :рм
             :language_code: :рм
             :targets:
             - "*Василий Васильский"
             :type: Ikos
             :text: Icosul textului
         """


   Сценарий: Ссылка на местную службу с кафисмами
      Допустим есть местный сербский файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         утреня:
            кафисма:
             - седален:
                - глас: 1
                  крат: прв седалан
                  текст: текст прва седална
                - глас: 2
                  подобен: прв седалан
                  текст: текст друга седална
             - седален:
                  глас: 3
                  текст: текст трећа седална
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ср
           :language_code: :сх
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ср
             :language_code: :сх
             :targets:
             - "*Василий Васильский"
             :type: Kathismion
             :tone: 1
             :title: прв седалан
             :text: текст прва седална
           - :alphabeth_code: :ср
             :language_code: :сх
             :targets:
             - "*Василий Васильский"
             :type: Kathismion
             :tone: 2
             :prosomeion_title: прв седалан
             :text: текст друга седална
           - :alphabeth_code: :ср
             :language_code: :сх
             :targets:
             - "*Василий Васильский"
             :type: Kathismion
             :tone: 3
             :text: текст трећа седална
         """


   Сценарий: Ссылка на местную службу с полиелеем
      Допустим есть местный иверский файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         утреня:
            величание: ზეობა
            полиелей:
               седален:
                - глас: 1
                  крат: სასესიო ჰიმნი პირველი
                  текст: ტექსტი სასესიო ჰიმნი პირველი
                - глас: 2
                  подобен: სასესიო ჰიმნი პირველი
                  текст: ტექსტი სასესიო ჰიმნი მეორე
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ив
           :language_code: :ив
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ив
             :language_code: :ив
             :targets:
             - "*Василий Васильский"
             :type: Magnification
             :text: ზეობა
           - :alphabeth_code: :ив
             :language_code: :ив
             :targets:
             - "*Василий Васильский"
             :type: Polileosion
             :tone: 1
             :title: სასესიო ჰიმნი პირველი
             :text: ტექსტი სასესიო ჰიმნი პირველი
           - :alphabeth_code: :ив
             :language_code: :ив
             :targets:
             - "*Василий Васильский"
             :type: Polileosion
             :tone: 2
             :prosomeion_title: სასესიო ჰიმნი პირველი
             :text: ტექსტი სასესიო ჰიმნი მეორე
         """


   Сценарий: Ссылка на несколько местных разноязычных служб
      Допустим есть местный файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         вечерня:
            отпустительно:
               тропарь:
                  глас: 4
                  текст: Тропарёв текст
         """
      И есть иной местный файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         утреня:
            величание: Величание
            канон:
               кондак:
                - глас: 1
                  текст: Кондаков иной текст
                - глас: 2
                  текст: Кондаков ещё текст
         """
      И есть местный английский файл службы "Василию Васильскому служба" памяти "Василий Васильский":
         """
         вечерня:
            отпустительно:
               тропарь:
                  глас: 3
                  подобен: Other
                  текст: Another text
         """
      А задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :ра
           :language_code: :ан
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ра
             :language_code: :ан
             :targets:
             - "*Василий Васильский"
             :type: Troparion
             :tone: 3
             :prosomeion_title: Other
             :text: Another text
         - :alphabeth_code: :ру
           :language_code: :ру
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Magnification
             :text: Величание
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Kontakion
             :tone: 1
             :text: Кондаков иной текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Kontakion
             :tone: 2
             :text: Кондаков ещё текст
         - :alphabeth_code: :ру
           :language_code: :ру
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Troparion
             :tone: 4
             :text: Тропарёв текст
         """


   Сценарий: Ссылка на местную службу в hip
      Допустим есть местный файл службы "Василию Васильскому служба" памяти "Василий Васильский" в hip:
         """
         %<Гла'съ _е~. Подо'бенъ: Р%>а'дуйся:

         %<Р%>а'дуйся, сщ~е'нная главо`.
         """
      И задействуем память "Василий Васильский"

      Если есть строка служебной ссылки:
         """
          - Василию Васильскому служба
         """
      То обработанных данных ссылки не будет
      А обработанные данные службы будут выглядеть как:
         """
         ---
         - :alphabeth_code: :цр
           :language_code: :цс
           :name: Василию Васильскому служба
           :text_format: hip
           :text: |
             %<Гла'съ _е~. Подо'бенъ: Р%>а'дуйся:

             %<Р%>а'дуйся, сщ~е'нная главо`.
         """


   Сценарий: Неверный формат иконной ссылки указан
      Допустим есть строка служебной ссылки:
         """
         httr://recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"

      Если есть строка иконной ссылки:
         """
         file:///recource.ru
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"

      Если есть строка иконной ссылки:
         """
         - httpe/r/recource.ruw
         """
      То обработанных данных не будет
      И в списке ошибок будет ошибка "неверного формата ссылки"
