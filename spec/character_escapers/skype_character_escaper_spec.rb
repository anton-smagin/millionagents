# frozen_string_literal: true

require_relative "../../character_escapers/skype_character_escaper"

describe SkypeCharacterEscaper do
  let(:skype_1) { "skype:alex.max" }
  let(:skype_2) { '<a href=\"skype:alex.max?call\">skype</a>' }
  let(:not_valid_skype) { "it is not skype link" }

  it "should escape characters for skype name" do
    expect(SkypeCharacterEscaper.call(skype_1)).to eq("skype:xxx")
  end

  it "should escape characters for skype link" do
    expect(
      SkypeCharacterEscaper.call(skype_2)
    ).to eq('<a href=\"skype:xxx?call\">skype</a>')
  end

  it "should fail if it is not skype link" do
    expect { SkypeCharacterEscaper.call(not_valid_skype).call }.to(
      raise_error(NotValidEscapeStringError)
    )
  end
end
