require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { create(:question) }
  it { should have_many :answers }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(15) }

  it_behaves_like "Votable"
  it_behaves_like "Attachable"
end
