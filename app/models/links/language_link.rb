require_relative '../link'

class LanguageLink < Link
   validates :language_code, inclusion: { in: self.language_codes } ; end
