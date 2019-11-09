# frozen_string_literal: true

require_relative "../../character_escapers/phone_character_escaper"

describe PhoneCharacterEscaper do
  let(:phone_1) { "+7 666 777 888" }
  let(:phone_2) { "+7 666 777       888" }
  let(:not_valid_phone) { "it is not a phone nuber" }
  let(:escape_symbol) { "v" }

  it "should escape phone" do
    expect(
      PhoneCharacterEscaper.call(phone_1)
    ).to eq("+7 666 777 xxx")
  end

  it "should escape phone with custom escape symbol and length" do
    expect(
      PhoneCharacterEscaper.call(
        phone_2,
        escape_symbol: escape_symbol,
        escape_length: 5
      )
    ).to eq("+7 666 7vv vvv")
  end

  it "should fail if it is not phone number" do
    expect { PhoneCharacterEscaper.call(not_valid_phone).call }.to(
      raise_error(NotValidEscapeStringError)
    )
  end
end
