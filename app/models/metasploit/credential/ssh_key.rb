require 'net/ssh'

# A private SSH key file.
class Metasploit::Credential::SSHKey < Metasploit::Credential::Private
  #
  # Attributes
  #

  # @!attribute data
  #   A private SSH key file's content including the `-----BEGIN <type> PRIVATE KEY-----` header and
  #   `-----END <type> PRIVATE KEY-----` footer with everything in between.
  #
  #   @return [String]

  #
  #
  # Validations
  #
  #

  #
  # Attribute Validations
  #

  validates :data, presence: true
  #
  # Method Validations
  #

  validate :private
  validate :readable
  validate :unencrypted

  #
  # Instance Methods
  #

  # Whether the key data in {#data} is encrypted.  Encrypted keys cannot be saved and should be decrypted before saving
  # in a {Metasploit::Credential::SSHKey}.
  #
  # @return [false] if {#data} does not contain `'ENCRYPTED'` or {#data} is `nil`.
  # @return [true] if {#data} contains `'ENCRYPTED'`.
  def encrypted?
    return false unless data
    # see https://github.com/net-ssh/net-ssh/blob/1b5db680fee66e1d846d0396eb1a68d3fabdc3de/lib/net/ssh/key_factory.rb#L72
    data.match(/ENCRYPTED/)
  end

  # Whether the key data in {#data} is a private key.  Only private keys are supported as public keys cannot be used
  # as {Metasploit::Credential::Public#data}.
  #
  # @return [false] if {#data} does not contain `'-----BEGIN <type> PRIVATE KEY-----'` or {#data} is `nil`.
  # @return [true] if {#data} contains `'-----BEGIN <type> PRIVATE KEY-----'`.
  def private?
    return false unless data
    # @see https://github.com/net-ssh/net-ssh/blob/1b5db680fee66e1d846d0396eb1a68d3fabdc3de/lib/net/ssh/key_factory.rb#L56-L69
    data.match(/-----BEGIN (.+) PRIVATE KEY-----/)
  end

  # The {#data key data}'s fingerprint, suitable for displaying to the
  # user.
  #
  # @return [String]
  def to_s
    data ? openssl_pkey_pkey.fingerprint : ''
  end

  private

  # Converts the private key file data in {#data} to an `OpenSSL::PKey::PKey` subclass instance.
  #
  # @return [OpenSSL::PKey::PKey]
  # @raise [ArgumentError, OpenSSL::PKey::PKeyError] if {#data} cannot be loaded
  def openssl_pkey_pkey
    return unless data
    ask_passphrase = false
    filename = "#{self.class}#data"
    passphrase = nil

    Net::SSH::KeyFactory.load_data_private_key(data, passphrase, ask_passphrase, filename)
  end

  # Validates that {#data} contains a private key and NOT a public key or some other non-key data.
  #
  # @return [void]
  def private
    return if private?
    errors.add(:data, :not_private)
  end

  # Validates that {#data} can be read by Net::SSH and a `OpenSSL::PKey::PKey` created from {#data}.  Any exception
  # raised will be reported as a validation error.
  #
  # @return [void]
  def readable
    return unless data
    openssl_pkey_pkey
  rescue ArgumentError, OpenSSL::PKey::PKeyError => error
    errors[:data] << "#{error.class} #{error}"
  end

  # Validates that the private key is not encrypted as unencrypting the private key with its password is not supported:
  # the unencrypted version of the key should be generated using the password and stored instead.
  #
  # @return [void]
  def unencrypted
    return unless encrypted?
    errors.add(:data, :encrypted)
  end

  Metasploit::Concern.run(self)
end
