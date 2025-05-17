class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :switch_locale
  include SessionsHelper
  # to see in views and controllers

  def next_image
    current_index = params[:index].to_i
    theme_id = params[:theme_id].to_i
    length = params[:length].to_i

    new_image_index = next_index(current_index, length)
    next_image_data = show_image(theme_id, new_image_index)

    respond_to do |format|
      if new_image_index.blank?
        format.html{render nothing: true, status:
          :unprocessable_entity}
        format.json {}
      else
        format.html{render display_theme_path, status:
          :successfully}
        format.json{render json:
                             {new_image_index: next_image_data[:index],
                              name: next_image_data[:name],
                              file: next_image_data[:file],
                              image_id: next_image_data[:image_id],
                              user_valued: next_image_data[:user_valued],
                              common_ave_value:
                                next_image_data[:common_ave_value],
                              value: next_image_data[:value],
                              status: :successfully,
                              notice: 'Successfully listed to next'} }
      end
    end
  end

  def next_index(index, length)
    new_index = index
    index < length-1 ? new_index += 1 : new_index = 0
    new_index
  end

  def prev_index(index, length)
    new_index = index
    index > 0 ? new_index -= 1 : new_index = length-1
    new_index
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end


end
