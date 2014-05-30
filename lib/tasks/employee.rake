# encoding: utf-8

namespace :idm do

  desc 'notifies former employee about the upcoming deletion of their accounts'
  task :employee => [:connect, :environment] do
    initialize_time_slots

    employee_accounts = convert_to_hash(fetch_accounts)
    ap employee_accounts
  end

  def fetch_accounts
    records = {}
    plsql.mitarbeiter_account_pkg.expiredUserList do |cursor|
      records = cursor.fetch_all
    end
    records
  end

  def convert_to_hash list
    list.inject([]) do |new_list, array|
      new_list.push(
       {uid: array[3],
        mail: array[4],
        firstname: array[1],
        lastname: array[0],
        gender: array[2],
        #title: array[5],
        endtime: make_date(array[5]),
        endtime_group: select_endtime_group(make_date(array[5]))}
      )
    end
  end

  def initialize_time_slots
    @time_slots = {
      zero:  {start: Time.now.months_ago(0).at_beginning_of_month, 
              end:   Time.now.months_ago(0).at_end_of_month},
      one:   {start: Time.now.months_ago(1).at_beginning_of_month, 
              end:   Time.now.months_ago(1).at_end_of_month},
      two:   {start: Time.now.months_ago(2).at_beginning_of_month, 
              end:   Time.now.months_ago(2).at_end_of_month},
      three: {start: Time.now.months_ago(3).at_beginning_of_month, 
              end:   Time.now.months_ago(3).at_end_of_month},
      four:  {start: Time.now.months_ago(4).at_beginning_of_month, 
              end:   Time.now.months_ago(4).at_end_of_month},
      five:  {start: Time.now.months_ago(5).at_beginning_of_month, 
              end:   Time.now.months_ago(5).at_end_of_month},
      six:   {start: Time.now.months_ago(6).at_beginning_of_month, 
              end:   Time.now.months_ago(6).at_end_of_month},
      seven: {start: Time.now.months_ago(24).at_beginning_of_month, 
              end:   Time.now.months_ago(7).at_end_of_month},
    }
  end

  def select_endtime_group date
    return :seven if date.nil?

    @time_slots.select { |k,v| (v[:start]..v[:end]).cover? date }.keys.first
  end

  def make_date date
    return nil if date.nil?

    Date.parse date
  end

end
