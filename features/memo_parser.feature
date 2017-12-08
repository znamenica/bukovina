# language: ru
Функционал: Обработчик помина
   Сценарий: Простой помин
      Допустим задействуем память "Василий Васильский"
      И есть словцик помина:
         """
           дата: 31.08
           год: 10.10.1010
           календарь: змин
           описание: прств
           служба:
            - http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
         """
      То обработанные данные помина будут выглядеть как:
         """
         ---
         - :year_date: '31.08'
           :add_date: 10.10.1010
           :event:
             :type: Repose
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           :calendary:
             :slugs:
               :text: змин
         """


   Сценарий: Простой помин с попразднеством
      Допустим задействуем память "Василий Васильский"
      И есть словцик помина:
         """
           дата: 31.08
           календарь: змин
           описание: обр
           служба:
            - http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           по: 1
         """
      То обработанные данные помина будут выглядеть как:
         """
         ---
         - :year_date: '31.08'
           :event:
             :type: Uncovering
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           :calendary:
             :slugs:
               :text: змин
         - :year_date: '01.09'
           :event:
             :type: Uncovering
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           :bond_to_marker: '31.08'
           :bind_kind: попразднество
           :calendary:
             :slugs:
               :text: змин
         """


   Сценарий: Простой помин со двумя событиями
      Допустим задействуем память "Василий Васильский"
      И есть словцик помина:
         """
           дата: 31.08
           календарь: змин
           служба:
            - http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           описание: обр,обр.1
         """
      То обработанные данные помина будут выглядеть как:
         """
         ---
         - :year_date: '31.08'
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           :event:
             :type: Uncovering
             :memory:
               :short_name: Василий Васильский
           :calendary:
             :slugs:
               :text: змин
         - :year_date: '31.08'
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/08/minea_08_29.pdf
           :event:
             :type: Uncovering
             :type_number: '1'
             :memory:
               :short_name: Василий Васильский
           :calendary:
             :slugs:
               :text: змин
         """


   Сценарий: Сложный помин
      Допустим задействуем память "Василий Васильский"
      И есть словцик помина:
         """
         - дата: 01.01
           календарь: рпц
           описание: напис
           служба:
            - http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           пред: 3
           навеч: 1
           по: 1
         - дата: 31.12
           календарь: змин
           описание: явл,явл.1
           служба:
            - http://azbyka.ru/days/assets/upload/minei/12/minea_31_12.pdf
           по: 1
         """
      То обработанные данные помина будут выглядеть как:
         """
         ---
         - :year_date: '01.01'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '28.12'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :bond_to_marker: '01.01'
           :bind_kind: предпразднество
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '29.12'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :bond_to_marker: '01.01'
           :bind_kind: предпразднество
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '30.12'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :bond_to_marker: '01.01'
           :bind_kind: предпразднество
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '31.12'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :bond_to_marker: '01.01'
           :bind_kind: навечерие
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '02.01'
           :event:
             :type: Writing
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
           :bond_to_marker: '01.01'
           :bind_kind: попразднество
           :calendary:
             :slugs:
               :text: рпц
         - :year_date: '31.12'
           :event:
             :type: Appearance
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/12/minea_31_12.pdf
           :calendary:
             :slugs:
               :text: змин
         - :year_date: '31.12'
           :event:
             :type: Appearance
             :type_number: '1'
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/12/minea_31_12.pdf
           :calendary:
             :slugs:
               :text: змин
         - :year_date: '01.01'
           :event:
             :type: Appearance
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/12/minea_31_12.pdf
           :bond_to_marker: '31.12'
           :bind_kind: попразднество
           :calendary:
             :slugs:
               :text: змин
         - :year_date: '01.01'
           :event:
             :type: Appearance
             :type_number: '1'
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/12/minea_31_12.pdf
           :bond_to_marker: '31.12'
           :bind_kind: попразднество
           :calendary:
             :slugs:
               :text: змин
         """
