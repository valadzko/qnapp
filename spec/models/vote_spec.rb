require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :votable_id }
  it { should validate_presence_of :votable_type }
  it { should define_enum_for(:status).with([:default, :upvote, :downvote]) }
end
