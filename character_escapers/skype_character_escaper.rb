# frozen_string_literal: true

require_relative "abstract_character_escaper"

class SkypeCharacterEscaper < AbstractCharacterEscaper # :nodoc:
  def call(skype, escape_symbol: "x")
    super
    escape_skype(skype, escape_symbol)
  end

  def escape_skype(skype, escape_symbol)
    skype.sub(/(?<=skype:)[\S^]+?(?=\?|$)/, escape_symbol * 3)
  end

  def validation_regexp
    /skype:\S+/
  end
end
