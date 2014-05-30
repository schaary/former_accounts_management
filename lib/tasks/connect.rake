
namespace :idm do
  task :connect do
    plsql.connection = OCI8.new(
      Rails.application.secrets.idm_user,
      Rails.application.secrets.idm_password,
      Rails.application.secrets.idm_sid
    )
  end
end
