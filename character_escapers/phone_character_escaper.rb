# frozen_string_literal: true

require_relative "abstract_character_escaper"

class PhoneCharacterEscaper < AbstractCharacterEscaper # :nodoc:
  def call(phone, escape_symbol: "x", escape_length: 3)
    super
    escape_phone(phone, escape_symbol, escape_length)
  end

  def escape_phone(phone, escape_symbol, escape_length)
    escaped_symbols = 0
    escaped_phone = phone.split("").reverse.map do |symbol|
      if escaped_symbols < escape_length && symbol =~ /\d/
        escaped_symbols += 1
        escape_symbol
      else
        symbol
      end
    end.reverse.join
    escaped_phone.gsub(/[ ]{2,}/, " ")
  end

  def validation_regexp
    /^\+[\d|\s]+$/
  end
end
