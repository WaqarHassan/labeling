desc 'Reset all data for demo servers'
task :reset_all_data => :environment do
  User.destroy_all
end


task :db_backup => :environment do

	require 'aws-sdk'
	s3 = Aws::S3::Resource.new({
	  region: 'us-west-2',
	  credentials: Aws::Credentials.new('AKIAIM32WGZHPTOVUJRA', 'FJO/oVqcrfbFB8rBr7qwMaz2eDsOnpsWa0mR5iZD')
	})

	obj = s3.bucket('ew-labeling-db-backups').object('appointment_harley.csv')
	obj.upload_file('appointment_harley.csv')

end