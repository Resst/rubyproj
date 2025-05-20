class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  around_action :switch_locale

  include WorkImage
  include SessionsHelper
  # to see in views and controllers


  def set_value
    image_id = params[:image_id]
    value = params[:value]
    user_id = params[:user_id]
    @value = Value.find_by(image_id: image_id, user_id: user_id)
    if @value == nil
      @value = Value.new(
        image_id: image_id,
        value: value,
        user_id: user_id
      )
      @value.save
    else
      @value.value = value
      @value.save
    end
  end

  def get_theme
    theme_id = params[:theme_id]
    theme_images = Image.theme_images(theme_id)
    first_image = theme_images.first
    respond_to do |format|
      format.json {
        render json: {
          image_length: theme_images.length,
          image_data: {
            id: first_image.id,
            name: first_image.name,
            file: first_image.file,
            ave_value: first_image.ave_value
          }
        }
      }
    end
  end

  def get_prev_image
    theme_id = params[:theme_id]
    image_id = params[:image_id]
    image = Image.prev_image(theme_id, image_id)
    respond_to do |format|
      format.json {
        render json: {
          image_data: {
            id: image.id,
            name: image.name,
            file: image.file,
            ave_value: image.ave_value
          }
        }
      }
    end
  end

  def get_value_for_image
    user_id = current_user.id
    image_id = params[:image_id]
    respond_to do |format|
      format.json {
        render json: {
          value: Value.find_by(image_id: image_id, user_id: user_id)
        }
      }
    end
  end
  def get_next_image
    theme_id = params[:theme_id]
    image_id = params[:image_id]
    image = Image.next_image(theme_id, image_id)
    respond_to do |format|
      format.json {
        render json: {
          image_data: {
            id: image.id,
            name: image.name,
            file: image.file,
            ave_value: image.ave_value
          }
        }
      }
    end
  end
  def next_image
    current_index = params[:index].to_i
    theme_id = params[:theme_id].to_i
    length = params[:length].to_i
    length = Image.find_by(theme_id: theme_id).count
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
