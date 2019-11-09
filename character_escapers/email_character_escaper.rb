# frozen_string_literal: true

require_relative "abstract_character_escaper"

class EmailCharacterEscaper < AbstractCharacterEscaper #:nodoc:
  def call(email, escape_symbol: "x")
    super
    escaped_email = escape_email(email, escape_symbol)
    domain = fetch_domain_from_email!(email)

    "#{escaped_email}@#{domain}"
  end

  def escape_email(email, escape_symbol)
    email_name = email.split("@")[0]

    escape_symbol * email_name.length
  end

  def fetch_domain_from_email!(email)
    email.split("@")[1]
  end

  def validation_regexp
    URI::MailTo::EMAIL_REGEXP
  end
end
