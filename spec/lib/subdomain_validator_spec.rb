require 'spec_helper'
require 'subdomain_validator'

describe SubdomainValidator do

  subject do
    Class.new do
      include ActiveModel::Validations

      attr_accessor :subdomain
      validates :subdomain, subdomain: true
    end.new
  end

  it 'only validates if a value is present' do
    expect(subject).to be_valid
  end

  context 'reserved words' do
    it 'does not allow one of the default reserved words' do
      %w(www ftp mail pop smtp admin ssl sftp).each do |reserved|
        subject.subdomain = reserved
        expect(subject).not_to be_valid
      end
    end
  end

  context 'length' do
    it 'must have at least 3 chars' do
      subject.subdomain = 'a'
      expect(subject).not_to be_valid

      subject.subdomain = 'aa'
      expect(subject).not_to be_valid

      subject.subdomain = 'aaa'
      expect(subject).to be_valid
    end

    it 'cannot exceed 63 chars' do
      subject.subdomain = 'a' * 64
      expect(subject).not_to be_valid

      subject.subdomain = 'a' * 63
      expect(subject).to be_valid
    end
  end

  context 'hyphens' do
    it 'cannot start with a hyphen' do
      subject.subdomain = '-aaa'
      expect(subject).not_to be_valid
    end

    it 'cannot end with a hyphen' do
      subject.subdomain = 'aaa-'
      expect(subject).not_to be_valid
    end
  end

  context 'chars' do
    it 'can only contain alphanumeric chars and hyphens' do
      subject.subdomain = 'aaa!'
      expect(subject).not_to be_valid

      subject.subdomain = 'abcdefghijklmnopqrstuvwxyz-0123456789'
      expect(subject).to be_valid
    end
  end

end
