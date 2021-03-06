module FluxboxAppsMenu

  class Menu

    def initialize(cfg = nil)
      @cfg = cfg.nil? ? FluxboxAppsMenu::Config.new : cfg
    end

    def assign_menu(cat, label)
      traverse_menu(@cfg.menu, cat.map(&:downcase), label)[0]
    end

    def render
      render_menu(@cfg.menu)
    end

    def item_exec(label, icon, command)
      menu_item(label, icon, 'exec', command)
    end

    def item_submenu(label, icon)
      menu_item(label, icon, 'submenu')
    end

    def item_separator
      menu_item('', '', 'separator')
    end

    # type = submenu, exec, separator
    private

    def menu_item(label, icon, type = 'exec', command = nil)
      str = []
      str << "[#{type}]"
      str << "(#{label.gsub(/(?<!\\)\)/, '\)')})" unless label.to_s.empty?
      str << "{#{command}}" unless command.nil?
      str << "<#{icon}>" unless icon.to_s.empty?

      str.join(' ')
    end

    def traverse_menu(menu, cat, label, selected_index = nil)
      #categories with smaller index are the favorites
      selected_index ||= 10000
      selected = nil

      items = menu.select { |k, v| k.class == String }

      items.each do |key, info|
        if info.class == Hash
          subitems = info.select { |k, v| k.class == String }

          # when a label is set the path has high priority 
          return [info, 0] if info.has_key?(label)

          if info.has_key? :mandatory_categories
            info[:mandatory_categories] = info[:mandatory_categories].map(&:downcase)
            next unless (info[:mandatory_categories] & cat) == info[:mandatory_categories]
          end

          unless subitems.to_hash.empty?
            result, index = traverse_menu(subitems, cat, label, selected_index)
            selected, selected_index = result, index unless result.nil?
          end

          raise NoCategoriesError, key unless info.has_key? :categories

          categories = info[:categories].map { |s| s.downcase unless s.nil? }

          cat.each do |c|
            if categories.include?(c.strip)
              i = categories.index(c)
              if i < selected_index
                selected = info 
                selected_index = i
              end
            end
          end

        end
      end

      [selected, selected_index]
    end

    def render_menu(menu, level = 0)
      prefix = '  ' * (level)
      text = ''

      # sort the items but let menu folders at the top
      menu = menu.select { |k, v| k.class == String }.sort_by { |k, v| v.class == String ? k.downcase : '' }
      menu.each do |name, items|
        if items.class.to_s == 'Hash'
          icon = items[:icon]
          items = items.select { |k, v| k.class == String }
          subitems = render_menu(items, level + 1)

          unless subitems.empty?
            text += "#{prefix}#{item_submenu(name, @cfg.expand_icon(nil, icon))}\n#{subitems}#{prefix}[end]\n"
          end

        elsif items.class.to_s == 'String'
          text += prefix + items + "\n"
        end
      end

      text
    end

  end
end
