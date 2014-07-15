shared_examples 'http code' do |code|
  it "returns http #{code}" do
    response.response_code.should == code
  end
end

shared_examples 'auth response' do
  context 'remember me on' do
    it_behaves_like 'auth response case' do
      let(:remember) { true }
    end
  end

  context 'remember me off' do
    it_behaves_like 'auth response case' do
      let(:remember) { false }
    end
  end

  context 'remember me unspecified' do
    it_behaves_like 'auth response case' do
      let(:remember) { nil }
    end
  end
end

shared_examples 'auth response case' do
  before do
    if [true, false].include? remember
      params[:remember] = remember
    end
    post 'create', params
  end
  subject { JSON.parse response.body }

  it { should include 'authentication_token' }

  it_behaves_like 'http code', 201
end
