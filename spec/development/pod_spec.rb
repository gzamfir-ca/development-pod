# frozen_string_literal: true

RSpec.describe Development::Pod do
  it "has a version number" do
    expect(Development::Pod.new.version).not_to be nil
  end

  it "does reply with pong" do
    expect(Development::Pod.new.ping).to eq("pong")
  end
end
