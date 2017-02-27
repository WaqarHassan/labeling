desc 'Reset all data for demo servers'
task :reset_all_data => :environment do
  User.destroy_all
end


namespace :server_db do

	require 'aws-sdk'
  screets = YAML.load_file('config/secrets.yml')['production']

	s3_object = Aws::S3::Resource.new({
	  region: 'us-west-2',
	  credentials: Aws::Credentials.new(screets['s3_access_key'], screets['s3_secret_key'])
	})

  database = YAML.load_file('config/database.yml')['production']

  desc 'Backup DB and upload to S3'
  bd_name = 'labeling_sandbox'
  backup_file_name = "labeling-backup-#{Time.now.strftime('%Y%m%d')}.sql.gz"

  task :backup do
    opts = '--skip-extended-insert --skip-dump-date --lock-tables=false'
    ss = system "mysqldump -h #{database['host']} -u #{database['username']} -p#{database['password']} #{opts} #{bd_name} | gzip> #{backup_file_name}"
    puts "---------------#{ss.inspect}"

    obj = s3_object.bucket('ew-labeling-db-backups').object("#{backup_file_name}")
    obj.upload_file("#{backup_file_name}")

    FileUtils.rm_rf("#{backup_file_name}")
  end

end