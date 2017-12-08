# language: ru
Функционал: Импортёр помина
   Предыстория:
    * есть память "Василий Васильский"
    * есть календарь "змин"

   Сценарий: Простой помин
      Допустим есть событие "Repose" в "10.10.1010" для памяти "Василий Васильский"
      И есть обработанные данные помина:
         """
         ---
         - :year_date: "10.10"
           :add_date: "11.11.1010"
           :calendary:
             :slugs:
               :text: змин
           :event:
             :type: Repose
             :memory:
               :short_name: Василий Васильский
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://azbyka.ru/days/assets/upload/minei/01/minea_01_01.pdf
         """

      Если импортируем их
      То будет создана модель помина с аттрибутами:
         | year_date       | 10.10        |
         | add_date        | 11.11.1010   |
         | calendary>slug  | ^змин        |
         | event           | ^10.10.1010  |
         | bind_kind       | несвязаный   |


   Сценарий: Связаный помин
      Допустим есть событие "Uncovering" в "10.10.1010" для памяти "Василий Васильский"
      И есть обработанные данные помина:
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

      Если импортируем их
      То будет создана модель помина с аттрибутами:
         | year_date       | 31.08           |
         | calendary>slug  | ^змин           |
         | event           | ^10.10.1010     |
         | bind_kind       | несвязаный      |
      И будет создана модель помина с аттрибутами:
         | year_date       | 01.09           |
         | calendary>slug  | ^змин           |
         | event           | ^10.10.1010     |
         | bind_kind       | попразднество   |


    Сценарий: Сложный помин
      Допустим есть календарь "рпц"
      И есть событие "Writing" в "1.1.1010" для памяти "Василий Васильский"
      И есть событие "Appearance" в "31.12.1015" для памяти "Василий Васильский"
      И есть другое событие "Appearance" в "31.12.1020" для памяти "Василий Васильский"
      И есть обработанные данные помина:
         """
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

      Если импортируем их
      То будут созданы модели помина с аттрибутами:
         | year_date: '01.01' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: несвязаный      |
         | year_date: '28.12' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: предпразднество |
         | year_date: '29.12' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: предпразднество |
         | year_date: '30.12' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: предпразднество |
         | year_date: '31.12' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: навечерие       |
         | year_date: '02.01' | calendary>slug: ^рпц   | event: ^1.1.1010   | bind_kind: попразднество   |
         | year_date: '31.12' | calendary>slug: ^змин  | event: ^31.12.1015 | bind_kind: несвязаный      |
         | year_date: '31.12' | calendary>slug: ^змин  | event: ^31.12.1020 | bind_kind: несвязаный      |
         | year_date: '01.01' | calendary>slug: ^змин  | event: ^31.12.1015 | bind_kind: попразднество   |
         | year_date: '01.01' | calendary>slug: ^змин  | event: ^31.12.1020 | bind_kind: попразднество   |
