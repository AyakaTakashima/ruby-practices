# frozen_string_literal: true

require 'date'

class Detail
  FILE_TYPE_TABLE = {
    '04' => 'd',
    '10' => '-',
    '12' => 'l'
  }.freeze

  PERMISSION_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_detail)
    @file_detail = file_detail
  end

  def build_permission
    permission_digit = @file_detail[:mode].to_s(8).rjust(6, '0')
    [
      FILE_TYPE_TABLE[permission_digit[0..1]],
      PERMISSION_TABLE[permission_digit[3]],
      PERMISSION_TABLE[permission_digit[4]],
      PERMISSION_TABLE[permission_digit[5]]
    ].join
  end

  def build_updated_at
    file_creation_date = @file_detail[:atime].to_date
    half_years_ago = Date.today.prev_month(6)

    if file_creation_date <= half_years_ago
      @file_detail[:atime].strftime('%_m %_e  %Y')
    else
      @file_detail[:atime].strftime('%_m %_e %H:%M')
    end
  end
end
