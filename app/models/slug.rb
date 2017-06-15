# text[string]                - кратко по предмету
# relates_to[belongs_to]      - отношение к предмету
#
class Slug < ActiveRecord::Base
   belongs_to :sluggable, polymorphic: true

   validates_presence_of :text ;end
