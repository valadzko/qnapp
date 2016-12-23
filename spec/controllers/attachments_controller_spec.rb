require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:file){ create(:attachment, attachable: question) }

  describe 'DELETE#destroy' do
    context "author of attachable tries to delete attachment" do
      before do
        sign_in user
      end
      it 'decrease number of attachments in database by 1' do
        expect{ delete :destroy, xhr: true, params: {id: file.id, format: :js} }.to change(Attachment, :count).by(-1)
      end
      it 'renders js destroy view' do
        delete :destroy, xhr: true, params: {id: file.id, format: :js}
        expect(response).to render_template :destroy
      end
    end

    context "Non-author of attachable tries to delete attachment" do
      it 'does not change the number of attachments in database ' do
        expect{ delete :destroy, xhr: true, params: {id: file.id, format: :js} }.to_not change(Attachment, :count)
      end
    end
  end
end
