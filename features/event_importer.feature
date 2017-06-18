# language: ru
Функционал: Импортёр события
   Предыстория:
    * есть память "Василий Васильский"

   Сценарий: Простое событие
      Допустим есть обработанные данные события:
         """
         ---
         - :happened_at: "10.10.1010"
           :type: Nativity
           :memory:
             :short_name: "^Василий Васильский"
           :item:
             :item_type:
               :descriptions:
               - :alphabeth_code: :ру
                 :language_code: :ру
                 :text: глава
           :place:
             :descriptions:
             - :alphabeth_code: :ру
               :language_code: :ру
               :text: Красная площадь
         """

      Если импортируем их
      То будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | type               | Nativity              |
         | memory             | ^Василий Васильский   |
         | place>descriptions | ^Красная площадь      |
      И будет создана модель предмета с аттрибутами:
         | item_type>descriptions   | ^глава       |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь       |
         | language_code      | ру                    |
         | alphabeth_code     | ру                    |
         | describable_type   | Place                 |


   Сценарий: Много событий
      Допустим есть обработанные данные события:
         """
         ---
         - :happened_at: "10.10.1010"
           :type: Nativity
           :memory:
             :short_name: "^Василий Васильский"
           :item:
             :item_type:
               :descriptions:
               - :alphabeth_code: :ру
                 :language_code: :ру
                 :text: глава
           :place:
             :descriptions:
             - :alphabeth_code: :ру
               :language_code: :ру
               :text: Красная площадь
         - :happened_at: 1.1.1000
           :type: Benediction
           :memory:
             :short_name: "^Василий Васильский"
         """

      Если импортируем их
      То будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | type               | Nativity              |
         | memory             | ^Василий Васильский   |
         | place>descriptions | ^Красная площадь      |
         | memory             | ^Василий Васильский   |
      И будет создана модель предмета с аттрибутами:
         | item_type>descriptions   | ^глава       |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь       |
         | language_code      | ру                    |
         | alphabeth_code     | ру                    |
         | describable_type   | Place                 |
      И будет создана модель события с аттрибутами:
         | happened_at        | 1.1.1000              |
         | type               | Benediction           |


   Сценарий: Событие с данными
      Допустим есть обработанные данные события:
         """
         ---
         - :memory:
             :short_name: "^Василий Васильский"
           :happened_at: 10.10.1010
           :type: Conceiving
           :person_name: Царько Вислонский
           :place:
             :descriptions:
             - :alphabeth_code: :ру
               :language_code: :ру
               :text: Красная площадь
           :descriptions:
           - :alphabeth_code: :ру
             :language_code: :ру
             :text: Рождество
           :wikies:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://wiki.ws/вики
           :beings:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://being.ws/
           :icon_links:
           - :url: http://wiki.ws/образ.jpg
             :description:
               :alphabeth_code: :ру
               :language_code: :ру
               :text: описание иконы
           :item:
             :item_type:
               :descriptions:
               - :alphabeth_code: :ру
                 :language_code: :ру
                 :text: глава
           :service_links:
           - :alphabeth_code: :ру
             :language_code: :ру
             :url: http://service.ws/
           :services:
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
         """

      Если импортируем их
      То будет создана модель предмета с аттрибутами:
         | item_type>descriptions   | ^глава       |
      И будет создана модель события с аттрибутами:
         | happened_at        | 10.10.1010            |
         | type               | Conceiving            |
         | memory             | ^Василий Васильский   |
         | person_name        | Царько Вислонский     |
         | place>descriptions | ^Красная площадь      |
      И будет создана модель описания с аттрибутами:
         | text               | Красная площадь    |
         | language_code      | ру                 |
         | alphabeth_code     | ру                 |
         | describable_type   | Place              |
      И будет создана модель описания с аттрибутами:
         | text            | Рождество       |
         | alphabeth_code  | ру              |
         | language_code   | ру              |
      И будет создана модель иконной ссылки с аттрибутами:
         | url                | http://wiki.ws/образ.jpg |
         | >description       | ^описание иконы          |
      И будет создана модель описания с аттрибутами:
         | text            | описание иконы  |
         | alphabeth_code  | ру              |
         | language_code   | ру              |
      И будет создана модель вики ссылки с аттрибутами:
         | url             | http://wiki.ws/вики   |
         | alphabeth_code  | ру                    |
         | language_code   | ру                    |
      И будет создана модель бытийной ссылки с аттрибутами:
         | url             | http://being.ws/      |
      И будет создана модель служебной ссылки с аттрибутами:
         | url             | http://service.ws/    |
      И будет создана модель службы с аттрибутами:
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | name                     | Василию Васильскому служба  |
         | info:event               | ^10.10.1010                 |
      И будет создана модель тропаря с аттрибутами:
         | tone                     | 4                           |
         | prosomeion_title         | Тропарёв текст              |
         | text                     | Тропарёв ин текст.          |
         | language_code            | ру                          |
         | alphabeth_code           | ру                          |
         | service_cantoes.service  | ^Василию Васильскому служба |
