# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end
#	To generate cronjobs
#	bundle exec whenever
# Learn more: http://github.com/javan/whenever

set :output, "/var/plantao/log/cron.log"


every '0 6 * * *' do 
  runner "Job.reminderMorning"
end

every '0 11 * * * ' do 
 runner "Job.reminderAfternoon"
end

every '0 17 * * *' do 
 runner "Job.reminderNight"
end

every '* * * * *' do 
 runner "Job.closeJob"
end




