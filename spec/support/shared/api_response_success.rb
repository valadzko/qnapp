shared_examples_for "API Response Success" do
  it 'returns status 200' do
    expect(response).to be_success
  end
end
