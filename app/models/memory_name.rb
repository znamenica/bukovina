class MemoryName < ActiveRecord::Base
   belongs_to :memory
   belongs_to :name

   enum state: [ :наречёное, :самоданное, :крещенское, :чернецкое, :иноческое,
      :схимное, :отчество, :отчество_принятое, :кумство, :благословенное,
      :покаянное, :отечья, :мужнина, :наречёная, :самоданная, :матерня,
      :прозвание, :подвига_мученичества, :подвига_пастырства, :подвига_святительства,
      :подвига_страстотерпчества, :подвига_исповедничества, :подвига_чтецтва,
      :подвига_дияконства, :подвига_учительства, :подвига_отшельничества ]
   enum mode: [ :ored, :prefix ]

   accepts_nested_attributes_for :name, reject_if: :all_blank

   validates_presence_of :memory, :name
   # validates :state, inclusion: { in: states.keys } # TODO later after import

   def name_attributes= value
      self.name = Name.where(value).first || super && name ;end

   def to_s
      name.text ;end;end
