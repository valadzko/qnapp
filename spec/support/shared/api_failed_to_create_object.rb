shared_examples_for "API Failed To Create Object" do
  it 'return 422 (unprocessable entity) code' do
    expect(response.status).to eq 422
  end

  it 'has errors in response' do
    expect(response.body).to have_json_path("errors")
  end
end
