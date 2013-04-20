require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'locales' do

  let(:title) { 'locales' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_package('locales').with_ensure('present') }
    it { should contain_file('locales.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('locales').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[locales]' do should contain_package('locales').with_ensure('absent') end 
    it 'should remove locales configuration file' do should contain_file('locales.conf').with_ensure('absent') end
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('locales').with_noop('true') }
    it { should contain_file('locales.conf').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "locales/spec.erb" , :options => { 'opt_a' => 'value_a' } } }
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'locales.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'locales.conf').send(:parameters)[:content]
      content.should match "value_a"
    end
  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet:///modules/locales/spec"} }
    it { should contain_file('locales.conf').with_source('puppet:///modules/locales/spec') }
  end

  describe 'Test customizations - source_dir' do
    let(:params) { {:source_dir => "puppet:///modules/locales/dir/spec" , :source_dir_purge => true } }
    it { should contain_file('locales.dir').with_source('puppet:///modules/locales/dir/spec') }
    it { should contain_file('locales.dir').with_purge('true') }
    it { should contain_file('locales.dir').with_force('true') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "locales::spec" } }
    it { should contain_file('locales.conf').with_content(/rspec.example42.com/) }
  end

end
