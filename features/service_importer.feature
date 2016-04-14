# language: ru
@importer @service
Функционал: Импортёр службы
   Сценарий: Простая служба
      Допустим есть память "Мария Богородица"
      И есть память "Василий Васильский"
      И есть обработанные данные службы:
         """
         ---
         - :alphabeth_code: :ро
           :language_code: :ру
           :name: Василию Васильскому служба
           :chants:
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Troparion
             :prosomeion_title: Тропарёв текст
             :text: Тропарёв ин текст.
             :tone: 4
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Kontakion
             :text: Кондаков иной текст
             :tone: 1
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Kanonion
             :tone: 1
             :title: Седален перв
             :text: Седальна перва текст
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Kathismion
             :tone: 1
             :title: друг седалан
             :text: текст друга седална
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Polileosion
             :tone: 1
             :title: Седален треть
             :text: текст третя седална
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: CryStichira
             :tone: 4
             :text: Возвашны текст
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Мария Богородица"
             :type: Troparion
             :tone: 1
             :text: Богородична текст
           :canticles:
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Ikos
             :text: Икоса текст
           :orisons:
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Prayer
             :text: Молитвы текст
           - :alphabeth_code: :ро
             :language_code: :ру
             :targets:
             - "*Василий Васильский"
             :type: Magnification
             :text: Величание
           :memory:
             :short_name: Василий Васильский
         """

      Если импортируем их
      То будет создана модель службы с аттрибутами:
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | name                     | Василию Васильскому служба  |
         | memory                   | *Василий Васильский         |
      И будет создана модель тропаря с аттрибутами:
         | tone                     | 4                           |
         | prosomeion_title         | Тропарёв текст              |
         | text                     | Тропарёв ин текст.          |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель кондака с аттрибутами:
         | tone                     | 1                           |
         | text                     | Кондаков иной текст         |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель седальна канона с аттрибутами:
         | tone                     | 1                           |
         | title                    | Седален перв                |
         | text                     | Седальна перва текст        |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель седальна кафисмы с аттрибутами:
         | tone                     | 1                           |
         | title                    | друг седалан                |
         | text                     | текст друга седална         |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель седальна полиелея с аттрибутами:
         | tone                     | 1                           |
         | title                    | Седален треть               |
         | text                     | текст третя седална         |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель возвашны с аттрибутами:
         | tone                     | 4                           |
         | text                     | Возвашны текст              |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель богородична с аттрибутами:
         | tone                     | 1                           |
         | text                     | Богородична текст           |
         | targets.memory           | *Мария Богородица           |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель икоса с аттрибутами:
         | text                     | Икоса текст                 |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | targets.memory           | *Василий Васильский         |
         | type                     | Ikos                        |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель величания с аттрибутами:
         | text                     | Величание                   |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | type                     | Magnification               |
         | service_cantoes.service  | *Василию Васильскому служба |
      И будет создана модель молитвы с аттрибутами:
         | text                     | Молитвы текст               |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | type                     | Prayer                      |
         | service_cantoes.service  | *Василию Васильскому служба |
