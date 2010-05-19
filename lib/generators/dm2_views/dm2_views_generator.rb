class DerbViewsGenerator < Rails::Generator::NamedBase

  attr_reader :model_name, :object_plural_name, :object_singular_name, :namespace_prefix

  def initialize(runtime_args, runtime_options = {})
    super(runtime_args, runtime_options)
    @model_name = get_model_name
    @object_singular_name = model_name.tableize.singularize
    @object_plural_name = model_name.tableize
    @namespace_prefix = class_path.blank? ? '' : "#{class_path.join("_")}_"
  end

  def add_options!(opt)
    opt.on('-S', '--skip_controller') { |value| options[:skip_controller] = value }
  end

  def manifest
    record do |m|
      m.class_collisions "#{class_name}Controller", "#{class_name}ControllerTest", "#{class_name}Helper", "#{class_name}HelperTest"

      m.directory File.join('app/views', class_path, file_name)

      m.template('index.html.erb', File.join('app/views', class_path, file_name, "index.html.erb"))
      begin
        m.template('_object.html.erb', File.join('app/views', class_path, file_name, "_#{object_singular_name}.html.erb"))
      rescue
        puts "Problem creating _object partial. Do you really have #{class_name} model in place and migrations executed?"
      end

      m.template('show.html.erb', File.join('app/views', class_path, file_name, "show.html.erb"))
      m.template('edit.html.erb', File.join('app/views', class_path, file_name, "edit.html.erb"))
      m.template('new.html.erb', File.join('app/views', class_path, file_name, "new.html.erb"))

     # m.route :resource_name => plural_name, :only => actions, :namespace => class_path
    end
  end

  def self.field_type(type)
    case type
      when :integer, :float, :decimal then
        :text_field
      when :datetime, :timestamp, :time then
        :datetime_select
      when :date then
        :date_select
      when :string then
        :text_field
      when :text then
        :text_area
      when :boolean then
        :check_box
      else
        :text_field
    end
  end

  def get_model_name
    model_name = class_name.split(":").last.singularize
    begin
      model_name.constantize
    rescue
      raise "Model #{model_name} doesn't exist"
    end
    model_name
  end
end

module Rails
  module Generator
    module Commands

      class Base
        def route_code(route_options)
          "#{route_options[:namespace].blank? ? "map" : route_options[:namespace].last}.resources :#{route_options[:resource_name]}"
        end
      end

      class Create
        def route(route_options)
          sentinel = 'ActionController::Routing::Routes.draw do |map|'
          if (namespace = route_options[:namespace].last).nil?
            logger.route route_code(route_options)
            gsub_file 'config/routes.rb', /(#{Regexp.escape(sentinel)})/mi do |m|
              "#{m}\n #{route_code(route_options)}\n"
            end
          else
            f = File.open(File.join(RAILS_ROOT, "config", "routes.rb"), 'r')
            body = f.read
            f.close
            target_line = ''
            body.each_line do |line|
              if (line =~ /#/) == nil and line =~ /.namespace :#{namespace}/
                target_line = line
              end
            end

            if target_line.blank?
              body.sub! /(#{Regexp.escape(sentinel)})/mi do |m|
                "#{m}\n map.namespace :#{namespace} do |#{namespace}|\n  #{route_code(route_options)}\n end\n"
              end
            else
              body.sub!(target_line, "#{target_line}  #{route_code(route_options)}\n")
            end

            f = File.open(File.join(RAILS_ROOT, "config", "routes.rb"), 'w+')
            f.write(body)
            f.close
          end
        end
      end

      class Destroy
        def route(route_options)
          logger.remove_route route_code(route_options)
          to_remove = "\n #{route_code(route_options)}"
          gsub_file 'config/routes.rb', /(#{to_remove})/mi, ''
        end
      end

    end
  end
end
