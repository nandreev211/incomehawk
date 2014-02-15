module ProjectsHelper
  def render_project(project)
    render :partial => "projects/#{project.status.downcase}_project", :locals => {:project => project}
  end

  def render_project_overview(project, show_status = false)
    render :partial => "projects/#{project.status.downcase}_project_overview", :locals => {:project => project, :show_status => show_status}
  end

  def render_projects_header(projects)
    proj = projects.first
    return unless proj
    render :partial => "projects/#{proj.status.downcase}_projects_header", :locals => {:projects => projects}
  end

  def progress_bar(percent)
    per_class = (percent/10).to_i*10
    per_class = "33" if (33..39).include? percent
    per_class = "66" if (66..69).include? percent
    content_tag :div, percent, :class => "bar-inner per#{per_class}"
  end
  
  def status_button_active(cls, project)
    "active" if cls == project.status.downcase
  end
end