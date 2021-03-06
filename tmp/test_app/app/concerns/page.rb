# This concern provides behavior that all CMS pages have in common. It is
# similar to a +Widget+, as it allows to add behavior by composition instead of
# inheritance.
module Page
  # By default pages display a breadcrumb navigation. Either add a
  # boolean cms attribute +show_breadcrumbs+ or override the method directly
  # in your page model.
  def show_breadcrumbs?
    true
  end

  # Returns all breadcrumb pages. A breadcrumb page must be a +Page+ and needs
  # to allow to be displayed in the navigation. Both +Root+ and +Website+ are
  # not pages, so only pages up to the homepage are displayed.
  def breadcrumbs
    list = ancestors.select { |obj| obj.is_a?(Page) && obj.show_in_navigation? }
    list + [self]
  end

  def page
    self
  end

  # Overriden method +toclist+ from +RailsConnector::BasicObj+.
  #
  # Sorts toclist objects by their sort key and only selects Page objects that
  # should be displayed in the navigation. Both, +sort_key+ and
  # +show_in_navigation?+ methods are defined for every cms object.
  def toclist
    list = super.select { |obj| obj.is_a?(Page) && obj.show_in_navigation? }
    list.sort_by { |obj| obj.sort_key.to_s }
  end

  # Overriden method +title+ from +RailsConnector::BasicObj+.
  def title
    [super().presence, homepage.title].compact.join(' - ')
  end
end