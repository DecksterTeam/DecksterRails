module ApplicationHelper
  def color_average *colors_to_avg
    n = colors_to_avg.count
    totals = colors_to_avg.reduce({r: 0, b: 0, g: 0}) do |accum, str|
      p = {}
      p[:r], p[:g], p[:b] = str.split(/([0-9a-fA-F]{2})/).select { |x| not x.empty? }.map { |s| Integer(s, 16) }

      accum.merge!(p) { |k, o, n| o + n }
    end
    "#{(totals[:r]/n).to_s(16)}#{(totals[:g]/n).to_s(16)}#{(totals[:b]/n).to_s(16)}"
  end

  def hashes_to_table hashes, additional_stop_list=nil
    stop_list = /class|id\z|meta_type_s_m|event_i_m|_version_|tags_s_M#{additional_stop_list}/
    html = []
    html << '<table><thead>'
    columns = hashes.collect { |h| h.keys.select { |k| !stop_list.match k } }.flatten.uniq
    html << '<tr>'
    html << columns.collect { |c| "<th>#{c.gsub(/_[a-zA-Z]_[a-zA-Z](_[a-zA-Z])?\z/, '').titlecase}</th>" }.join('')
    html << '</tr>'
    html << '</thead><tbody>'
    hashes.each do |hash|"app"
      html << '<tr>'
      columns.each do |c|
        value = hash[c]
        value = value.join('<br/>') if value.is_a? Array
        html << "<td>#{value}</td>"
      end
      html << '</tr>'
    end
    html << '</tbody></table>'

    html.join('').html_safe
  end
end
