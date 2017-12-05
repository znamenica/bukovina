# bind_type(string)  - type of binding
# bond_to_id(int)    - id of name which the name is linked (bond) to
class Name < ActiveRecord::Base
   extend Language

   has_many :memories, through: :memory_names
   has_many :memory_names
   has_many :children, class_name: :Name, foreign_key: :bond_to_id

   belongs_to :bond_to, class_name: :Name
   belongs_to :root, class_name: :Name

   #enum bind_kind: [ 'несвязаное', 'переводное', 'прилаженое', 'переложеное', 'уменьшительное', 'подобное' ]

   has_alphabeth on: { text: [ :nosyntax, allow: " ‑" ] }

   scope :with_token, -> text { where( "text ~* ?", "\\m#{text}.*" ) }
   scope :with_tokens, -> token_list do
      # TODO fix the correctness of the query
      tokens = token_list.reject { |t| t =~ /\A[\s\+]*\z/ }
      cond = tokens.first[0] == '+' && 'TRUE' || 'FALSE'
      rel = where( cond )
      tokens.reduce(rel) do |rel, token|
         /\A(?<a>\+)?(?<text>.*)/ =~ token
         if a # AND operation
            rel.where("names.text ILIKE ?", "%#{text}%")
         else # OR operation
            rel.or(where("names.text ILIKE ?", "%#{text}%")) ;end;end
      .distinct ;end

   validates :text, :language_code, presence: true

   before_create -> { self.bind_kind ||= 'несвязаное' } ;end unless defined? Name
