require 'open3'
require 'puttygen/version'
require 'ruby_expect'
require 'tempfile'

module Puttygen

  PRIVATE_OUTPUT_FORMATS = {
    putty: 'private',
    openssh: 'private-openssh',
    sshcom: 'private-sshcom',
  }

  PUBLIC_OUTPUT_FORMATS = {
    standard: 'public',
    sshcom: 'public',
    openssh: 'public-openssh',
  }

  # A public and private key pair.
  class Keypair
    attr_reader :public, :private
    def initialize(public, private)
      @public = public
      @private = private
    end
  end

  # Convert an existing private key to another key format.
  #
  # @param private_key_path [String] path to private key
  # @param output_format [Symbol] output format of private key to generate, one of +:putty+, +:openssh+ or +:sshcom+
  # @return [String] private key contents
  def self.convert_private_key(private_key_path, output_format: :putty)
    outfile = Dir::Tmpname.make_tmpname(Dir.tmpdir, nil)
    outflag = PRIVATE_OUTPUT_FORMATS.fetch(output_format, 'private')
    out, status = Open3.capture2e("puttygen #{private_key_path} -q -O #{outflag} -o #{outfile}")
    process_exit_status(out, status)
    File.read(outfile)
  ensure
    FileUtils.rm_f(outfile)
  end

  # Create a public key from a private key.
  #
  # @param private_key_path [String] path to private key
  # @param output_format [Symbol] output format of public key to generate, one of +:standard+, +:openssh+ or +:sshcom+
  # @return [String] public key contents
  def self.create_public_from_private(private_key_path, output_format: :standard)
    outflag = PUBLIC_OUTPUT_FORMATS.fetch(output_format, 'public')
    out, status = Open3.capture2e("puttygen #{private_key_path} -q -O #{outflag}")
    process_exit_status(out, status)
    out.strip
  end

  # Generate a new public/private key pair.
  #
  # @param type [Symbol] type of key to generate, one of +:rsa+, +:dsa+ or +:rsa1+
  # @param bits [Integer] number of bits for key
  # @param passphrase [String] passphrase to use for key (can be +nil+ or empty for no passphrase)
  # @param private_format [Symbol] output format of private key to generate, one of +:putty+, +:openssh+ or +:sshcom+
  # @param public_format [Symbol] output format of public key to generate, one of +:standard+, +:openssh+ or +:sshcom+
  # @return [Keypair] public and private keys
  def self.generate_keypair(type: :rsa, bits: 2048, comment: nil, passphrase: nil, private_format: :putty, public_format: :standard)
    outfile = Dir::Tmpname.make_tmpname(Dir.tmpdir, nil)
    outflag = PRIVATE_OUTPUT_FORMATS.fetch(private_format, 'private')
    line = "puttygen -q -t #{type} -b #{bits} -C '#{comment}' -O #{outflag} -o #{outfile}"

    cmd = RubyExpect::Expect.spawn(line)
    cmd.procedure do
      each do
        expect 'Enter passphrase to save key:' do
          send passphrase
        end
        expect 'Re-enter passphrase to verify:' do
          send passphrase
        end
      end
    end

    public = create_public_from_private(outfile, output_format: public_format)
    Keypair.new(public, File.read(outfile))
  ensure
    FileUtils.rm_f(outfile)
  end

  # Fingerprint a private key.
  #
  # @param private_key_path [String] path to private key
  # @return [String] fingerprint of private key
  def self.fingerprint(private_key_path)
    out, status = Open3.capture2e("puttygen #{private_key_path} -q -l")
    process_exit_status(out, status)
    out.strip
  end

  private

  def self.process_exit_status(output, status)
    unless(status.success?)
      raise "Command failed (#{output.strip})"
    end
  end

end
