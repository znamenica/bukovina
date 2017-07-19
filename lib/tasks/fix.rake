namespace :fix do
   desc "Fix base year of memory"
   task base_year: :environment do
      Bukovina::Tasks.fix_base_year

      true; end

   desc "Fix memo dates"
   task memo_dates: :environment do
      Bukovina::Tasks.fix_memo_date

      true; end;end
