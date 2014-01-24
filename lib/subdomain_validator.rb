class SubdomainValidator < ActiveModel::EachValidator

  def validate_each(object, attribute, value)
    return unless value.present?

    reserved_names = %w(www ftp mail pop smtp admin ssl sftp)
    reserved_names = options[:reserved] if options[:reserved]

    if reserved_names.include?(value)
      object.errors[attribute] << I18n.t('validators.subdomain.reserved')
    end

    object.errors[attribute] <<  I18n.t('validators.subdomain.length') unless (3..63) === value.length
    object.errors[attribute] <<  I18n.t('validators.subdomain.hyphen') unless value =~ /^[^-].*[^-]$/i
    object.errors[attribute] <<  I18n.t('validators.subdomain.chars') unless value =~ /^[a-z0-9\-]*$/i
  end

end
