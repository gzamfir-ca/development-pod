# frozen_string_literal: true

RSpec.describe Development::Pod do
  it "does return 0" do
    expect(Development::Pod.new.version).to eq(0)
  end

  it "does return 0" do
    expect(Development::Pod.new.ping).to eq(0)
  end
end
