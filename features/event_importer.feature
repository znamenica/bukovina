# language: ru
Функционал: Импортёр события
   Предыстория:
    * есть память "Василий Васильский"

   Сценарий: Простое событие
      Допустим есть обработанные данные события:
         """
         ---
         - :happened_at: "10.10.1010"
           :subject: глава
           :type: Birth
           :memory:
             :short_name: "*Василий Васильский"
           :place:
             :descriptions:
             - :alphabeth_code: ро
               :language_code: ру
               :text: Красная площадь
         """

      Если импортируем их
      То будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | subject            | глава                 |
         | type               | Birth                 |
         | memory             | *Василий Васильский   |
         | place>descriptions | *Красная площадь      |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь       |
         | language_code      | ру                    |
         | alphabeth_code     | ро                    |
         | describable_type   | Place                 |


   Сценарий: Много событий
      Допустим есть обработанные данные события:
         """
         ---
         - :happened_at: "10.10.1010"
           :subject: глава
           :type: Birth
           :memory:
             :short_name: "*Василий Васильский"
           :place:
             :descriptions:
             - :alphabeth_code: ро
               :language_code: ру
               :text: Красная площадь
         - :happened_at: 1.1.1000
           :type: Benediction
           :memory:
             :short_name: "*Василий Васильский"
         """

      Если импортируем их
      То будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | subject            | глава                 |
         | type               | Birth                 |
         | memory             | *Василий Васильский   |
         | place>descriptions | *Красная площадь      |
         | memory             | *Василий Васильский   |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь       |
         | language_code      | ру                    |
         | alphabeth_code     | ро                    |
         | describable_type   | Place                 |
      И будет создана модель события с аттрибутами:
         | happened_at        | 1.1.1000              |
         | type               | Benediction           |


   Сценарий: Событие с данными
      Допустим есть обработанные данные события:
         """
         ---
         - :happened_at: 10.10.1010
           :subject: глава
           :type: Birth
           :memory:
             :short_name: "*Василий Васильский"
           :place:
             :descriptions:
             - :alphabeth_code: ро
               :language_code: ру
               :text: Красная площадь
           :descriptions:
           - :alphabeth_code: ро
             :language_code: ру
             :text: Рождество
           :wikies:
           - :alphabeth_code: :ро
             :language_code: :ру
             :url: http://wiki.ws/вики
           :beings:
           - :url: http://being.ws/
           :icon_links:
           - :url: http://wiki.ws/образ.jpg
             :description:
               :alphabeth_code: :ро
               :language_code: :ру
               :text: описание иконы
           :service_links:
           - :url: http://service.ws/
           :services:
           - :alphabeth_code: :ро
             :language_code: :ру
             :name: Василию Васильскому служба
             :info>memory:
               :short_name: "*Василий Васильский"
             :cantoes:
             - :alphabeth_code: :ро
               :language_code: :ру
               :targets:
               - "*Василий Васильский"
               :type: Troparion
               :prosomeion_title: Тропарёв текст
               :text: Тропарёв ин текст.
               :tone: 4
         """

      Если импортируем их
      То будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | subject            | глава                 |
         | type               | Birth                 |
         | memory             | *Василий Васильский   |
         | place>descriptions | *Красная площадь      |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь    |
         | language_code      | ру                 |
         | alphabeth_code     | ро                 |
         | describable_type   | Place              |
      И будет создана модель описания с аттрибутами:
         | text            | Рождество       |
         | alphabeth_code  | ро              |
         | language_code   | ру              |
      То будет создана модель иконной ссылки с аттрибутами:
         | url             | http://wiki.ws/образ.jpg |
      И будет создана модель описания с аттрибутами:
         | text            | описание иконы  |
         | alphabeth_code  | ро              |
         | language_code   | ру              |
      И будет создана модель вики ссылки с аттрибутами:
         | url             | http://wiki.ws/вики   |
         | alphabeth_code  | ро                    |
         | language_code   | ру                    |
      И будет создана модель бытийной ссылки с аттрибутами:
         | url             | http://being.ws/      |
      И будет создана модель служебной ссылки с аттрибутами:
         | url             | http://service.ws/    |
      И будет создана модель службы с аттрибутами:
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | name                     | Василию Васильскому служба  |
         | info:memory              | *Василий Васильский         |
      И будет создана модель тропаря с аттрибутами:
         | tone                     | 4                           |
         | prosomeion_title         | Тропарёв текст              |
         | text                     | Тропарёв ин текст.          |
         | language_code            | ру                          |
         | alphabeth_code           | ро                          |
         | service_cantoes.service  | *Василию Васильскому служба |
