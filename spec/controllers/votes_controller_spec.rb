require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let!(:question) { create(:question) }
  sign_in_user
  before do
    @author = create(:user)
    @question = create(:question, user: @author)
    @answer = create(:answer, question: @question, user: @author)
  end

  describe 'GET #upvote' do
    context 'non author of the answer' do
      before do
        @expected_response_json = %({"id":"#{@answer.id}","rating":#{@answer.rating + 1}})
        xhr :get, :upvote, id: @answer.id, type:'Answer', format: :json
      end
      it 'assigns the requested obj to @obj' do
        expect(assigns(:obj)).to eq @answer
      end
      it 'increase answer rating by 1' do
        expect(response.body).to be_json_eql(@expected_response_json)
      end
    end

    context 'author of answer' do
      it 'can not change the rating of his answer' do
        sign_out(@user)
        sign_in(@author)
        xhr :get, :upvote, id: @answer.id, type:'Answer', format: :json
        @answer.reload
        expected_response_json = %({"id":"#{@answer.id}","errors":"Author can not vote!"})
        expect(@answer.rating).to eq 0
        expect(response.body).to be_json_eql(expected_response_json)
      end
    end
  end

  describe 'GET #resetvote' do
    context 'non author of the answer' do
      before do
        @expected_response_json = %({"id":"#{@answer.id}","rating":#{@answer.rating}})
        xhr :get, :upvote, id: @answer.id, type:'Answer', format: :json
        xhr :get, :resetvote, id: @answer.id, type:'Answer', format: :json
      end
      it 'assigns the requested obj to @obj' do
        expect(assigns(:obj)).to eq @answer
      end
      it 'reset object rating' do
        expect(response.body).to be_json_eql(@expected_response_json)
      end
    end

    context 'author of answer' do
      it 'can not change the rating of his answer' do
        sign_out(@user)
        sign_in(@author)
        xhr :get, :resetvote, id: @answer.id, type:'Answer', format: :json
        @answer.reload
        expected_response_json = %({"id":"#{@answer.id}","errors":"Author can not vote!"})
        expect(@answer.rating).to eq 0
        expect(response.body).to be_json_eql(expected_response_json)
      end
    end
  end

  describe 'GET #downvote' do
    context 'non author of the answer' do
      before do
        @expected_response_json = %({"id":"#{@answer.id}","rating":#{@answer.rating - 1}})
        xhr :get, :downvote, id: @answer.id, type:'Answer', format: :json
      end
      it 'assigns the requested object to @obj' do
        expect(assigns(:obj)).to eq @answer
      end
      it 'increase answer rating by 1' do
        expect(response.body).to be_json_eql(@expected_response_json)
      end
    end

    context 'author of answer' do
      it 'can not change the rating of his answer' do
        sign_out(@user)
        sign_in(@author)
        xhr :get, :downvote, id: @answer.id, type:'Answer', format: :json
        @answer.reload
        expected_response_json = %({"id":"#{@answer.id}","errors":"Author can not vote!"})
        expect(@answer.rating).to eq 0
        expect(response.body).to be_json_eql(expected_response_json)
      end
    end
  end

end
