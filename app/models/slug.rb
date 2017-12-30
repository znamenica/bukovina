# text[string]                - кратко по предмету
# related_to[belongs_to]      - отношение к предмету
#
class Slug < ActiveRecord::Base
   belongs_to :sluggable, polymorphic: true

   validates :text, format: { with: /\A[0-9а-яё]+\z/ }

   scope :for_calendary, -> { where( sluggable_type: 'Calendary' ) }

   def base= value
      digits = value.mb_chars.downcase.to_s.gsub(/[^0-9]+/, '')
      words = value.gsub(/[0-9]+/, '').split(/\s+/).select do |x|
         x.mb_chars.downcase.to_s != x ;end
      .map do |x|
         x.mb_chars.downcase ;end
      firsts = words.map { |l| l[0] }

      self.text =
      if digits.size > 3
         digits[0..5]
      elsif digits.size > 0
         digits + firsts[ 0...4 - digits.size ].join
      elsif firsts.size > 2
         firsts[ 0...5 ].join
      elsif firsts.size > 1
         # [ firsts, words.map { |l| l[1] } ].transpose.flatten.join
         last = words[ 1 ].gsub( /[аеёиоуъыьэюя]+/, '' )[ 0...3 ]
         first = words[ 0 ][ 0...5 - last.size ]
         first + last
      else
         words.first[ 0..5 ] ;end;end;end
