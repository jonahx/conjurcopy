require 'spec_helper'

describe Audit::Event::Authn::Authenticate do
  let(:role_id) { 'rspec:user:my_user' }
  let(:authenticator_name) { 'my-authenticator'}
  let(:service) { double('my-service', resource_id: 'rspec:webservice:my-service') }
  let(:client_ip) { 'my-client-ip' }
  let(:success) { true }
  let(:error_message) { nil }

  subject do
    Audit::Event::Authn::Authenticate.new(
      role_id: role_id,
      authenticator_name: authenticator_name,
      service: service,
      client_ip: client_ip,
      success: success,
      error_message: error_message
    )
  end

  context 'when successful' do
    it 'produces the expected message' do
      expect(subject.message).to eq(
        'rspec:user:my_user successfully authenticated with authenticator ' \
        'my-authenticator service rspec:webservice:my-service'
      )
    end

    it 'uses the INFO log level' do
      expect(subject.severity).to eq(Syslog::LOG_INFO)
    end

    it 'renders to string correctly' do
      expect(subject.to_s).to eq(
        'rspec:user:my_user successfully authenticated with authenticator ' \
        'my-authenticator service rspec:webservice:my-service'
      )
    end

    it 'contains the user field' do
      expect(subject.structured_data).to match(hash_including({
          Audit::SDID::AUTH => {
              authenticator: authenticator_name,
              service: service.resource_id,
              user: role_id}
      }))
    end

    it_behaves_like 'structured data includes client IP address'
  end

  context 'when a failure occurs' do
    let(:success) { false }
    let(:error_message) { 'invalid authentication' }

    it 'produces the expected message' do
      expect(subject.message).to eq(
        'rspec:user:my_user failed to authenticate with authenticator ' \
        'my-authenticator service rspec:webservice:my-service: invalid authentication'
      )
    end

    it 'uses the WARNING log level' do
      expect(subject.severity).to eq(Syslog::LOG_WARNING)
    end

    it 'contains the not-found user field' do
      expect(subject.structured_data).to match(hash_including({
          Audit::SDID::AUTH => {
              authenticator: authenticator_name,
              service: service.resource_id,
              user: Audit::Event::NOT_FOUND
          }
      }))
    end

    it_behaves_like 'structured data includes client IP address'
  end

  context 'when a failure occurs but user exists' do
    let(:success) { false }
    before do
      expect(Role).to receive(:[]).and_return true
    end

    it 'contains the user field despite failure' do
      expect(subject.structured_data).to match(hash_including({
        Audit::SDID::AUTH => {
            authenticator: authenticator_name,
            service: service.resource_id,
            user: role_id
        }
    }))
    end
  end
end
