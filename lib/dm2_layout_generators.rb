module Dm2LayoutHelper

  Dir.foreach(File.join(RAILS_ROOT, 'public', 'images', 'icons')) do |icon|
    if icon =~ /.gif|.png/
      caption = icon.gsub(/.gif|.png/, "")
      define_method("#{caption}_icon"){|*message| msg = (message and message.first) || caption.humanize; image_tag("icons/#{icon}", :alt => msg, :title => msg)}
    end
  end

  def show_on_tab(tabname)
    if tab == tabname
      yield
    end
  end

  def table_headers(*arr)
    options = arr.extract_options!
    arr = arr.shift if arr.first.is_a? Array

<<EOF
      <thead>
        <tr>
            <th class="lc"></th>
          #{arr.map{|label| label.include?('<th') ? label : content_tag(:th, label)}}
            <th class="rc"></th>
        </tr>
      </thead>
      <tfoot>
        <tr>
          <td class="lc"></td>
          <td colspan="#{options[:columns_count] || arr.size}"></td>
          <td class="rc"></td>
        </tr>
      </tfoot>
EOF
  end

  def menu_link_to(sub, *args, &block)
    options = args.clone.extract_options!
    class_name, tab_key = if sub
      ["sub_menu_item", :subtab]
    else
      ["main_menu_item", :tab]
    end
    content_tag(:li, link_to(*args, &block), :class => "#{class_name} #{'highlighted' if self.send(tab_key) == (options[:tab] || args.first.gsub(' ', '_').downcase)}")
  end


  public

  def main_menu_link_to(*args, &block)
    menu_link_to(false, *args, &block)
  end

  def sub_menu_link_to(*args, &block)
    menu_link_to(true, *args, &block)
  end

  def link_to(*args, &block)
    options = args.clone.extract_options!
    if icon = options[:icon]
      title = args.shift
      content_tag(:li, super(image_tag("icons/#{icon}.png", :title => title), *args, &block), :class => "iconed_link h_#{icon}")
    else
      super
    end
  end


  def link_to_function(name, *args, &block)
    options = args.clone.extract_options!
    if icon = options[:icon]
      content_tag(:li, super(image_tag("icons/#{icon}.png", :title => name), *args, &block), :class => "iconed_link h_#{icon}")
    else
      super
    end
  end

  def link_to_remote(name, options = {}, html_options = nil)
    if icon = options[:icon]
      content_tag(:li, super(image_tag("icons/#{icon}.png", :title => name), options, html_options), :class => "iconed_link h_#{icon}")
    else
      super
    end
  end


  def toggle_boolean(object, field, path)
    link_to_remote(image_tag(object.send(field) ? '/images/icons/selected.png' : '/images/icons/deselected.png'),
                   :url => path,
                   :method => :put,
                   :html => {:id => dom_id(object, "#{field.to_s}_toggler")},
                   :with => "'#{object.class.name.tableize.singularize}[#{field.to_s}]=#{!object.send(field)}'")
  end

end