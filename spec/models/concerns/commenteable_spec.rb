require 'rails_helper'

shared_examples_for 'commenteable' do
  it { should have_many(:comments).dependent(:destroy) }

  # let!(:commenteable) { create(described_class.to_s.underscore.to_sym) }
end
