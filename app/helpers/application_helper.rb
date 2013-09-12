module ApplicationHelper
   def get_users(users,role)
   users.select do |user|
     user.role == role
   end
  end

  # Arguments
  #   - pages collection (generated from the model)
  #   - current controller (for proper page linking)
  #   - current page (got from params)
  def create_pagination(pages,controller,current_page)
    pagination = ""
    params[:controller] = controller
    current_page = 1 if current_page.nil?
    if pages.length > 1
      pagination << link_to('&lt;', {:params => params.merge('page' => pages.first)}) << " "
    end
    if pages.length > 1
      pages.each do |page|
        if (page.number < current_page.to_i+6) && (page.number > current_page.to_i-6)
          if current_page.to_i == page.number
            pagination << page.number.to_s << " "
          else
            pagination << link_to(page.number, {:params => params.merge('page' => page)}) << " "
          end
        end
      end
    end
    if pages.length > 1
      pagination << link_to('&gt;', {:params => params.merge('page' => pages.last)}) << " "
    end
    return pagination
  end

   def errors_for(object, message=nil)
    html = ""
    unless object.errors.blank?
      html << "<div class='errorExplanation' id='errorExplanation'>\n"
      if message.blank?
        if object.new_record?
          html << "\t\t<h2>#{object.errors.full_messages.length} errors prohibited this user from being saved</h2>\n"
        else
          html << "\t\t<h2>#{object.errors.full_messages.length} errors prohibited this user from being saved</h2>\n"
        end
      else
        html << "<h5>#{message}</h5>"
      end
      html << "\t\t<ul>\n"
      object.errors.full_messages.each do |error|
        html << "\t\t\t<li>#{error}</li>\n"
      end
      html << "\t\t</ul>\n"
      html << "\t</div>\n"
    end
    html.html_safe
  end 

  def app_ver
    "1.3 (20071031010247)"
  end

  def format_date(date)
    date.strftime('%m/%d')
  end

  def format_datetime(datetime)
    datetime.strftime('%m/%d %H:%M')
  end

  def format_percentage(percent)
    formatted_percentage = sprintf("%0.2f", percent)
    if formatted_percentage.to_f >= 100.0 or formatted_percentage.to_f <= 0.0
      percent.to_i
    else
      formatted_percentage
    end
  end

  def legend_start
    "<div id='legend'><dl>".html_safe
  end

  def legend(hash)
    "<dt class='#{hash['color']}'></dt><dd>#{hash['text']}</dd>".html_safe
  end

  def legend_end
    "</dl></div>".html_safe
  end

  # Helpers for sorting
  def sort_td_class_helper(my_param)
    result = ' <img src="/assets/arrowup.png"/>' if params[:sort] == my_param
    result = ' <img src="/assets/arrowdown.png"/>' if params[:sort] == my_param + "_reverse"
    return result
  end

  def sort_link_helper(text, param, controller, action)
    key = param
    key += "_reverse" if params[:sort] == param
    params[:controller] = controller

    options = {
      :url => {:action => action, :params => params.merge({:sort => key, :page => params[:page]})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')"
    }

    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => action, :params => params.merge({:sort => key, :page => params[:page]}))
    }

    link_to_remote(text, options, html_options)
  end

  def optionize(*args)
    result = ""
    args.each do |arg|
      result = result + "<option>#{arg}</option>"
    end
    return result.html_safe
  end

  def optionize_custom(list, selected)
    result = ""
    list.each do |arg|
      if arg == selected
        result = result + "<option selected=\"selected\">#{arg}</option>"
      else
        result = result + "<option>#{arg}</option>"
      end
    end
    return result
  end

  def set_focus(id)
    
    "<script language='javascript'>
        <!--
                document.getElementById('#{id}').focus()
        //-->
    </script>".html_safe

  end

  def date_picker(elem, format, separator)
    return "<a href=\"javascript:displayDatePicker('#{elem}', false, '#{format}', '#{separator}')\">#{image_tag('date.png', :alt => "Pick Date", :title => "Pick Date")}</a>"
  end

  def spacer(*counts)
    spacer = "&nbsp;"
    spacers = ""
    if counts.blank?
      return spacer
    else
      counts[0].to_i.times do |c|
        spacers << spacer
      end
      return spacers
    end
  end

  #Converting given EST time into IST time
  def convert_to_ist_time(time)
    tz_est = Timezone.get('US/Eastern')
    utc_time = tz_est.local_to_utc(time, false)
    tz_ist = Timezone.get('Asia/Calcutta')
    ist_time = tz_ist.utc_to_local(utc_time)
    return ist_time
  end

  #Converting given IST time into EST time
  def convert_to_est_time(time)
    tz_ist = Timezone.get('Asia/Calcutta')
    utc_time = tz_ist.local_to_utc(time, false)
    tz_est = Timezone.get('US/Eastern')
    est_time = tz_est.utc_to_local(utc_time)
    return est_time
  end

  #START 1500 OCR enhancement - Populate the patient details in insured field if it is mentioned as 'SAME"

  def populate_patient_name_details(patientinfo,value)
    if patientinfo
       if ((patientinfo.insured_last_name == "SAME") || (patientinfo.insured_first_name == "SAME"))
         val = "patient_#{value}"
         patientinfo.send(val)
       else
         val = "insured_#{value}"
         patientinfo.send(val)
       end
    end
  end

  def populate_patient_address_details(patientinfo,value)
    if patientinfo
       if (patientinfo.insured_address == "SAME")
         val = "patient_#{value}"
         patientinfo.send(val)
       else
         val = "insured_#{value}"
         patientinfo.send(val)
       end
    end
  end

  def colorcode_patient_name_details(patientinfo,value)
    if patientinfo
       if ((patientinfo.insured_last_name == "SAME") || (patientinfo.insured_first_name == "SAME"))
            "patient_#{value}"
       else
            "insured_#{value}"
       end
    end
  end

  def colorcode_patient_address_details(patientinfo,value)
    if patientinfo
       if (patientinfo.insured_address == "SAME")
            "patient_#{value}"
       else
            "insured_#{value}"
       end
    end
  end
  #END 1500 OCR enhancement - Populate the patient details in insured field if it is mentioned as 'SAME"

  def display_state(patientinfo)
    if patientinfo
       patientinfo.state
    end
 end

  def display_patient_details(patientinfo,patient_informations,val1,val2)
    if patient_informations

      patient_informations.send(val2)
    else
    if patientinfo
         val = "#{val1}"
         patientinfo.send(val)
    end
    end
  end
end
