module Cms
  module Attributes
    # This is an enum attribute concern. It should be included via +include
    # Cms::Attributes::<%= class_name %>+ in all CMS models that use this attribute.
    module <%= class_name %>
      def <%= file_name %>
        self[:<%= file_name %>].to_s
      end
    end
  end
end