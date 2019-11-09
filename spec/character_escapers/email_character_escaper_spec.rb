# frozen_string_literal: true

require_relative "../../character_escapers/email_character_escaper"

describe EmailCharacterEscaper do
  let(:email_1) { "test1@gmail.com" }
  let(:email_2) { "test100@gmail.com" }
  let(:not_valid_email) { "it is not a email" }
  let(:escape_symbol) { "v" }

  it "should escape characters for email 1" do
    expect(
      EmailCharacterEscaper.call(email_1)
    ).to eq("xxxxx@gmail.com")
  end

  it "should escape characters for email 2 with custom escape symbol" do
    expect(
      EmailCharacterEscaper.new.call(email_2, escape_symbol: escape_symbol)
    ).to eq("vvvvvvv@gmail.com")
  end

  it "should fail if it is not email" do
    expect { EmailCharacterEscaper.call(not_valid_email) }.to(
      raise_error(NotValidEscapeStringError)
    )
  end
end
