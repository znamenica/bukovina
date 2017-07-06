namespace :fix do
   desc "Fix memo dates"
   task memo_dates: :environment do
      Bukovina::Tasks.fix_memo_date

      true; end;end
