# language: ru
@importer @service
Функционал: Импортёр службы
   Сценарий: Простая служба
      Допустим есть память "Мария Богородица"
      И есть память "Василий Васильский"
      И есть обработанные данные службы:
         """
         ---
         - :alphabeth_code: :ру
           :language_code: :ру
           :name: Василию Васильскому служба
           :cantoes:
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Troparion
             :prosomeion_title: Тропарёв текст
             :text: Тропарёв ин текст.
             :tone: 4
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Kontakion
             :text: Кондаков иной текст
             :tone: 1
             :prosomeion_title: Подобен неку
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Kanonion
             :tone: 1
             :title: Седален перв
             :text: Седальна перва текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Kathismion
             :tone: 1
             :title: друг седалан
             :text: текст друга седална
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Polileosion
             :tone: 1
             :title: Седален треть
             :text: текст третя седална
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: CryStichira
             :tone: 4
             :text: Возвашны текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Мария Богородица"
             :type: Troparion
             :tone: 1
             :text: Богородична текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Ikos
             :text: Икоса текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Prayer
             :text: Молитвы текст
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Magnification
             :text: Величание
           - :alphabeth_code: :ру
             :language_code: :ру
             :targets:
             - "^Василий Васильский"
             :type: Troparion
             :ref_title: Тропарёв текст
           :memory:
             :short_name: Василий Васильский
         """

      Если импортируем их
      То будет создана модель службы с аттрибутами:
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | name                     | Василию Васильскому служба  |
         | info:memory              | ^Василий Васильский         |
      И будет создана модель тропаря с аттрибутами:
         | tone                     | 4                           |
         | prosomeion_title         | Тропарёв текст              |
         | text                     | Тропарёв ин текст.          |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель тропаря с аттрибутами:
         | ref_title                | Тропарёв текст              |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель кондака с аттрибутами:
         | tone                     | 1                           |
         | text                     | Кондаков иной текст         |
         | prosomeion_title         | Подобен неку                |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель седальна канона с аттрибутами:
         | tone                     | 1                           |
         | title                    | Седален перв                |
         | text                     | Седальна перва текст        |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель седальна кафисмы с аттрибутами:
         | tone                     | 1                           |
         | title                    | друг седалан                |
         | text                     | текст друга седална         |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель седальна полиелея с аттрибутами:
         | tone                     | 1                           |
         | title                    | Седален треть               |
         | text                     | текст третя седална         |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель возвашны с аттрибутами:
         | tone                     | 4                           |
         | text                     | Возвашны текст              |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель богородична с аттрибутами:
         | tone                     | 1                           |
         | text                     | Богородична текст           |
         | targets.memory           | ^Мария Богородица           |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель икоса с аттрибутами:
         | text                     | Икоса текст                 |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | targets.memory           | ^Василий Васильский         |
         | type                     | Ikos                        |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель величания с аттрибутами:
         | text                     | Величание                   |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | type                     | Magnification               |
         | service_cantoes.service  | ^Василию Васильскому служба |
      И будет создана модель молитвы с аттрибутами:
         | text                     | Молитвы текст               |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | type                     | Prayer                      |
         | service_cantoes.service  | ^Василию Васильскому служба |


   Сценарий: Импорт просто текста службы
      Допустим есть память "Василий Васильский"
      И есть обработанные данные службы:
         """
         ---
         - :alphabeth_code: :цр
           :language_code: :цс
           :name: Василию Васильскому служба
           :description: Описание
           :text_format: hip
           :text: <::лат> OCR:<::слав>


             %

             %<Мjь'сяца тогw'же въ к~д-й де'нь.%>
           :memory:
             :short_name: Василий Васильский
         """

      Если импортируем их
      То будет создана модель службы с аттрибутами:
         | alphabeth_code           | цр                          |
         | language_code            | цс                          |
         | name                     | Василию Васильскому служба  |
         | info:memory              | ^Василий Васильский         |
         | description              | Описание                    |
         | text_format              | hip                         |
         | text                     | <::лат> OCR:<::слав>\n\n%\n%<Мjь'сяца тогw'же въ к~д-й де'нь.%> |
