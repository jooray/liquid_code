require 'RMagick'
require 'rqrcode'
require 'active_support/all'

class LiquidCode
  def initialize(qr)
    unless qr.is_a?(RQRCode::QRCode)
      # convert input's string represantation to qr_code
      qr = RQRCode::QRCode.new( qr.to_s, :size => LiquidCode.minimum_qr_size_from_string(qr.to_s), :level => :h )
    end

    @qr = qr

  end
  def as_png(bgcolor='white', fgcolor='black', fgcolorwhite=true, block_size=16)
    image_size=((@qr.modules.size+1) * block_size)
    canvas_image = Magick::ImageList.new
    canvas_image.new_image(image_size, image_size) do
      self.background_color = bgcolor
      self.format = "png"
    end

    canvas = Magick::Draw.new

    draw_to_canvas(bgcolor, fgcolor, fgcolorwhite, canvas, 0, 0, block_size)

    canvas.draw(canvas_image)
    canvas_image.to_blob
  end

  def draw_to_canvas(bgcolor, fgcolor, fgcolorwhite, canvas, ox, oy, bs)

    image_size=@qr.modules.size * bs
    canvas.stroke(bgcolor)
    canvas.fill(bgcolor)
    canvas.rectangle(ox, oy, ox + image_size, oy + image_size)
    canvas.stroke(fgcolor)
    canvas.fill(fgcolor)
    canvas.fill_opacity(1)
    canvas.stroke_width(1)

    # half block size
    hbs = bs/2

    is_dark = lambda { |x, y|
      begin
        return ((@qr.is_dark(y, x) and fgcolorwhite) or ((not @qr.is_dark(y, x)) and (not fgcolorwhite)))
      rescue IndexError, RQRCode::QRCodeRunTimeError
        return (not fgcolorwhite)
      end
    }

    @qr.modules.each_index do |x|
      @qr.modules.each_index do |y|
        if is_dark.call(x, y)
          canvas.roundrectangle(ox+(x * bs), oy+(y * bs), ox+((x+1) * bs), oy+((y+1) * bs), hbs, hbs)
          if (is_dark.call(x, y+1))
            canvas.rectangle(ox+(x * bs), oy+(y * bs)+hbs, ox+((x+1) * bs), oy+((y+1) * bs)+hbs)
          end
          if (is_dark.call(x+1, y))
            canvas.rectangle(ox+(x * bs)+hbs, oy+(y * bs), ox+((x+1) * bs)+hbs, oy+((y+1) * bs))
          end

        end
      end
    end

    @qr.modules.each_index do |x|
      @qr.modules.each_index do |y|
        if (not is_dark.call(x, y))

          # I am white

          # upper right corner should be round
          if (is_dark.call(x+1, y) and is_dark.call(x, y-1) and is_dark.call(x+1, y-1))
            canvas.rectangle(ox+(x * bs)+hbs, oy+(y * bs), ox+((x+1) * bs), oy+((y) * bs)+hbs)
          end

          # lower right corner should be round
          if (is_dark.call(x+1, y) and is_dark.call(x+1, y+1) and is_dark.call(x, y+1))
            canvas.rectangle(ox+(x * bs)+hbs, oy+(y * bs)+hbs, ox+((x+1) * bs), oy+((y+1) * bs))
          end

          # lower left corner should be round
          if (is_dark.call(x-1, y) and is_dark.call(x-1, y+1) and is_dark.call(x, y+1))
            canvas.rectangle(ox+(x * bs), oy+(y * bs)+hbs, ox+(x * bs)+hbs, oy+((y+1) * bs))
          end

          # upper left corner should be round
          if (is_dark.call(x-1, y-1) and is_dark.call(x-1, y) and is_dark.call(x, y-1))
            canvas.rectangle(ox+(x * bs), oy+(y * bs), ox+(x * bs)+hbs, oy+(y * bs)+hbs)
          end

          canvas.fill(bgcolor)
          canvas.stroke(bgcolor)
          canvas.roundrectangle(ox+(x * bs)+1, oy+(y * bs)+1, ox+((x+1) * bs)-1, oy+((y+1) * bs)-1, hbs, hbs)
          canvas.stroke(fgcolor)
          canvas.fill(fgcolor)

        end
      end
    end

  end

  def LiquidCode.minimum_qr_size_from_string(str)
    sizes = [7, 14, 24, 34, 44, 58, 64, 84, 98, 119, 137, 155, 177, 194]
    sizes.each_index do |i|
      if str.length <= sizes[i]
        return i+1
      end
    end
    return -1
  end

end
