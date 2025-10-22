# frozen_string_literal: true

RSpec.describe Development::Pod do
  it "has a version number" do
    expect(Development::Pod::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(Development::Pod.ping).to eq("pong")
  end
end
