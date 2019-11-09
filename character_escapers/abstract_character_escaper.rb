# frozen_string_literal: true

class NotValidEscapeStringError < StandardError; end

class AbstractCharacterEscaper #:nodoc:
  def self.call(contact, *args)
    new.call(contact, *args)
  end

  def call(contact, *_args)
    raise NotValidEscapeStringError unless contact =~ validation_regexp
  end

  def validation_regexp
    raise NotImplementedError
  end
end
