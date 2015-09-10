require 'open3'
require 'puttygen/version'
require 'ruby_expect'
require 'tempfile'

module Puttygen

  PRIVATE_OUTPUT_TYPES = {
    putty: 'private',
    openssh: 'private-openssh',
    sshcom: 'private-sshcom',
  }

  PUBLIC_OUTPUT_TYPES = {
    standard: 'public',
    sshcom: 'public',
    openssh: 'public-openssh',
  }

  class Keypair
    attr_reader :public, :private
    def initialize(public, private)
      @public = public
      @private = private
    end
  end

  def self.convert_private_key(private_key_path, output_type: :putty)
    outfile = Dir::Tmpname.make_tmpname(Dir.tmpdir, nil)
    outflag = PRIVATE_OUTPUT_TYPES.fetch(output_type, 'private')
    out, status = Open3.capture2e("puttygen #{private_key_path} -q -O #{outflag} -o #{outfile}")
    process_exit_status(out, status)
    File.read(outfile)
  ensure
    FileUtils.rm_f(outfile)
  end

  def self.create_public_from_private(private_key_path, output_type: :standard)
    outflag = PUBLIC_OUTPUT_TYPES.fetch(output_type, 'public')
    out, status = Open3.capture2e("puttygen #{private_key_path} -q -O #{outflag}")
    process_exit_status(out, status)
    out.strip
  end

  def self.generate_keypair(type: :rsa, bits: 2048, comment: nil, passphrase: nil, private_type: :putty, public_type: :standard)
    outfile = Dir::Tmpname.make_tmpname(Dir.tmpdir, nil)
    outflag = PRIVATE_OUTPUT_TYPES.fetch(private_type, 'private')
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

    public = create_public_from_private(outfile, output_type: public_type)
    Keypair.new(public, File.read(outfile))
  ensure
    FileUtils.rm_f(outfile)
  end

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
