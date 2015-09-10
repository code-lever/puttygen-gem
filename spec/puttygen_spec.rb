require 'spec_helper'

describe Puttygen do

  it 'has a version number' do
    expect(Puttygen::VERSION).not_to be nil
  end

  describe '.convert_private_key' do

    let(:private_file) { File.expand_path('../data/rsa_4096.priv', __FILE__) }

    context 'when output_type is putty' do

      let(:output_type) { :putty }

      let(:putty_file) { File.expand_path('../data/rsa_4096.priv-putty', __FILE__) }

      let(:output) { Puttygen.convert_private_key(private_file, output_type: output_type) }

      it 'matches the pre-generated putty file' do
        expect(output).to eql(File.read(putty_file))
      end

    end

    context 'when output_type is sshcom' do

      let(:output_type) { :sshcom }

      let(:sshcom_file) { File.expand_path('../data/rsa_4096.priv-sshcom', __FILE__) }

      let(:output) { Puttygen.convert_private_key(private_file, output_type: output_type) }

      it 'matches the pre-generated ssh.com file' do
        expect(output).to eql(File.read(sshcom_file))
      end

    end

  end

  describe '.create_public_from_private' do

    let(:private_file) { File.expand_path('../data/rsa_4096.priv', __FILE__) }

    let(:public_file) { File.expand_path('../data/rsa_4096.pub', __FILE__) }

    it 'creates the known public key' do
      public = Puttygen.create_public_from_private(private_file, output_type: :openssh)
      public = public.split[0..1].join(' ') # ditch the comment
      expected = File.read(public_file).strip.split[0..1].join(' ')
      expect(public).to eql(expected)
    end

  end

  describe '.generate_keypair' do

    let(:keypair) { Puttygen.generate_keypair }

    it 'creates a keypair' do
      expect(keypair).to be_a(Puttygen::Keypair)
    end

    it 'has a non-empty private key' do
      expect(keypair.private).to_not be_nil
      expect(keypair.private).to_not be_empty
    end

    it 'has a non-empty public key' do
      expect(keypair.public).to_not be_nil
      expect(keypair.public).to_not be_empty
    end

  end

end
