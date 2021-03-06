class Setup

  attr_reader :person

  def initialize(params)
    @params = params
  end

  def execute!
    Person.transaction do
      @person = Person.new
      unless update_host!
        Site.current.errors.full_messages.each do |msg|
          @person.errors.add :base, msg
        end
        return false
      end
      if update_person!
        update_admin_settings!
        update_stream_item!
        true
      else
        raise ActiveRecord::Rollback
        false
      end
    end
  end

  def update_person!
    @person.first_name = @params[:person][:first_name]
    @person.last_name = @params[:person][:last_name]
    @person.email = @params[:person][:email]
    @person.password = @params[:person][:password].presence
    @person.password_confirmation = @params[:person][:password_confirmation].presence
    unless @person.password and @person.password == @person.password_confirmation
      @person.errors.add :error, I18n.t('accounts.set_password_error')
      return false
    end
    unless @person.email.present?
      @person.errors.add :email, I18n.t('activerecord.errors.models.person.attributes.email.invalid')
      return false
    end
    @person.can_sign_in = true
    @person.visible_to_everyone = true
    @person.visible_on_printed_directory = true
    @person.full_access = true
    @person.child = false
    @person.family = Family.create!(
      name:      @person.name,
      last_name: @person.last_name
    )
    @person.admin = Admin.create!(super_admin: true)
    @person.save
  end

  def update_host!
    if @params[:domain_name].present?
      Site.current.host = @params[:domain_name]
      Site.current.save
    else
      false
    end
  end

  def update_admin_settings!
    Setting.set_global('Contact', 'Bug Notification Email', @person.email)
    Setting.set('Contact', 'Tech Support Email', @person.email)
  end

  def update_stream_item!
    Site.current.update_stream_item(@person)
  end

end
