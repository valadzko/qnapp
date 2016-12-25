shared_examples_for "API Response Object Has Attachments" do

  context "attachments in response object" do
    let!(:attachment) { attachments.last }

    it 'included attachment list in response object' do
      expect(response.body).to have_json_size(attachments.size).at_path(attachments_path)
    end

    %w(id created_at).each do |attr|
      it "attachment in response object contains #{attr} param" do
        expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("#{attachments_path}/0/#{attr}")
      end
    end

    it 'attachment in response object includes url param' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("#{attachments_path}/0/url")
    end
  end
end
